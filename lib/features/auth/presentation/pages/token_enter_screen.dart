// token_enter_screen.dart

import 'package:farm_express/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterTokenPage extends ConsumerStatefulWidget {
  const EnterTokenPage({super.key});

  @override
  ConsumerState<EnterTokenPage> createState() => _EnterTokenPageState();
}

class _EnterTokenPageState extends ConsumerState<EnterTokenPage> {
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              ),
              const SizedBox(height: 20),
              Text(
                "Enter Token",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Paste the token you received in your email.",
                style: TextStyle(fontSize: 16, color: colors.textSecondary),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _tokenController,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  labelText: "Reset Token",
                  labelStyle: TextStyle(color: colors.textSecondary),
                  hintText: "Paste token here",
                  hintStyle: TextStyle(color: colors.textHint),
                  prefixIcon: Icon(
                    Icons.vpn_key_outlined,
                    color: colors.primary,
                  ),
                  filled: true,
                  fillColor: colors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_tokenController.text.trim().isEmpty) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResetPasswordPage(
                          token: _tokenController.text.trim(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
