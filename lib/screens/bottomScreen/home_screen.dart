import 'package:farm_express/constants/colors.dart';
import 'package:farm_express/widgets/category_chip.dart';
import 'package:farm_express/widgets/my_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/farmers.png"),
              Icon(Icons.notifications, color: kPrimaryColor),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [CategoryChip(), CategoryChip(), CategoryChip()],
          ),
          SizedBox(height: 10),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text(
              "Browse Products",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, index) {
                return MyCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
