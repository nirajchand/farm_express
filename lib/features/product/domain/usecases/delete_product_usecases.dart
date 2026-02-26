import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/product/data/respositories/product_repositories.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteProductUsecasesProvider = Provider<DeleteProductUsecases>((ref) {
  return DeleteProductUsecases(
    iProductRepository: ref.read(productRepositoryProvider),
  );
});

class DeleteProductUsecases implements UsecaseWithParams<bool, String> {
  final IProductRepository _iProductRepository;

  const DeleteProductUsecases({required IProductRepository iProductRepository})
      : _iProductRepository = iProductRepository;

  @override
  Future<Either<Failure, bool>> call(String productId) {
    return _iProductRepository.deleteProduct(productId);
  }
}