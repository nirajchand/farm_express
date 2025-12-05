import 'dart:async';
import 'package:farm_express/constants/colors.dart';
import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:farm_express/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Spacer(),
            Image.asset("assets/images/project_logo.png", width: 200),
            Spacer(),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              strokeWidth: 4,
            ),
            SizedBox(height: 16),
            Text(
              "Loading..",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
