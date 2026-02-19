import 'package:farm_express/core/constants/colors.dart';
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

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/farmers.png", height: 50),
              Icon(Icons.notifications, color: kPrimaryColor),
            ],
          ),
          SizedBox(height: 20),
          // Categories
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CategoryChip(categoryName: "Fruits"),
              CategoryChip(categoryName: "Grains"),
              CategoryChip(categoryName: "Vegetables"),
            ],
          ),
          SizedBox(height: 10),
          // Browse Products
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Browse Products",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          // Product Grid
          Expanded(
            child: Builder(
              builder: (_) {
                if (productState.status == GetAllProductStateStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (productState.status ==
                    GetAllProductStateStatus.failure) {
                  return Center(
                    child: Text(
                      productState.errorMessage ?? "Failed to load products",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (productState.status ==
                        GetAllProductStateStatus.success &&
                    productState.products!.isEmpty) {
                  return Center(child: Text("No products available"));
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
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return MyCard(
                          imagePath: product.productImage,
                          name: product.productName,
                          price: product.price
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
    );
  }
}
