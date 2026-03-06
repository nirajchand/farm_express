// reset_password_screen.dart

import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.passwordReset) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Password reset successful! Please login."),
            backgroundColor: colors.success,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? "Something went wrong"),
            backgroundColor: colors.error,
          ),
        );
      }
    });

    InputDecoration _fieldDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textSecondary),
        prefixIcon: Icon(icon, color: colors.primary),
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
      );
    }

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
                "Reset Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Create a new strong password for your account.",
                style: TextStyle(fontSize: 16, color: colors.textSecondary),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                style: TextStyle(color: colors.textPrimary),
                decoration: _fieldDecoration(
                  "New Password",
                  Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: colors.textPrimary),
                decoration: _fieldDecoration(
                  "Confirm Password",
                  Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref
                              .read(authViewModelProvider.notifier)
                              .resetPassword(
                                token: widget.token,
                                newPassword: _newPasswordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
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
                  child: isLoading
                      ? CircularProgressIndicator(color: colors.white)
                      : const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
