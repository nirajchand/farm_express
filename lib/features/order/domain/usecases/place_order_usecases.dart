import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/order/data/repository/order_repositories_impl.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/domain/repository/order_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceOrderUsecasesParams extends Equatable {
  final String? shippingAddress;
  final String? paymentMethod;

  const PlaceOrderUsecasesParams({
    this.shippingAddress,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [shippingAddress, paymentMethod];
}

final placeOrderUsecasesProvider = Provider<PlaceOrderUsecases>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return PlaceOrderUsecases(iOrderRepository: orderRepository);
});


class PlaceOrderUsecases implements UsecaseWithParams<OrderEntity, PlaceOrderUsecasesParams> {
  final IOrderRepository _iOrderRepository;

  const PlaceOrderUsecases({
    required IOrderRepository iOrderRepository,
  }) : _iOrderRepository = iOrderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(PlaceOrderUsecasesParams params) {
    final orderEntity = OrderEntity(
      shippingAddress: params.shippingAddress,
      paymentMethod: params.paymentMethod,
    );
    return _iOrderRepository.placeOrder(orderEntity);
  }
}