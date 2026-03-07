import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
import 'package:farm_express/core/services/hive/hive_service.dart';
import 'package:farm_express/core/services/image_cache/image_cache_service.dart';
import 'package:farm_express/features/product/data/datasources/product_datasources.dart';
import 'package:farm_express/features/product/data/datasources/remote/product_remote_datasources.dart';
import 'package:farm_express/features/product/data/models/product_api_model.dart';
import 'package:farm_express/features/product/data/models/product_hive_model.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepositories>((ref) {
  return ProductRepositories(
    iProductRemoteDataSource: ref.read(productRemoteDataSourceProvider),
    hiveService: ref.read(hiveServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
    imageCacheService: ref.read(imageCacheServiceProvider),
  );
});

class ProductRepositories implements IProductRepository {
  final IProductRemoteDataSource _iProductRemoteDataSource;
  final HiveService _hiveService;
  final INetworkInfo _networkInfo;
  final ImageCacheService _imageCacheService;

  ProductRepositories({
    required IProductRemoteDataSource iProductRemoteDataSource,
    required HiveService hiveService,
    required INetworkInfo networkInfo,
    required ImageCacheService imageCacheService,
  }) : _iProductRemoteDataSource = iProductRemoteDataSource,
       _hiveService = hiveService,
       _networkInfo = networkInfo,
       _imageCacheService = imageCacheService;

  @override
  Future<Either<Failure, ProductEntities>> addProduct(
    ProductEntities data,
    File? image,
  ) async {
    try {
      final newData = ProductApiModel.fromEntity(data);
      final response = await _iProductRemoteDataSource.addProduct(
        newData,
        image,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String productId) async {
    try {
      final response = await _iProductRemoteDataSource.deleteProduct(productId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductWithPaginationEntity>> getAllProducts({
    required int page,
    required int size,
    String? search,
  }) async {
    try {
      // Call remote datasource
      final response = await _iProductRemoteDataSource.getAllProducts(
        page: page,
        size: size,
        search: search,
      );

      // Save to Hive for offline access
      final hiveModels = response.products!
          .map((e) => ProductHiveModel.fromEntity(e.toEntity()))
          .toList();
      await _hiveService.saveProducts(hiveModels);

      // Cache product images in the background (non-blocking)
      final imageUrls = response.products!
          .where((p) => p.productImage != null && p.productImage!.isNotEmpty)
          .map((p) => ApiEndpoints.serverUrl + p.productImage!)
          .toList();
      _imageCacheService.cacheImages(imageUrls).ignore();

      // response should include both products and pagination
      final products = response.products!.map((e) => e.toEntity()).toList();
      final pagination = Pagination(
        page: response.pagination!.page,
        size: response.pagination!.size,
        total: response.pagination!.total,
        totalPages: response.pagination!.totalPages,
      );

      return Right(
        ProductWithPaginationEntity(products: products, pagination: pagination),
      );
    } catch (e) {
      // If offline, try to return cached products
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        try {
          final cachedProducts = await _hiveService.getAllProducts();
          if (cachedProducts.isNotEmpty) {
            final products = cachedProducts.map((e) => e.toEntity()).toList();
            // Return with a default pagination since we're offline
            final pagination = Pagination(
              page: 1,
              size: products.length,
              total: products.length,
              totalPages: 1,
            );
            return Right(
              ProductWithPaginationEntity(
                products: products,
                pagination: pagination,
              ),
            );
          }
        } catch (cacheError) {
          return Left(CacheFailure(message: "No cached data available"));
        }
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntities>>> getProductsByFarmerId() async {
    try {
      final response = await _iProductRemoteDataSource.getProductsByFarmerId();

      // Save to Hive for offline access
      final hiveModels = response
          .map((e) => ProductHiveModel.fromEntity(e.toEntity()))
          .toList();
      await _hiveService.saveProducts(hiveModels);

      // Cache product images in the background (non-blocking)
      final imageUrls = response
          .where((p) => p.productImage != null && p.productImage!.isNotEmpty)
          .map((p) => ApiEndpoints.serverUrl + p.productImage!)
          .toList();
      _imageCacheService.cacheImages(imageUrls).ignore();

      return Right(response.map((e) => e.toEntity()).toList());
    } catch (e) {
      // If offline, try to return cached products
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        try {
          final cachedProducts = await _hiveService.getAllProducts();
          if (cachedProducts.isNotEmpty) {
            return Right(cachedProducts.map((e) => e.toEntity()).toList());
          }
        } catch (cacheError) {
          return Left(CacheFailure(message: "No cached data available"));
        }
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(
    ProductEntities data,
    String productId,
    File? image,
  ) async {
    try {
      final newData = ProductApiModel.fromEntity(data);
      final response = await _iProductRemoteDataSource.updateProduct(
        newData,
        productId,
        image,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
