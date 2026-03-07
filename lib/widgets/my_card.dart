import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
import 'package:farm_express/core/services/image_cache/image_cache_service.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCard extends ConsumerWidget {
  final String? imagePath;
  final String? name;
  final double? price;
  final String? unitType;
  final double? rating;

  const MyCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.unitType,
    this.rating,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Card(
      clipBehavior: Clip.hardEdge,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: isDark ? 2 : 6,
      shadowColor: colors.shadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: _buildProductImage(context, ref, colors),
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name ?? "Product Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Rs. $price/$unitType",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(
    BuildContext context,
    WidgetRef ref,
    dynamic colors,
  ) {
    if (imagePath == null || imagePath!.isEmpty) {
      return Container(
        color: colors.surfaceVariant,
        child: Image.asset("assets/images/berrie.webp", fit: BoxFit.cover),
      );
    }

    final imageUrl = ApiEndpoints.serverUrl + imagePath!;
    final isConnectedAsync = ref.watch(networkInfoFutureProvider);

    return isConnectedAsync.when(
      data: (connected) {
        if (connected) {
          // Online: Try network first, fall back to cache on error
          return Image.network(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              // Try to load from cache on error
              final imageCache = ref.read(imageCacheServiceProvider);
              final cachedFile = imageCache.getCachedImage(imageUrl);

              if (cachedFile != null && cachedFile.existsSync()) {
                return Image.file(
                  cachedFile,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorImage(colors),
                );
              }
              return _buildErrorImage(colors);
            },
          );
        } else {
          // Offline: Try cache first
          final imageCache = ref.read(imageCacheServiceProvider);
          final cachedFile = imageCache.getCachedImage(imageUrl);

          if (cachedFile != null && cachedFile.existsSync()) {
            return Image.file(
              cachedFile,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildErrorImage(colors),
            );
          }

          // No cache available
          return _buildOfflineImage(colors);
        }
      },
      loading: () {
        // Still checking connection, try cache while waiting
        final imageCache = ref.read(imageCacheServiceProvider);
        final cachedFile = imageCache.getCachedImage(imageUrl);

        if (cachedFile != null && cachedFile.existsSync()) {
          return Image.file(
            cachedFile,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildErrorImage(colors),
          );
        }

        return Container(
          color: colors.surfaceVariant,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      error: (_, __) => _buildErrorImage(colors),
    );
  }

  Widget _buildErrorImage(dynamic colors) {
    return Container(
      color: colors.surfaceVariant,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colors.textSecondary,
        size: 40,
      ),
    );
  }

  Widget _buildOfflineImage(dynamic colors) {
    return Container(
      color: colors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, color: colors.textSecondary, size: 35),
          const SizedBox(height: 4),
          Text(
            'Offline',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
