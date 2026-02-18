
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/farmer/product/data/datasources/product_datasources.dart';
import 'package:farm_express/features/farmer/product/data/datasources/remote/product_remote_datasources.dart';
import 'package:farm_express/features/farmer/product/data/models/product_api_model.dart';
import 'package:farm_express/features/farmer/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/farmer/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepositories>((
  ref,
) {
  return ProductRepositories(
    iProductRemoteDataSource: ref.read(
      productRemoteDataSourceProvider,
    ),
  );
});

class ProductRepositories implements IProductRepository {
  final IProductRemoteDataSource _iProductRemoteDataSource;

  ProductRepositories({
    required IProductRemoteDataSource iProductRemoteDataSource,
  }) : _iProductRemoteDataSource = iProductRemoteDataSource;



  @override
  Future<Either<Failure, ProductEntities>> addProduct(ProductEntities data, File? image) async {
    try {
      final newData = ProductApiModel.fromEntity(data);
      final response = await _iProductRemoteDataSource.addProduct(newData, image);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductEntities>>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductEntities>>> getProductsByFarmerId(String farmerId) {
    // TODO: implement getProductsByFarmerId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProductEntities>> updateProduct(ProductEntities data) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

}