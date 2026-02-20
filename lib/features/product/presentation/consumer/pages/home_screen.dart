import 'package:farm_express/features/product/presentation/consumer/pages/view_product_details.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:farm_express/features/product/presentation/consumer/view_model/get_all_product_viewmodel.dart';
import 'package:farm_express/widgets/category_chip.dart';
import 'package:farm_express/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getAllProductViewModelProvider.notifier).getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(getAllProductViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top-left image
            Positioned(
              top: 10,
              left: 0,
              child: Image.asset(
                "assets/images/farmers.png",
                height: 30,
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CategoryChip(categoryName: "Fruits"),
                      CategoryChip(categoryName: "Grains"),
                      CategoryChip(categoryName: "Vegetables"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Browse Products
                  Text(
                    "Browse Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Product Grid
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (productState.status == GetAllProductStateStatus.loading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (productState.status ==
                            GetAllProductStateStatus.failure) {
                          return Center(
                            child: Text(
                              productState.errorMessage ?? "Failed to load products",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (productState.status ==
                                GetAllProductStateStatus.success &&
                            productState.products!.isEmpty) {
                          return const Center(child: Text("No products available"));
                        }

                        final products = productState.products;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                            return GridView.builder(
                              itemCount: products!.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.80,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return InkWell(
                                  onTap: () {
                                    // Navigate to details page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailsPage(product: product),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: MyCard(
                                    imagePath: product.productImage,
                                    name: product.productName,
                                    price: product.price,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}