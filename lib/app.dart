import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:farm_express/screens/consumer_login_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConsumerLoginScreen(),
    );
  }
}
