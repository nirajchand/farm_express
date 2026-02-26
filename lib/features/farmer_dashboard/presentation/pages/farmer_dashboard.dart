import 'package:farm_express/features/order/presentation/farmer/pages/farmer_order.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Color palette ────────────────────────────────────────────────────────────
const kGreen = Color(0xFF2ECC52);
const kGreenDark = Color(0xFF1BAA3D);
const kGreenLight = Color(0xFFE9F9ED);
const kWhite = Colors.white;
const kTextDark = Color(0xFF1A1A1A);
const kTextGrey = Color(0xFF8A8A8A);
const kPurple = Color(0xFF7B61FF);
const kPurpleLight = Color(0xFFB8A9FF);

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

    final productCount = productState.products?.length ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 24),

              _StatsGrid(productCount: productCount),
              const SizedBox(height: 20),

              _WeatherCard(),
              const SizedBox(height: 20),

              _ActionButtons(),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Farmers',
          style: TextStyle(
            color: kGreen,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        _NotificationBell(),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: kGreenLight,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications_outlined, color: kTextDark, size: 22),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: kGreen,
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

  const _StatsGrid({required this.productCount});
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
                valueColor: kGreen,
                icon: Icons.trending_up_rounded,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                value: '100',
                label: 'ORDERS',
                valueColor: kGreen,
                icon: Icons.receipt_long_rounded,
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
                valueColor: kGreen,
                icon: Icons.inventory_2_rounded,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                value: '4.5',
                label: 'RATING',
                valueColor: kGreen,
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFFFD700),
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
  final bool showStar;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.icon,
    this.iconColor,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: kWhite,
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
            style: const TextStyle(
              color: kTextGrey,
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
                  color: kWhite,
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
                    color: kWhite,
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
                  color: kWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
              const Text(
                'Perfect for harvest',
                style: TextStyle(
                  color: kWhite,
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Add product',
            backgroundColor: kGreenLight,
            foregroundColor: kGreen,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: kGreen, size: 32),
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
            foregroundColor: kPurple,
            child: Image.asset(
              'assets/images/box.png',
              width: 52,
              height: 52,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: kPurple,
                  size: 30,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (_) => FarmerOrdersPage()));
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
