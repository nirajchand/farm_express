import 'package:farm_express/core/constants/colors.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    required this.text,
  });
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            Theme.of(
              context,
            ).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        foregroundColor:
            foregroundColor ??
            Theme.of(
              context,
            ).elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
