import 'package:farm_express/core/api/api_endpoints.dart';
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
    return Card(
      clipBehavior: Clip.hardEdge, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating != null ? rating.toString() : "N/A",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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