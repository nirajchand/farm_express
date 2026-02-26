import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/features/farmer_dashboard/presentation/pages/farmer_dashboard.dart';
import 'package:farm_express/features/farmer_profile/presentation/pages/farmer_profile_screen.dart';
import 'package:farm_express/features/order/presentation/farmer/pages/farmer_order.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/farmer_product.dart';
import 'package:flutter/material.dart';

class FarmerBottonNavigationScreen extends StatefulWidget {
  const FarmerBottonNavigationScreen({super.key});

  @override
  State<FarmerBottonNavigationScreen> createState() => _FarmerBottonNavigationScreenState();
}

class _FarmerBottonNavigationScreenState extends State<FarmerBottonNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    FarmersPage(),
    FarmerOrdersPage(),
    FarmerProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
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
