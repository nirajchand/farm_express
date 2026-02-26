

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/order/data/repository/order_repositories_impl.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/domain/repository/order_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final getOrderUsecasesProvider = Provider<GetOrderUsecases>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return GetOrderUsecases(iOrderRepository: orderRepository);
});

class GetOrderUsecases implements UseecaseWithoutParams  {

  final IOrderRepository _iOrderRepository;

  const GetOrderUsecases({
    required IOrderRepository iOrderRepository,
  }) : _iOrderRepository = iOrderRepository;
  
  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return _iOrderRepository.getOrders();
  }
}