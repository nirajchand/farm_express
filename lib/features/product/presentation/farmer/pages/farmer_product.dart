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
              /// Header
              Column(
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
                          onPressed: () {
                            // Navigate to Add Product Page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1,
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
                ],
              ),

              const SizedBox(height: 20),

              /// Body
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

            return ProductCard(
              imageUrl: product.productImage ?? "",
              title: product.productName ?? "",
              quantity: "${product.quantity} kg available",
              price: "Rs. ${product.price}/kg",
              status: product.status ?? "Unknown",
            );
          },
        );

      case FarmerProductStatus.initial:
      default:
        return const SizedBox();
    }
  }
}
