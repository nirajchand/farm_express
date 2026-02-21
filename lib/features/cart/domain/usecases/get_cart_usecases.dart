

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/cart/data/repositories/cart_repositories.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCartUsecasesProvider = Provider<GetCartUsecases>((ref) {
  return GetCartUsecases(
    iCartRepositories: ref.read(cartRepositoriesProvider),
  );
});

class GetCartUsecases implements UseecaseWithoutParams {
  final ICartRepositories _iCartRepositories;

  const GetCartUsecases({
    required ICartRepositories iCartRepositories,
  }) : _iCartRepositories = iCartRepositories;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _iCartRepositories.getCart();
  }
}