import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:farm_express/widgets/my_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseRoleScreen extends ConsumerStatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends ConsumerState<ChooseRoleScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(backgroundColor: colors.background, elevation: 0),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(child: Image.asset("assets/images/project_logo.png")),
          const SizedBox(height: 80),
          Text(
            "Choose Your Role",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(authViewModelProvider.notifier)
                      .setUserRole(UserRole.farmer);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: MyContainer(
                  height: 200,
                  width: 170,
                  role: Text(
                    "I'm\nfarmer",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  icon: Image.asset("assets/icons/primary.png"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(authViewModelProvider.notifier)
                      .setUserRole(UserRole.consumer);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: MyContainer(
                  height: 200,
                  width: 170,
                  role: Text(
                    "I'm\nconsumer",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
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
