import 'package:farm_express/constants/colors.dart';
import 'package:farm_express/screens/botton_navigation_screen.dart';
import 'package:farm_express/screens/dashboard_screen.dart';
import 'package:farm_express/screens/signup_screen.dart';
import 'package:farm_express/widgets/elevated_button.dart';
import 'package:farm_express/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _ConsumerLoginScreenState();
}

class _ConsumerLoginScreenState extends State<LoginScreen> {
  bool isSignIn = true;
  @override
  Widget build(BuildContext context) {
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
                      labelText: "Email address",
                      hint: Text(
                        "e.g abc123@gmail.com",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                    ),
                    SizedBox(height: 15),
                    MyTextFormField(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                      suffixiocn: Icon(
                        Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
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
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottonNavigationScreen(),
                            ),
                          );
                        });
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
          ],
        ),
      ),
    );
  }
}
