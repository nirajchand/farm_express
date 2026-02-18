


import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/farmer/product/data/respositories/product_repositories.dart';
import 'package:farm_express/features/farmer/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/farmer/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductUseCaseParams{
  final String? farmerId;
  final String? productName;
  final double? price;
  final String? unitType;
  final String? status;
  final double? quantity;
  final String? description;
  final File? image;

  AddProductUseCaseParams({
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.image,
  });
}

final addProductUsecasesProvider = Provider<AddProductUsecases>((ref) {
  return AddProductUsecases(
    iProductRepository: ref.read(productRepositoryProvider),
  );
});


class AddProductUsecases implements UsecaseWithParams<ProductEntities, AddProductUseCaseParams>{
  final IProductRepository _iProductRepository;

  AddProductUsecases({required IProductRepository iProductRepository})
    : _iProductRepository = iProductRepository;
  @override
  Future<Either<Failure, ProductEntities>> call(AddProductUseCaseParams params) {
    final entity = ProductEntities(
      farmerId: params.farmerId,
      productName: params.productName,
      price: params.price,
      unitType: params.unitType,
      status: params.status,
      quantity: params.quantity,
      description: params.description,
    );
    return _iProductRepository.addProduct(entity, params.image);
  }
}