import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? hint;
  final Widget? prefixIcon;
  final Widget?
  suffixiocn; // kept for backward compat but ignored if isPassword=true
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hint,
    this.prefixIcon,
    this.suffixiocn,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _obscure = true;

  // Detect if this field is a password field based on suffixIcon or explicit flag
  bool get _isPassword =>
      widget.isPassword ||
      (widget.suffixiocn != null &&
          widget.suffixiocn is Icon &&
          ((widget.suffixiocn as Icon).icon == Icons.visibility_off ||
              (widget.suffixiocn as Icon).icon == Icons.visibility));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _isPassword ? _obscure : false,
      style: TextStyle(color: colors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        hint: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: colors.primary,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : widget.suffixiocn,
        filled: true,
        fillColor: colors.surfaceVariant,
        floatingLabelStyle: TextStyle(color: colors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
      ),
    );
  }
}
