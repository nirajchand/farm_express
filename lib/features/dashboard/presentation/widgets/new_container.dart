import 'package:flutter/material.dart';

class NewContainer extends StatelessWidget {
  final double height;
  final double width;

  const NewContainer({
    super.key,
    required this.height, 
    required this.width});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width
    );
  }
}
