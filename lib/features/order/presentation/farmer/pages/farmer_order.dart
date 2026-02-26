import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/presentation/farmer/pages/order_details.dart';
import 'package:farm_express/features/order/presentation/farmer/state/farmer_order_state.dart';
import 'package:farm_express/features/order/presentation/farmer/viewmodel/farmer_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerOrdersPage extends ConsumerWidget {
  const FarmerOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(farmerOrdersViewModelProvider);
    final vm = ref.read(farmerOrdersViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(state: state),
            _StatsRow(state: state),
            _FilterChips(
              selected: state.selectedFilter,
              onSelect: vm.setFilter,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _OrdersList(state: state, onRefresh: vm.refresh),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final FarmerOrdersState state;
  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B2E1B),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${state.orders.length} total orders',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B8C6B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final FarmerOrdersState state;
  const _StatsRow({required this.state});

  static String _formatCurrency(double amount) =>
      'Rs.${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            label: 'Total Revenue',
            value: _formatCurrency(state.totalRevenue),
            icon: Icons.payments_rounded,
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _StatItem(
            label: 'Pending',
            value: '${state.pendingCount}',
            icon: Icons.hourglass_empty_rounded,
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _StatItem(
            label: 'Delivered',
            value:
                '${state.orders.where((o) => o.orderStatus?.toLowerCase() == 'delivered').length}',
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chips ─────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  // Updated to match new order statuses
  static const filters = [
    'All',
    'Pending',
    'Accepted',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  const _FilterChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFDDE8DD),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF4A6A4A),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Orders List ──────────────────────────────────────────────────────────────

class _OrdersList extends StatelessWidget {
  final FarmerOrdersState state;
  final Future<void> Function() onRefresh;
  const _OrdersList({required this.state, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (state.status == FarmerOrderStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2E7D32),
          strokeWidth: 2.5,
        ),
      );
    }

    if (state.status == FarmerOrderStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Something went wrong',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final orders = state.filteredOrders;

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 52,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No orders found',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF2E7D32),
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _OrderCard(order: orders[i]),
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderCard({required this.order});

  // Updated status config to match new statuses: Pending, Accepted, Shipped, Delivered, Cancelled
  static const _statusConfig = {
    'pending': _StatusConfig(
      color: Color(0xFFFFF3E0),
      textColor: Color(0xFFE65100),
      icon: Icons.hourglass_empty_rounded,
    ),
    'accepted': _StatusConfig(
      color: Color(0xFFE8EAF6),
      textColor: Color(0xFF3949AB),
      icon: Icons.thumb_up_alt_rounded,
    ),
    'shipped': _StatusConfig(
      color: Color(0xFFE1F5FE),
      textColor: Color(0xFF0277BD),
      icon: Icons.local_shipping_rounded,
    ),
    'delivered': _StatusConfig(
      color: Color(0xFFE8F5E9),
      textColor: Color(0xFF2E7D32),
      icon: Icons.check_circle_rounded,
    ),
    'cancelled': _StatusConfig(
      color: Color(0xFFFFEBEE),
      textColor: Color(0xFFC62828),
      icon: Icons.cancel_rounded,
    ),
  };

  static String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  static String _formatCurrency(double amount) =>
      'Rs.${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final statusKey = order.orderStatus?.toLowerCase() ?? 'pending';
    final config =
        _statusConfig[statusKey] ??
        const _StatusConfig(
          color: Color(0xFFF5F5F5),
          textColor: Color(0xFF616161),
          icon: Icons.help_outline_rounded,
        );

    final dateStr = order.createdAt != null
        ? '${_monthName(order.createdAt!.month)} ${order.createdAt!.day}, ${order.createdAt!.year}'
        : '—';

    final itemCount = order.items?.length ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FarmerOrderDetailPage(order: order),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_rounded,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id?.substring(0, 8).toUpperCase() ?? '—'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1B2E1B),
                        ),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9EB09E),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _StatusBadge(
                    config: config,
                    label: order.orderStatus ?? 'Pending',
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF0F4F0)),
              const SizedBox(height: 12),

              // Items preview
              if (order.items != null && order.items!.isNotEmpty)
                Text(
                  order.items!
                          .take(2)
                          .map((i) => i.productName ?? '')
                          .join(', ') +
                      (itemCount > 2 ? ' +${itemCount - 2} more' : ''),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A6A4A),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 10),

              // Bottom row
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.inventory_2_outlined,
                    label: '$itemCount item${itemCount != 1 ? 's' : ''}',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: order.shippingAddress?.split(',').first ?? '—',
                  ),
                  const Spacer(),
                  Text(
                    _formatCurrency(order.totalAmount ?? 0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),

              // Payment row
              if (order.paymentStatus != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      order.paymentStatus?.toLowerCase() == 'paid'
                          ? Icons.check_circle_outline
                          : Icons.pending_outlined,
                      size: 14,
                      color: order.paymentStatus?.toLowerCase() == 'paid'
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${order.paymentStatus} · ${order.paymentMethod ?? '—'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: order.paymentStatus?.toLowerCase() == 'paid'
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusConfig {
  final Color color;
  final Color textColor;
  final IconData icon;
  const _StatusConfig({
    required this.color,
    required this.textColor,
    required this.icon,
  });
}

class _StatusBadge extends StatelessWidget {
  final _StatusConfig config;
  final String label;
  const _StatusBadge({required this.config, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF9EB09E)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9EB09E)),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
