import 'package:farm_express/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.categoryName,
    this.categoryImage,
  });

  final String categoryName;
  final Image? categoryImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kGreenLightColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(50),
              child: categoryImage ?? Image.asset("assets/images/fruits.jpg"),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            categoryName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
