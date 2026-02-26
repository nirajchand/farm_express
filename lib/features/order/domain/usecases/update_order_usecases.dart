import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/order/data/repository/order_repositories_impl.dart';
import 'package:farm_express/features/order/domain/repository/order_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateOrderUsecasesParams extends Equatable {
  final String? orderStatus;
  final String? orderId;

  const UpdateOrderUsecasesParams({this.orderStatus, this.orderId});

  @override
  List<Object?> get props => [orderStatus, orderId];
}


final updateOrderUsecasesProvider = Provider<UpdateOrderUsecases>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return UpdateOrderUsecases(iOrderRepository: orderRepository);
});

class UpdateOrderUsecases
    implements UsecaseWithParams<bool, UpdateOrderUsecasesParams> {
  final IOrderRepository _iOrderRepository;

  const UpdateOrderUsecases({required IOrderRepository iOrderRepository})
    : _iOrderRepository = iOrderRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateOrderUsecasesParams params) {
    return _iOrderRepository.updateOrderStatus(params.orderStatus!, params.orderId!);
  }

    

}
