import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/cart/data/repositories/cart_repositories.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCartUsecasesParams extends Equatable {
  final String productId;
  final double quantity;
  const UpdateCartUsecasesParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

final updateCartUsecasesProvider = Provider<UpdateCartUsecases>((ref) {
  final cartRepository = ref.read(cartRepositoriesProvider);
  return UpdateCartUsecases(iCartRepositories: cartRepository);
});

class UpdateCartUsecases
    implements UsecaseWithParams<dynamic, UpdateCartUsecasesParams> {
  final ICartRepositories _iCartRepositories;

  const UpdateCartUsecases({required ICartRepositories iCartRepositories})
    : _iCartRepositories = iCartRepositories;

  @override
  Future<Either<Failure, dynamic>> call(UpdateCartUsecasesParams params) {
    return _iCartRepositories.updateCart(params.productId, params.quantity);
  }
}
