




import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/product/data/respositories/product_repositories.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProductUseCaseParams{
  final String productId;
  final String? farmerId;
  final String? productName;
  final double? price;
  final String? unitType;
  final String? status;
  final double? quantity;
  final String? description;
  final File? image;

  UpdateProductUseCaseParams({
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.image, required this.productId,
  });
}

final updateProductUsecasesProvider = Provider<UpdateProductUsecases>((ref) {
  return UpdateProductUsecases(
    iProductRepository: ref.read(productRepositoryProvider),
  );
});


class UpdateProductUsecases implements UsecaseWithParams<bool, UpdateProductUseCaseParams>{
  final IProductRepository _iProductRepository;

  UpdateProductUsecases({required IProductRepository iProductRepository})
    : _iProductRepository = iProductRepository;
  @override
  Future<Either<Failure, bool>> call(UpdateProductUseCaseParams params) {
    final entity = ProductEntities(
      id: params.productId,
      farmerId: params.farmerId,
      productName: params.productName,
      price: params.price,
      unitType: params.unitType,
      status: params.status,
      quantity: params.quantity,
      description: params.description,
    );
    return _iProductRepository.updateProduct(entity, params.productId, params.image);
  }
}