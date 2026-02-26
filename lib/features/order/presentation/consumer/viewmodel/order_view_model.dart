import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/domain/usecases/get_order_usecases.dart';
import 'package:farm_express/features/order/domain/usecases/place_order_usecases.dart';
import 'package:farm_express/features/order/presentation/consumer/state/order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderViewModelProvider = NotifierProvider<OrderViewModel, OrderState>(
  () => OrderViewModel(),
);

class OrderViewModel extends Notifier<OrderState> {
  late final PlaceOrderUsecases _placeOrderUsecase;
  late final GetOrderUsecases _getOrdersUsecase;

  @override
  OrderState build() {
    _placeOrderUsecase = ref.read(placeOrderUsecasesProvider);
    _getOrdersUsecase = ref.read(getOrderUsecasesProvider);
    return OrderState();
  }

  Future<void> placeOrder(PlaceOrderUsecasesParams params) async {
    state = state.copyWith(status: OrderStatus.loading);

    try {
      final result = await _placeOrderUsecase.call(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: OrderStatus.failure,
            errorMessage: failure.message,
          );
        },
        (placedOrder) {
          // Success
          state = state.copyWith(
            status: OrderStatus.success,
            placedOrder: placedOrder,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: OrderStatus.failure,
        errorMessage: "Unexpected error occurred: $e",
      );
    }
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(status: OrderStatus.loading);

    final result = await _getOrdersUsecase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderStatus.failure,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(status: OrderStatus.success, orders: orders);
      },
    );
  }
}
