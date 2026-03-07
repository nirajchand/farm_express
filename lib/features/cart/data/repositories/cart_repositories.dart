import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
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
    networkInfo: ref.read(networkInfoProvider),
  );
});

class CartRepositories implements ICartRepositories {
  final ICartRemoteDataSource _iCartRemoteDataSource;
  final INetworkInfo _networkInfo;

  const CartRepositories({
    required ICartRemoteDataSource iCartRemoteDataSource,
    required INetworkInfo networkInfo,
  }) : _iCartRemoteDataSource = iCartRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> addProductToCart(
    AddCartEntity cartCreateEntities,
  ) async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      return Left(
        ServerFailure(
          message:
              "No internet connection. Please check your WiFi or mobile data.",
        ),
      );
    }

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
    final isConnected = await _networkInfo.isConnected;

    try {
      if (isConnected) {
        final response = await _iCartRemoteDataSource.getCart();
        final apiCart = response.toEntity();
        return Right(apiCart);
      } else {
        return Left(
          ServerFailure(
            message:
                "No internet connection. Please check your WiFi or mobile data.",
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeProductFromCart(String productId) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(
        ServerFailure(
          message:
              "No internet connection. Please check your WiFi or mobile data.",
        ),
      );
    }

    try {
      return _iCartRemoteDataSource
          .removeProductFromCart(productId)
          .then((response) => Right(response));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, CartEntities>> updateCart(
    String productId,
    double quantity,
  ) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(
        ServerFailure(
          message:
              "No internet connection. Please check your WiFi or mobile data.",
        ),
      );
    }

    try {
      final response = await _iCartRemoteDataSource.updateCart(
        productId,
        quantity,
      );
      final apiCart = response.toEntity();
      return Right(apiCart);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
