import 'package:farm_express/features/product/presentation/consumer/pages/view_product_details.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:farm_express/features/product/presentation/consumer/view_model/get_all_product_viewmodel.dart';
import 'package:farm_express/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductPage extends ConsumerStatefulWidget {
  const SearchProductPage({super.key});

  @override
  ConsumerState<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends ConsumerState<SearchProductPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  int currentPage = 1;
  final int pageSize = 10;
  String currentSearch = "";
  bool _isFetchingMore = false;
  bool _isSearchFocused = false;

  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getAllProductViewModelProvider.notifier)
          .getAllProducts(page: currentPage, size: pageSize, append: false);
    });

    _focusNode.addListener(() {
      setState(() => _isSearchFocused = _focusNode.hasFocus);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final productState = ref.read(getAllProductViewModelProvider);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !_isFetchingMore &&
        productState.status != GetAllProductStateStatus.loading) {
      final pagination = productState.pagination;
      if (pagination != null && currentPage < pagination.totalPages) {
        _fetchNextPage();
      }
    }
  }

  Future<void> _fetchNextPage() async {
    setState(() => _isFetchingMore = true);
    currentPage++;
    await ref
        .read(getAllProductViewModelProvider.notifier)
        .getAllProducts(
          page: currentPage,
          size: pageSize,
          search: currentSearch.isEmpty ? null : currentSearch,
          append: true,
        );
    setState(() => _isFetchingMore = false);
  }

  void _search() {
    FocusScope.of(context).unfocus();
    currentPage = 1;
    currentSearch = _searchController.text.trim();
    ref
        .read(getAllProductViewModelProvider.notifier)
        .getAllProducts(
          page: currentPage,
          size: pageSize,
          search: currentSearch.isEmpty ? null : currentSearch,
          append: false,
        );
  }

  void _clearSearch() {
    _searchController.clear();
    currentPage = 1;
    currentSearch = "";
    FocusScope.of(context).unfocus();
    ref
        .read(getAllProductViewModelProvider.notifier)
        .getAllProducts(page: currentPage, size: pageSize, append: false);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(getAllProductViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Search Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // ── Professional Search Bar ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSearchFocused
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: _isSearchFocused
                      ? _green
                      : Colors.grey.shade200, // green focus
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.search_rounded,
                    color: _isSearchFocused
                        ? _green
                        : Colors.grey.shade400, // green
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _search(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search fresh products...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _search,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _green, // green search button
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Product Grid ─────────────────────────────────────────
          Expanded(
            child: Builder(
              builder: (_) {
                if (productState.status == GetAllProductStateStatus.loading &&
                    currentPage == 1) {
                  return const Center(
                    child: CircularProgressIndicator(color: _green),
                  );
                }

                if (productState.status == GetAllProductStateStatus.failure &&
                    (productState.products == null ||
                        productState.products!.isEmpty)) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          productState.errorMessage ??
                              "Failed to load products",
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (productState.products == null ||
                    productState.products!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 56,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentSearch.isEmpty
                              ? "No products available"
                              : "No results for \"$currentSearch\"",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final products = productState.products!;

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.80,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _isFetchingMore
                      ? products.length + 2
                      : products.length,
                  itemBuilder: (context, index) {
                    // Loading shimmer tiles at the end
                    if (index >= products.length) {
                      return Container(
                        decoration: BoxDecoration(
                          color: _lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: _green,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final product = products[index];
                    return InkWell(
                      onTap: () {
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
            ),
          ),
        ],
      ),
    );
  }
}
