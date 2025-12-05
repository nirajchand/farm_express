import 'package:farm_express/screens/login_screen.dart';
import 'package:farm_express/widgets/my_container.dart';
import 'package:flutter/material.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(child: Image.asset("assets/images/project_logo.png")),
          SizedBox(height: 80),
          Text(
            "Choose Your Role",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: MyContainer(
                  height: 200,
                  width: 170,
                  role: Text(
                    "I'm\nfarmer",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  icon: Image.asset("assets/icons/primary.png"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: MyContainer(
                  height: 200,
                  width: 170,
                  role: Text(
                    "I'm\nconsumer",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  icon: Image.asset("assets/icons/home.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
