

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/cart/data/repositories/cart_repositories.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';
import 'package:farm_express/features/cart/domain/entities/cretate_cart_entities.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddCartUsecasesParams extends Equatable {
  final String productId;
  final int quantity;

  const AddCartUsecasesParams({
    required this.productId,
    required this.quantity,
  });
  
  @override
  List<Object?> get props => [productId, quantity];
}

final addCartUsecasesProvider = Provider<AddCartUsecases>((ref) {
  final cartRepository = ref.read(cartRepositoriesProvider);
  return AddCartUsecases(iCartRepositories: cartRepository);
});

class AddCartUsecases implements UsecaseWithParams<bool, AddCartUsecasesParams> {
  final ICartRepositories _iCartRepositories;

  const AddCartUsecases({
    required ICartRepositories iCartRepositories,
  }) : _iCartRepositories = iCartRepositories;
  
  @override
  Future<Either<Failure, bool>> call(AddCartUsecasesParams params) {
    final cartCreateEntities = AddCartEntity(
      productId: params.productId,
      quantity: params.quantity,
    );
    return _iCartRepositories.addProductToCart(cartCreateEntities);
  }
}