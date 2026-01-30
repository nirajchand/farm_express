import 'package:farm_express/features/consumer/dashboard/presentation/pages/botton_navigation_screen.dart';
import 'package:farm_express/screens/splash_screen.dart';
import 'package:farm_express/theme/theme_data.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen(),
    );
  }
}
