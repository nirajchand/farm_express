import 'package:farm_express/constants/colors.dart';
import 'package:farm_express/screens/login_screen.dart';
import 'package:farm_express/widgets/elevated_button.dart';
import 'package:farm_express/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                      "Join Our Community",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: kGreenColor,
                      ),
                    ),
                    Text(
                      "Create yout account",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kGreenColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    MyTextFormField(
                      labelText: "Full Name",
                      prefixIcon: Icon(
                        Icons.person_3_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 15),
                    MyTextFormField(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                      suffixiocn: Icon(
                        Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: MyElevatedButton(
                        onPressed: () {},
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        text: "Create Your Account",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsumerLoginScreen(),
                            ),
                          );
                        });
                      },
                      child: Text(
                        "Already have an account? SignIn",
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
