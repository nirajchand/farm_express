import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/cart/data/repositories/cart_repositories.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteCartItemUsecasesProvider = Provider<DeleteCartItemUsecases>((ref) {
  final cartRepository = ref.read(cartRepositoriesProvider);
  return DeleteCartItemUsecases(iCartRepositories: cartRepository);
});

class DeleteCartItemUsecases implements UsecaseWithParams<bool, String> {
  final ICartRepositories _iCartRepositories;
  const DeleteCartItemUsecases({required ICartRepositories iCartRepositories})
    : _iCartRepositories = iCartRepositories;

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _iCartRepositories.removeProductFromCart(params);
  }
}
