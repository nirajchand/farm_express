import 'package:farm_express/features/order/presentation/farmer/pages/farmer_order.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerHomeScreen extends ConsumerStatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  ConsumerState<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends ConsumerState<FarmerHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(farmerProductViewModelProvider.notifier).getProductsByFarmerId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(farmerProductViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColorsDark() : AppColorsLight() as dynamic;

    final productCount = productState.products.length;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(colors: colors),
              const SizedBox(height: 24),

              _StatsGrid(productCount: productCount, colors: colors),
              const SizedBox(height: 20),

              _WeatherCard(colors: colors),
              const SizedBox(height: 20),

              _ActionButtons(colors: colors),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final dynamic colors;

  const _Header({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Farmers',
          style: TextStyle(
            color: colors.secondary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        _NotificationBell(colors: colors),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final dynamic colors;

  const _NotificationBell({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.secondaryLight,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: colors.textPrimary,
            size: 22,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final int productCount;
  final dynamic colors;

  const _StatsGrid({required this.productCount, required this.colors});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: 'Rs 24,000',
                label: 'THIS MONTH',
                valueColor: colors.secondary,
                icon: Icons.trending_up_rounded,
                colors: colors,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                value: '100',
                label: 'ORDERS',
                valueColor: colors.secondary,
                icon: Icons.receipt_long_rounded,
                colors: colors,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: productCount.toString(),
                label: 'PRODUCTS',
                valueColor: colors.secondary,
                icon: Icons.inventory_2_rounded,
                colors: colors,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                value: '4.5',
                label: 'RATING',
                valueColor: colors.secondary,
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFFFD700),
                colors: colors,
                showStar: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final IconData icon;
  final Color? iconColor;
  final dynamic colors;
  final bool showStar;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.icon,
    required this.colors,
    this.iconColor,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              if (showStar) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700),
                  size: 22,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final dynamic colors;

  const _WeatherCard({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EFF), Color(0xFF9B7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B8EFF).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Temperature row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '24',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFE566),
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sunny',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
              const Text(
                'Perfect for harvest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final dynamic colors;

  const _ActionButtons({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Add product',
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.primary,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded, color: colors.primary, size: 32),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddProductScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _ActionButton(
            label: 'Manage Orders',
            backgroundColor: const Color(0xFFF3EFFF),
            foregroundColor: colors.accent,
            child: Image.asset(
              'assets/images/box.png',
              width: 52,
              height: 52,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.surface.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: colors.accent,
                  size: 30,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FarmerOrdersPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: foregroundColor.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
