import 'package:flutter/material.dart';

class ConsumerLoginScreen extends StatelessWidget {
  const ConsumerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Center(child: Image.asset("assets/images/project_logo.png")),
          Container(
            width: double.infinity,
            height: 500,
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
            child: Column(
              children: [
                Text(
                  "Welcome Back !",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff008000),
                  ),
                ),
                Text(
                  "Sign in to your account",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff008000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
