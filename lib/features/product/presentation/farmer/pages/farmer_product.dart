// farmers_page.dart

import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/update_product.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
import 'package:farm_express/features/product/presentation/farmer/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farm_express/features/product/presentation/farmer/state/farmer_product.dart';

class FarmersPage extends ConsumerStatefulWidget {
  const FarmersPage({super.key});

  @override
  ConsumerState<FarmersPage> createState() => _FarmersPageState();
}

class _FarmersPageState extends ConsumerState<FarmersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(farmerProductViewModelProvider.notifier).getProductsByFarmerId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(farmerProductViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Farmers",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddProductScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        "Add Product",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FarmerProductState state) {
    switch (state.status) {
      case FarmerProductStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case FarmerProductStatus.failure:
        return Center(
          child: Text(
            state.errorMessage ?? "Something went wrong",
            style: const TextStyle(color: Colors.red),
          ),
        );

      case FarmerProductStatus.success:
        final products = state.products;

        if (products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Dismissible(
              // Unique key per product
              key: ValueKey(product.id),

              // Only allow left-to-right swipe
              direction: DismissDirection.endToStart,

              // Red delete background shown while swiping
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Confirm before deleting
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Product"),
                    content: Text(
                      'Are you sure you want to delete "${product.productName}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },

              onDismissed: (_) async {
                final success = await ref
                    .read(farmerProductViewModelProvider.notifier)
                    .deleteProduct(product.id!);

                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to delete product"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // Refresh to restore item in list
                  ref
                      .read(farmerProductViewModelProvider.notifier)
                      .getProductsByFarmerId();
                }
              },

              child: GestureDetector(
                // Tap card → go to update screen
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateProductScreen(product: product),
                  ),
                ),
                child: ProductCard(
                  imageUrl: product.productImage ?? "",
                  title: product.productName ?? "",
                  quantity: "${product.quantity} kg available",
                  price: "Rs. ${product.price}/kg",
                  status: product.status ?? "Unknown",
                ),
              ),
            );
          },
        );

      case FarmerProductStatus.initial:
      default:
        return const SizedBox();
    }
  }
}