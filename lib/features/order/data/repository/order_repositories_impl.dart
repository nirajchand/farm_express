import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/order/data/datasources/order_datasources..dart';
import 'package:farm_express/features/order/data/datasources/remote/order_remote_datasources.dart';
import 'package:farm_express/features/order/data/model/order_consumer_model.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/domain/repository/order_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
    iRemoteOrderDataSource: ref.read(orderRemoteDataSourceProvider),
  );
});

class OrderRepository implements IOrderRepository {
  final IRemoteOrderDataSource _iRemoteOrderDataSource;

  const OrderRepository({
    required IRemoteOrderDataSource iRemoteOrderDataSource,
  }) : _iRemoteOrderDataSource = iRemoteOrderDataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() {
    try {
      return _iRemoteOrderDataSource.getOrders().then(
        (response) => Right(response.map((e) => e.toEntity()).toList()),
      );
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order) {
    try {
      final orderModel = OrderModel.fromEntity(order);
      return _iRemoteOrderDataSource
          .placeOrder(orderModel)
          .then((response) => Right(response.toEntity()));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getFarmerOrder() {
    try {
      return _iRemoteOrderDataSource.getFarmerOrder().then(
        (response) => Right(response.map((e) => e.toEntity()).toList()),
      );
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateOrderStatus(String orderStatus, String orderId) {
    try {
      return _iRemoteOrderDataSource.updateOrderS(orderStatus, orderId).then(
        (response) => Right(response),
      );
    } catch (e) {
      return Future.value(Left(ServerFailure(message: e.toString())));
    }
  }
}
