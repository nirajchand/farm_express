

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/product/data/respositories/product_repositories.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllProductsUsecasesProvider = Provider<GetAllproductsUsecases>((ref) {
  return GetAllproductsUsecases(
    iProductRepository: ref.read(productRepositoryProvider),
  );
});

class GetAllproductsUsecases implements UseecaseWithoutParams  {
  final IProductRepository _iProductRepository;
  
  const GetAllproductsUsecases({required IProductRepository iProductRepository})
    : _iProductRepository = iProductRepository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _iProductRepository.getAllProducts();
  }
}