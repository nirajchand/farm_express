import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/dashboard/presentation/pages/botton_navigation_screen.dart';
import 'package:farm_express/features/auth/presentation/pages/signup_screen.dart';
import 'package:farm_express/features/farmer_dashboard/presentation/pages/navigation_farmer.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:farm_express/widgets/elevated_button.dart';
import 'package:farm_express/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isSignIn = true;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Login Failed!");
      } else if (next.status == AuthStatus.authenticated) {
        final role = next.user!.userType.trim().toLowerCase();
        if (role == 'consumer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottonNavigationScreen()),
          );
        } else if (role == 'farmer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => FarmerBottonNavigationScreen()),
          );
        }
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
                        "Welcome Back !",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Text(
                        "Sign in to your account",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      MyElevatedButton(
                        onPressed: _login,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.white,
                        text: "Sign In to Your Account",
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Create new Account",
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
