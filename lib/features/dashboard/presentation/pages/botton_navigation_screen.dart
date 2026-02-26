import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/features/cart/presentation/pages/cart_screen.dart';
import 'package:farm_express/features/consumer_profile/presentation/pages/profile_screen.dart';
import 'package:farm_express/features/dashboard/presentation/pages/bottomScreen/search_screen.dart';
import 'package:farm_express/features/product/presentation/consumer/pages/home_screen.dart';
import 'package:flutter/material.dart';

class BottonNavigationScreen extends StatefulWidget {
  const BottonNavigationScreen({super.key});

  @override
  State<BottonNavigationScreen> createState() => _BottonNavigationScreenState();
}

class _BottonNavigationScreenState extends State<BottonNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    HomeScreen(),
    SearchProductPage(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: lstBottomScreen[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.black,
        iconSize: 30,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
