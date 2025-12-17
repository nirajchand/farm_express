import 'package:farm_express/constants/colors.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key});

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
              child: Image.asset("assets/images/fruits.jpg", width: 18),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Fruits",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
