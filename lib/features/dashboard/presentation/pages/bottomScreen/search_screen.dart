import 'package:farm_express/features/product/presentation/consumer/pages/view_product_details.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:farm_express/features/product/presentation/consumer/view_model/get_all_product_viewmodel.dart';
import 'package:farm_express/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          "Search Products",
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: Column(
        children: [
          // ── Search Bar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isSearchFocused
                    ? [
                        BoxShadow(
                          color: colors.shadow.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: colors.shadow.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: _isSearchFocused ? colors.primary : colors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.search_rounded,
                    color: _isSearchFocused
                        ? colors.primary
                        : colors.textSecondary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _search(),
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search fresh products...",
                        hintStyle: TextStyle(
                          color: colors.textHint,
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
                          color: colors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: colors.textSecondary,
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
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: colors.white,
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
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
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
                          color: colors.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          productState.errorMessage ??
                              "Failed to load products",
                          style: TextStyle(color: colors.error),
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
                          color: colors.greyLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentSearch.isEmpty
                              ? "No products available"
                              : 'No results for "$currentSearch"',
                          style: TextStyle(
                            color: colors.textSecondary,
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
                    if (index >= products.length) {
                      return Container(
                        decoration: BoxDecoration(
                          color: colors.successContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colors.primary,
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
