
import 'package:farm_express/features/order/presentation/consumer/pages/place_order_screen.dart';
import 'package:farm_express/features/order/presentation/consumer/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/order_entity.dart';
import '../state/order_state.dart';


class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch orders on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderViewModelProvider.notifier).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(orderViewModelProvider.notifier)
                .fetchOrders(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlaceOrderPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Place Order'),
      ),
      body: switch (state.status) {
        OrderStatus.loading => const Center(child: CircularProgressIndicator()),
        OrderStatus.failure => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(state.errorMessage ?? 'Failed to load orders'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref
                      .read(orderViewModelProvider.notifier)
                      .fetchOrders(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        OrderStatus.success when state.orders.isEmpty => const Center(
            child: Text('No orders yet.'),
          ),
        _ => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) => _OrderCard(state.orders[index]),
          ),
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderCard(this.order);

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _displayStatus(String? status) {
    if (status == null || status.isEmpty) return "Pending";
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final status = _displayStatus(order.orderStatus);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.id != null && order.id!.length >= 6
                        ? 'Order #${order.id!.substring(order.id!.length - 6).toUpperCase()}'
                        : 'Order #------',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(),

            /// ───── ITEMS ─────
            ...order.items!.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName} × ${item.quantity} ${item.unitType}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('Rs ${item.subtotal ?? 0}'),
                  ],
                ),
              ),
            ),

            const Divider(),

            /// ───── FOOTER ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment: ${order.paymentMethod ?? "-"}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'Address: ${order.shippingAddress ?? "-"}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rs ${order.totalAmount ?? 0}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            if (order.createdAt != null) ...[
              const SizedBox(height: 6),
              Text(
                'Placed on ${_formatDate(order.createdAt!)}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  '
        '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}