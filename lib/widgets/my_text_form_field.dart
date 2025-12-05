import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.labelText,
    this.hint,
    this.prefixIcon,
    this.suffixiocn,
  });

  final String labelText;
  final Text? hint;
  final Icon? prefixIcon;
  final Icon? suffixiocn;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        hint: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixiocn,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff15A305), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff15A305), width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
