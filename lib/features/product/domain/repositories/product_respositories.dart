import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

abstract class IProductRepository {
  Future<Either<Failure, ProductEntities>> addProduct(
    ProductEntities data,
    File? image,
  );
  Future<Either<Failure, ProductWithPaginationEntity>> getAllProducts({
    required int page,
    required int size,
    String? search,
  });
  Future<Either<Failure, bool>> updateProduct(ProductEntities data,String productId, File? image);
  Future<Either<Failure, bool>> deleteProduct(String productId);
  Future<Either<Failure, List<ProductEntities>>> getProductsByFarmerId();
}
