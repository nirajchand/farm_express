import 'package:farm_express/features/product/presentation/consumer/pages/view_product_details.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:farm_express/features/product/presentation/consumer/view_model/get_all_product_viewmodel.dart';
import 'package:farm_express/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getAllProductViewModelProvider.notifier)
          .getAllProducts(page: _currentPage, size: 10);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final productState = ref.read(getAllProductViewModelProvider);

    // Trigger fetch when 200px from the bottom
    if (currentScroll >= maxScroll - 200 &&
        !_isFetchingMore &&
        productState.status != GetAllProductStateStatus.loading) {
      final pagination = productState.pagination;

      // Check if more pages are available
      if (pagination != null && _currentPage < pagination.totalPages) {
        _fetchNextPage();
      }
    }
  }

  Future<void> _fetchNextPage() async {
    setState(() => _isFetchingMore = true);
    _currentPage++;

    await ref
        .read(getAllProductViewModelProvider.notifier)
        .getAllProducts(page: _currentPage, size: 10, append: true);

    setState(() => _isFetchingMore = false);
  }

  Future<void> _refreshProducts() async {
    _currentPage = 1;
    await ref
        .read(getAllProductViewModelProvider.notifier)
        .getAllProducts(page: _currentPage, size: 10, append: false);
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
              child: Image.asset("assets/images/farmers.png", height: 30),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Browse Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Product Grid
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (productState.status ==
                                GetAllProductStateStatus.loading &&
                            _currentPage == 1) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (productState.status ==
                                GetAllProductStateStatus.failure &&
                            (productState.products == null ||
                                productState.products!.isEmpty)) {
                          return Center(
                            child: Text(
                              productState.errorMessage ??
                                  "Failed to load products",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (productState.status ==
                                GetAllProductStateStatus.success &&
                            productState.products!.isEmpty) {
                          return const Center(
                            child: Text("No products available"),
                          );
                        }

                        final products = productState.products ?? [];

                        return RefreshIndicator(
                          onRefresh: _refreshProducts,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 600
                                  ? 4
                                  : 2;

                              return GridView.builder(
                                controller: _scrollController,
                                // +1 for the loading indicator at the bottom
                                itemCount: _isFetchingMore
                                    ? products.length + 1
                                    : products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 0.80,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                itemBuilder: (context, index) {
                                  // Show loader tile at the end
                                  if (index == products.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final product = products[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsPage(
                                            product: product,
                                          ),
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
                          ),
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
