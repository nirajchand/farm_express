import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
import 'package:farm_express/features/order/data/datasources/order_datasources..dart';
import 'package:farm_express/features/order/data/datasources/remote/order_remote_datasources.dart';
import 'package:farm_express/features/order/data/model/order_consumer_model.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/domain/repository/order_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
    iRemoteOrderDataSource: ref.read(orderRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class OrderRepository implements IOrderRepository {
  final IRemoteOrderDataSource _iRemoteOrderDataSource;
  final INetworkInfo _networkInfo;

  const OrderRepository({
    required IRemoteOrderDataSource iRemoteOrderDataSource,
    required INetworkInfo networkInfo,
  }) : _iRemoteOrderDataSource = iRemoteOrderDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    // Check internet connection first
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
      return _iRemoteOrderDataSource.getOrders().then(
        (response) => Right(response.map((e) => e.toEntity()).toList()),
      );
    } catch (e) {
      return Future.value(
        Left(
          ServerFailure(message: "Failed to fetch orders. Please try again."),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> placeOrder(OrderEntity order) async {
    // Check if device is online before placing order
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(
        ServerFailure(
          message:
              "Cannot place order without internet connection. Please connect to WiFi or mobile data.",
        ),
      );
    }

    try {
      final orderModel = OrderModel.fromEntity(order);
      return _iRemoteOrderDataSource
          .placeOrder(orderModel)
          .then((response) => Right(response));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getFarmerOrder() async {
    // Check internet connection first
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
      return _iRemoteOrderDataSource.getFarmerOrder().then(
        (response) => Right(response.map((e) => e.toEntity()).toList()),
      );
    } catch (e) {
      return Future.value(
        Left(
          ServerFailure(message: "Failed to fetch orders. Please try again."),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> updateOrderStatus(
    String orderStatus,
    String orderId,
  ) {
    try {
      return _iRemoteOrderDataSource
          .updateOrderS(orderStatus, orderId)
          .then((response) => Right(response));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }
}
