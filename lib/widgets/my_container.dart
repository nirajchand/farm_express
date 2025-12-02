import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({
    super.key,
    required this.height,
    required this.width,
    required this.role,
    required this.icon,
  });

  final double height;
  final double width;
  final Text role;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(children: [SizedBox(height: 20), icon, role]),
    );
  }
}
