import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';

abstract class IOrderRepository {
  Future<Either<Failure, bool>> placeOrder(OrderEntity order);
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, List<OrderEntity>>> getFarmerOrder();
  Future<Either<Failure, bool>> updateOrderStatus(String orderStatus, String orderId);
}
