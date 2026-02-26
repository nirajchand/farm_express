

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/cart/data/datasources/cart.datasources.dart';
import 'package:farm_express/features/cart/data/datasources/remote/cart_remote_datasources.dart';
import 'package:farm_express/features/cart/data/models/cart_model.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';
import 'package:farm_express/features/cart/domain/entities/cretate_cart_entities.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRepositoriesProvider = Provider<CartRepositories>((ref) {
  return CartRepositories(
    iCartRemoteDataSource: ref.read(cartRemoteDatasourceProvider),
  );
});

class CartRepositories implements ICartRepositories {
  final ICartRemoteDataSource _iCartRemoteDataSource;

  const CartRepositories({
    required ICartRemoteDataSource iCartRemoteDataSource,
  }) : _iCartRemoteDataSource = iCartRemoteDataSource;

  @override
  Future<Either<Failure, bool>> addProductToCart(AddCartEntity cartCreateEntities) async {
    try {
      final newData = CartCreateModel.fromEntity(cartCreateEntities);
      final response = await _iCartRemoteDataSource.addProductToCart(newData);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntities>> getCart() async {
    try {
      final response = await _iCartRemoteDataSource.getCart();
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> removeProductFromCart(String productId) {
    try {
      return _iCartRemoteDataSource.removeProductFromCart(productId).then((response) => Right(response));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }
  
  @override
  Future<Either<Failure, CartEntities>> updateCart(String productId, double quantity) async {
    try {
      final response = await _iCartRemoteDataSource.updateCart(productId,quantity);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
