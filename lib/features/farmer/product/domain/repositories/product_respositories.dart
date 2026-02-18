
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/farmer/product/domain/entities/product_entities.dart';

abstract class IProductRepository {
  Future<Either<Failure, ProductEntities>> addProduct(ProductEntities data, File? image);
  Future<Either<Failure, List<ProductEntities>>> getProducts();
  Future<Either<Failure, ProductEntities>> updateProduct(ProductEntities data);
  Future<Either<Failure, void>> deleteProduct(String productId);
  Future<Either<Failure, List<ProductEntities>>> getProductsByFarmerId(String farmerId);
}