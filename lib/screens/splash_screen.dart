import 'dart:async';
import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/services/storage/user_session_service.dart';
import 'package:farm_express/features/dashboard/presentation/pages/botton_navigation_screen.dart';
import 'package:farm_express/features/farmer_dashboard/presentation/pages/navigation_farmer.dart';
import 'package:farm_express/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      final userSessionService = ref.read(userSessionServiceProvider);
      final isLoggedIn = userSessionService.isLoggedIn();
      final role = userSessionService.getRole()?.trim().toLowerCase();
      if (isLoggedIn) {
        if(role == 'consumer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottonNavigationScreen()),
          );
        } else if (role == 'farmer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FarmerBottonNavigationScreen()),
          );
        } else {
          // If role is unknown, navigate to onboarding or login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
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
