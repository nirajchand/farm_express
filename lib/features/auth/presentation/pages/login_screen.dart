import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/consumer/dashboard/presentation/pages/botton_navigation_screen.dart';
import 'package:farm_express/features/auth/presentation/pages/signup_screen.dart';
import 'package:farm_express/features/farmer/farmer_dashboard/presentation/pages/farmer_dashboard.dart';
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
    // auth State
    // final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Login Failed!");
      } else if (next.status == AuthStatus.authenticated) {
        final role = next.user!.userType;
        if (role == 'consumer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottonNavigationScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FarmerDashboard()),
          );
        }
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Image.asset("assets/images/project_logo.png")),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.12),
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
                          color: kGreenColor,
                        ),
                      ),
                      Text(
                        "Sign in to your account",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kGreenColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextFormField(
                        controller: _emailController,
                        labelText: "Email address ",
                        hint: Text(
                          "e.g abc123@gmail.com",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      MyTextFormField(
                        controller: _passwordController,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                        suffixiocn: Icon(
                          Icons.visibility_off,
                          color: kPrimaryColor,
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
                          onPressed: () {},
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: kGreenColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      MyElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        // backgroundColor: kPrimaryColor,
                        // foregroundColor: Colors.white,
                        text: "Sign In to Your Account",
                      ),
                      SizedBox(height: 10),
                      Text(
                        "OR",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(color: kPrimaryColor, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: SizedBox(
                          height: 28,
                          child: Image.asset("assets/icons/google.webp"),
                        ),
                        label: const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          });
                        },
                        child: Text(
                          "Create new Account",
                          style: TextStyle(
                            color: kPrimaryColor,
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
