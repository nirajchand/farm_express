// signup_screen.dart

import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:farm_express/widgets/elevated_button.dart';
import 'package:farm_express/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register() async {
    if (_formkey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(
            fullName: _fullNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage!);
      } else if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          "Registration successful! Please login.",
        );
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(backgroundColor: colors.background, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Image.asset("assets/images/project_logo.png")),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.12),
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Text(
                        "Join Our Community",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyTextFormField(
                        controller: _fullNameController,
                        labelText: "Full Name",
                        prefixIcon: Icon(
                          Icons.person_3_rounded,
                          color: colors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      MyTextFormField(
                        controller: _emailController,
                        labelText: "Email address",
                        hint: Text(
                          "e.g abc123@gmail.com",
                          style: TextStyle(color: colors.textSecondary),
                        ),
                        prefixIcon: Icon(Icons.email, color: colors.primary),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      MyTextFormField(
                        controller: _passwordController,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: colors.primary),
                        suffixiocn: Icon(
                          Icons.visibility_off,
                          color: colors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      MyTextFormField(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock, color: colors.primary),
                        suffixiocn: Icon(
                          Icons.visibility_off,
                          color: colors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: MyElevatedButton(
                          onPressed: _register,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.white,
                          text: "Create Your Account",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Already have an account? SignIn",
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
