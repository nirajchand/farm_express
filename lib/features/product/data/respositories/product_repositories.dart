import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/product/data/datasources/product_datasources.dart';
import 'package:farm_express/features/product/data/datasources/remote/product_remote_datasources.dart';
import 'package:farm_express/features/product/data/models/product_api_model.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepositories>((ref) {
  return ProductRepositories(
    iProductRemoteDataSource: ref.read(productRemoteDataSourceProvider),
  );
});

class ProductRepositories implements IProductRepository {
  final IProductRemoteDataSource _iProductRemoteDataSource;

  ProductRepositories({
    required IProductRemoteDataSource iProductRemoteDataSource,
  }) : _iProductRemoteDataSource = iProductRemoteDataSource;

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
      return Left(ServerFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<ProductEntities>>> getProductsByFarmerId() async {
    try {
      final response = await _iProductRemoteDataSource.getProductsByFarmerId();
      return Right(response.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(ProductEntities data, String productId, File? image) async {
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
