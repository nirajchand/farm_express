// ─────────────────────────────────────────────
//  presentation/pages/place_order_page.dart
// ─────────────────────────────────────────────

import 'package:farm_express/features/cart/presentation/state/cart_state.dart';
import 'package:farm_express/features/cart/presentation/view_model/get_cart_view_model.dart';
import 'package:farm_express/features/order/domain/usecases/place_order_usecases.dart';
import 'package:farm_express/features/order/presentation/consumer/viewmodel/order_view_model.dart';
import 'package:farm_express/features/order/presentation/consumer/state/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceOrderPage extends ConsumerStatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  ConsumerState<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends ConsumerState<PlaceOrderPage> {
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getCartViewModelProvider.notifier).getCart();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _submit(CartState cartState) {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter shipping address')),
      );
      return;
    }

    final params = PlaceOrderUsecasesParams(
      shippingAddress: _addressController.text.trim(),
      paymentMethod: 'COD',
    );

    ref.read(orderViewModelProvider.notifier).placeOrder(params);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(getCartViewModelProvider);
    final orderState = ref.watch(orderViewModelProvider);

    ref.listen<OrderState>(orderViewModelProvider, (_, next) {
      if (next.status == OrderStatus.success) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
        ref.read(getCartViewModelProvider.notifier).getCart();
      }

      if (next.status == OrderStatus.failure) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Something went wrong'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Place Order')),
      body: cartState.status == CartStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : cartState.cart == null || cartState.cart!.items!.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ───── ORDER SUMMARY ─────
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          children: [
                            Text(
                              'Order Summary',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),

                            // ───── ORDER ITEMS ─────
                            ...cartState.cart!.items!.map((item) {
                              final quantity = item.quantity ?? 0;
                              final price = item.product?.price ?? 0.0;
                              final subtotal = quantity * price;

                              return Column(
                                children: [
                                  _SummaryRow(
                                    item.product!.productName,
                                    '$quantity ${item.product!.unitType}',
                                  ),
                                  _SummaryRow('Price', 'Rs $price'),
                                  _SummaryRow('Subtotal', 'Rs $subtotal'),
                                  const Divider(),
                                ],
                              );
                            }),

                            const SizedBox(height: 8),

                            // ───── TOTAL ─────
                            _SummaryRow(
                              'Total',
                              'Rs ${cartState.cart!.items!.fold<double>(0.0, (sum, item) => sum + ((item.quantity ?? 0) * (item.product?.price ?? 0.0)))}',
                              isBold: true,
                            ),

                            const SizedBox(height: 8),
                            const _SummaryRow('Delivery Fee', 'Free'),
                            const _SummaryRow(
                              'Payment Method',
                              'Cash on Delivery',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ───── ADDRESS FIELD ─────
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Shipping Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ───── CONFIRM BUTTON ─────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: orderState.status == OrderStatus.loading
                          ? null
                          : () => _submit(cartState),
                      child: orderState.status == OrderStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirm Order',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String? label;
  final String? value;
  final bool? isBold;

  const _SummaryRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final style = isBold == true
        ? const TextStyle(fontWeight: FontWeight.bold)
        : const TextStyle();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label ?? '', style: style),
          Text(value ?? '', style: style),
        ],
      ),
    );
  }
}
