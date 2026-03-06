import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final double? price;
  final double? rating;

  const MyCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
                imagePath != null
                    ? ApiEndpoints.serverUrl + imagePath!
                    : "assets/images/berrie.webp",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: colors.surfaceVariant,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colors.textSecondary,
                    size: 40,
                  ),
                ),
              ),
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
                        "Rs. $price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating != null ? rating.toString() : "N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
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
}
