import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/cart/presentation/view_model/get_cart_view_model.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final ProductEntities product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int quantity = 1;
  late String productStatus;

  @override
  void initState() {
    super.initState();
    productStatus = widget.product.status ?? 'Unknown';
  }

  Color _statusColor(dynamic colors) {
    switch (productStatus) {
      case 'Growing':
        return colors.warning;
      case 'Ready':
        return colors.success;
      case 'Sold':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  IconData get statusIcon {
    switch (productStatus) {
      case 'Growing':
        return Icons.eco_outlined;
      case 'Ready':
        return Icons.check_circle_outline;
      case 'Sold':
        return Icons.remove_shopping_cart_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required dynamic colors,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? colors.success : colors.surface,
          border: Border.all(color: isPrimary ? colors.success : colors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? colors.white : colors.success,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;
    final product = widget.product;
    final statusColor = _statusColor(colors);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // ─── App Bar with Hero Image ──────────────────────────────
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: colors.surface,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: colors.shadow, blurRadius: 8),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: colors.textPrimary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            ApiEndpoints.serverUrl +
                                (product.productImage ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: colors.successContainer,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                  color: colors.successLight,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(
                                      isDark ? 0.3 : 0.1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Product Info ─────────────────────────────────
                        Container(
                          color: colors.surface,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName ??
                                              'Unknown Product',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: colors.primaryDark,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.description ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(
                                        isDark ? 0.2 : 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          statusIcon,
                                          size: 14,
                                          color: statusColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          productStatus,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Price Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rs ${product.price ?? '0'}',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: colors.success,
                                    ),
                                  ),
                                  Text(
                                    '/kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${product.quantity ?? 0} ${product.unitType} available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ─── Quantity Selector ────────────────────────────
                        Container(
                          color: colors.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Quantity (kg)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: colors.border),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    _quantityButton(
                                      icon: Icons.remove,
                                      colors: colors,
                                      onTap: () {
                                        if (quantity > 1)
                                          setState(() => quantity--);
                                      },
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        '$quantity',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    _quantityButton(
                                      icon: Icons.add,
                                      colors: colors,
                                      onTap: () => setState(() => quantity++),
                                      isPrimary: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ─── Farm Info ────────────────────────────────────
                        Container(
                          color: colors.surface,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Farm Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                icon: Icons.agriculture_outlined,
                                value:
                                    product.farmer?.farmName ?? 'Unknown Farm',
                                isBold: true,
                                colors: colors,
                              ),
                              const SizedBox(height: 8),
                              _infoRow(
                                icon: Icons.location_on_outlined,
                                value: product.farmer?.farmLocation ?? '',
                                colors: colors,
                              ),
                              const SizedBox(height: 8),
                              _infoRow(
                                icon: Icons.phone_outlined,
                                value: product.farmer?.phoneNumber ?? '',
                                colors: colors,
                              ),
                              if ((product.farmer?.description ?? '')
                                  .isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  product.farmer?.description ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Add to Cart Bar ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withOpacity(isDark ? 0.4 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: productStatus == 'Sold'
                      ? null
                      : () async {
                          try {
                            ref
                                .read(getCartViewModelProvider.notifier)
                                .addToCart(product.id ?? '', quantity);
                            SnackbarUtils.showSuccess(
                              context,
                              "Added to cart successfully!",
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to add to cart: $e"),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.success,
                    foregroundColor: colors.white,
                    disabledBackgroundColor: colors.greyLight,
                    disabledForegroundColor: colors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    productStatus == 'Sold' ? 'Out of Stock' : 'Add to Cart',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String value,
    required dynamic colors,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: colors.success),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? colors.textPrimary : colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
