import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/presentation/farmer/viewmodel/farmer_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerOrderDetailPage extends ConsumerWidget {
  final OrderEntity order;
  const FarmerOrderDetailPage({super.key, required this.order});

  static const _statusConfig = {
    'Pending': _StatusConfig(
      color: Color(0xFFFFF3E0),
      textColor: Color(0xFFE65100),
      icon: Icons.hourglass_empty_rounded,
    ),
    'Accepted': _StatusConfig(
      color: Color(0xFFE3F2FD),
      textColor: Color(0xFF1565C0),
      icon: Icons.thumb_up_rounded,
    ),
    'Shipped': _StatusConfig(
      color: Color(0xFFF3E5F5),
      textColor: Color(0xFF6A1B9A),
      icon: Icons.local_shipping_rounded,
    ),
    'Delivered': _StatusConfig(
      color: Color(0xFFE8F5E9),
      textColor: Color(0xFF2E7D32),
      icon: Icons.check_circle_rounded,
    ),
    'Cancelled': _StatusConfig(
      color: Color(0xFFFFEBEE),
      textColor: Color(0xFFC62828),
      icon: Icons.cancel_rounded,
    ),
  };

  static const _statusOptions = [
    ('Pending', 'Pending', Icons.hourglass_empty_rounded, Color(0xFFE65100)),
    ('Accepted', 'Accepted', Icons.thumb_up_rounded, Color(0xFF1565C0)),
    ('Shipped', 'Shipped', Icons.local_shipping_rounded, Color(0xFF6A1B9A)),
    ('Delivered', 'Delivered', Icons.check_circle_rounded, Color(0xFF2E7D32)),
    ('Cancelled', 'Cancelled', Icons.cancel_rounded, Color(0xFFC62828)),
  ];

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

  void _showStatusPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Order Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B2E1B),
              ),
            ),
            const SizedBox(height: 16),
            ..._statusOptions.map((opt) {
              final (key, label, icon, color) = opt;
              final isCurrent = (order.orderStatus ?? 'Pending') == key;

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isCurrent ? color : const Color(0xFF1B2E1B),
                  ),
                ),
                trailing: isCurrent
                    ? Icon(Icons.check_circle_rounded, color: color, size: 18)
                    : null,
                onTap: isCurrent
                    ? null
                    : () async {
                        Navigator.pop(context);
                        await ref
                            .read(farmerOrdersViewModelProvider.notifier)
                            .updateOrderStatus(order.id!, key);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Status updated to $label'),
                              backgroundColor: const Color(0xFF2E7D32),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusKey = order.orderStatus ?? 'Pending';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id?.substring(0, 8).toUpperCase() ?? '—'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Status Banner ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: config.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: config.textColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(config.icon, color: config.textColor, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Status',
                              style: TextStyle(
                                fontSize: 11,
                                color: config.textColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              order.orderStatus ?? 'Pending',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: config.textColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Payment badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: config.textColor.withOpacity(0.15),
                            ),
                          ),
                          child: Text(
                            order.paymentStatus ?? '—',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: config.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Update Status Card ──────────────────────────────────
                  _SectionCard(
                    title: 'Update Status',
                    icon: Icons.edit_rounded,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showStatusPicker(context, ref),
                          icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                          label: const Text(
                            'Change Order Status',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Consumer Details ────────────────────────────────────
                  _SectionCard(
                    title: 'Customer Details',
                    icon: Icons.person_rounded,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.badge_outlined,
                          label: 'Name',
                          value: order.consumerId?.fullName ?? '—',
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: order.consumerId?.email ?? '—',
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: order.consumerId?.phoneNumber ?? '—',
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.location_on_outlined,
                          label: 'Shipping Address',
                          value: order.shippingAddress ?? '—',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Items ───────────────────────────────────────────────
                  _SectionCard(
                    title: 'Order Items',
                    icon: Icons.inventory_2_rounded,
                    child: Column(
                      children: [
                        if (order.items != null && order.items!.isNotEmpty)
                          ...order.items!.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Column(
                              children: [
                                _ProductItemRow(item: item),
                                if (i < order.items!.length - 1)
                                  const _Divider(),
                              ],
                            );
                          }),
                        if (order.items == null || order.items!.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No items found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Payment Summary ─────────────────────────────────────
                  _SectionCard(
                    title: 'Payment Summary',
                    icon: Icons.payments_rounded,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.receipt_outlined,
                          label: 'Payment Method',
                          value: order.paymentMethod ?? '—',
                        ),
                        const _Divider(),
                        _DetailRow(
                          icon: Icons.local_shipping_outlined,
                          label: 'Delivery Fee',
                          value: _formatCurrency(order.deliveryFee ?? 0),
                        ),
                        const _Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                size: 18,
                                color: Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B2E1B),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatCurrency(order.totalAmount ?? 0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2E1B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4F0)),
          child,
        ],
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9EB09E)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9EB09E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1B2E1B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Product Item Row ─────────────────────────────────────────────────────────

class _ProductItemRow extends StatelessWidget {
  final dynamic item;

  const _ProductItemRow({required this.item});

  static String _formatCurrency(double amount) =>
      'Rs.${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.grass_rounded,
              color: Color(0xFF2E7D32),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? '—',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2E1B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} ${item.unitType ?? ''} × ${_formatCurrency((item.price ?? 0).toDouble())}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9EB09E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency((item.subtotal ?? 0).toDouble()),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFF0F4F0), indent: 42);
}

// ─── Status Config ────────────────────────────────────────────────────────────

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
