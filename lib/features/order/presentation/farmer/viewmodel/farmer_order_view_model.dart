import 'package:farm_express/features/order/domain/usecases/get_farmer_order_usecases.dart';
import 'package:farm_express/features/order/domain/usecases/update_order_usecases.dart';
import 'package:farm_express/features/order/presentation/farmer/state/farmer_order_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final farmerOrdersViewModelProvider =
    StateNotifierProvider<FarmerOrdersViewModel, FarmerOrdersState>((ref) {
      final getFarmerOrderUsecases = ref.read(getFarmerOrderUsecasesProvider);
      final updateOrderUsecases = ref.read(updateOrderUsecasesProvider);
      return FarmerOrdersViewModel(
        getFarmerOrderUsecases: getFarmerOrderUsecases,
        updateOrderUsecases: updateOrderUsecases,
      )..loadOrders();
    });

class FarmerOrdersViewModel extends StateNotifier<FarmerOrdersState> {
  final GetFarmerOrderUsecases _getFarmerOrderUsecases;
  final UpdateOrderUsecases _updateOrderUsecases;

  FarmerOrdersViewModel({
    required GetFarmerOrderUsecases getFarmerOrderUsecases,
    required UpdateOrderUsecases updateOrderUsecases,
  }) : _getFarmerOrderUsecases = getFarmerOrderUsecases,
       _updateOrderUsecases = updateOrderUsecases,

       super(const FarmerOrdersState());

  Future<void> loadOrders() async {
    state = state.copyWith(status: FarmerOrderStatus.loading);

    final result = await _getFarmerOrderUsecases();

    result.fold(
      (failure) => state = state.copyWith(
        status: FarmerOrderStatus.error,
        errorMessage: failure.message,
      ),
      (orders) => state = state.copyWith(
        status: FarmerOrderStatus.loaded,
        orders: orders,
      ),
    );
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  Future<void> refresh() => loadOrders();

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final result = await _updateOrderUsecases(
      UpdateOrderUsecasesParams(orderId: orderId, orderStatus: newStatus),
    );

    result.fold(
      (failure) => state = state.copyWith(
        errorMessage: failure.message,
      ),
      (success) {
        if (success) {
          loadOrders();
        } else {
          state = state.copyWith(
            errorMessage: "Failed to update order status",
          );
        }
      },
    );
  }
}
