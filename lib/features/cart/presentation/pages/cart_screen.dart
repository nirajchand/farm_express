import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/cart/presentation/state/cart_state.dart';
import 'package:farm_express/features/cart/presentation/view_model/get_cart_view_model.dart';
import 'package:farm_express/features/order/presentation/consumer/pages/place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartState = ref.read(getCartViewModelProvider);
      if (cartState.status == CartStatus.initial) {
        ref.read(getCartViewModelProvider.notifier).getCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(getCartViewModelProvider);

    if (cartState.status == CartStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartState.status == CartStatus.failure) {
      return Center(
        child: Text(
          cartState.errorMessage ?? "Something went wrong",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final cart = cartState.cart;
    if (cart == null || cart.items == null || cart.items!.isEmpty) {
      return const Center(child: Text("Your cart is empty"));
    }

    final items = cart.items!;
    final grandTotal = items.fold<double>(0.0, (sum, item) {
      final product = item.product;
      if (product == null) return sum;
      return sum + ((product.price ?? 0) * (item.quantity ?? 0));
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              if (product == null) return const SizedBox();

              final price = product.price ?? 0;
              double quantity = item.quantity ?? 0;
              final total = price * quantity;
              final unitType = product.unitType ?? '';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${ApiEndpoints.serverUrl}${product.productImage ?? ''}",
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, size: 60),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName ?? "No Name",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rs $price${unitType.isNotEmpty ? ' / $unitType' : ''}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Quantity controls using Wrap to prevent overflow
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 0,
                              runSpacing: 4,
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (quantity > 1) {
                                        quantity--;
                                        await ref
                                            .read(
                                              getCartViewModelProvider.notifier,
                                            )
                                            .updateCart(
                                              item.id ?? '',
                                              quantity.toDouble(),
                                            );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    quantity % 1 == 0
                                        ? quantity.toInt().toString()
                                        : quantity.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      quantity++;
                                      await ref
                                          .read(
                                            getCartViewModelProvider.notifier,
                                          )
                                          .updateCart(
                                            item.id ?? '',
                                            quantity.toDouble(),
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                if (unitType.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      unitType,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Total + Delete
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rs $total",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: cartState.isDeleting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                              onPressed: cartState.isDeleting
                                  ? null
                                  : () async {
                                      final success = await ref
                                          .read(
                                            getCartViewModelProvider.notifier,
                                          )
                                          .removeFromCart(item.id ?? '');
                                      if (!mounted) return;
                                      if (!success) {
                                        SnackbarUtils.showError(
                                          context,
                                          "Failed to remove item",
                                        );
                                      } else {
                                        SnackbarUtils.showSuccess(
                                          context,
                                          "Item removed successfully",
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom checkout bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Grand Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rs $grandTotal",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PlaceOrderPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Proceed to Checkout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
