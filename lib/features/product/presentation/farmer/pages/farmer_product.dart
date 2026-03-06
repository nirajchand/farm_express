// farmers_page.dart

import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/update_product.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
import 'package:farm_express/features/product/presentation/farmer/widgets/product_card.dart';
import 'package:farm_express/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Farmers",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
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
                        backgroundColor: colors.primary,
                        foregroundColor: colors.white,
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
              Expanded(child: _buildBody(state, colors)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FarmerProductState state, dynamic colors) {
    switch (state.status) {
      case FarmerProductStatus.loading:
        return Center(child: CircularProgressIndicator(color: colors.primary));

      case FarmerProductStatus.failure:
        return Center(
          child: Text(
            state.errorMessage ?? "Something went wrong",
            style: TextStyle(color: colors.error),
          ),
        );

      case FarmerProductStatus.success:
        final products = state.products;

        if (products.isEmpty) {
          return Center(
            child: Text(
              "No products found",
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Dismissible(
              key: ValueKey(product.id),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colors.errorRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Delete",
                      style: TextStyle(
                        color: colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.delete, color: colors.white, size: 28),
                  ],
                ),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      "Delete Product",
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete "${product.productName}"?',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.error,
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
                    SnackBar(
                      content: const Text("Failed to delete product"),
                      backgroundColor: colors.error,
                    ),
                  );
                  ref
                      .read(farmerProductViewModelProvider.notifier)
                      .getProductsByFarmerId();
                }
              },
              child: GestureDetector(
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

      default:
        return const SizedBox();
    }
  }
}
