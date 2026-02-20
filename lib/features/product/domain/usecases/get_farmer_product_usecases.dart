

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/product/data/respositories/product_repositories.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFarmerProductUsecasesProvider = Provider<GetFarmerProductUsecases>((ref) {
  return GetFarmerProductUsecases(
    iProductRepository: ref.read(productRepositoryProvider),
  );
});

class GetFarmerProductUsecases implements UseecaseWithoutParams{

  final IProductRepository _iProductRepository;

  const GetFarmerProductUsecases({required IProductRepository iProductRepository})
    : _iProductRepository = iProductRepository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _iProductRepository.getProductsByFarmerId();
  }
}