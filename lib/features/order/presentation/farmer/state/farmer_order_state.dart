import 'package:farm_express/features/order/domain/entities/order_entity.dart';

enum FarmerOrderStatus { initial, loading, loaded, error }

class FarmerOrdersState {
  final FarmerOrderStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;
  final String selectedFilter; 

  const FarmerOrdersState({
    this.status = FarmerOrderStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.selectedFilter = 'All',
  });

  FarmerOrdersState copyWith({
    FarmerOrderStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return FarmerOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  List<OrderEntity> get filteredOrders {
    if (selectedFilter == 'All') return orders;
    return orders
        .where((o) =>
            o.orderStatus?.toLowerCase() == selectedFilter.toLowerCase())
        .toList();
  }

  double get totalRevenue => orders.fold(
        0,
        (sum, o) => sum + (o.totalAmount ?? 0),
      );

  int get pendingCount => orders
      .where((o) => o.orderStatus?.toLowerCase() == 'pending')
      .length;
}