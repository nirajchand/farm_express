import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FarmerDashboard extends ConsumerStatefulWidget {
  const FarmerDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends ConsumerState<FarmerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Farmer Dashboard")),
      body: Column(
        children: [
          Text("Here i admin dashboard page"),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(authViewModelProvider.notifier).logout();
              if (mounted) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Text("LogOut", style: TextStyle(fontSize: 40)),
          ),
        ],
      ),
    );
  }
}
