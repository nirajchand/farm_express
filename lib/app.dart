import 'package:farm_express/screens/splash_screen.dart';
import 'package:farm_express/theme/theme_data.dart';
import 'package:farm_express/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationLightTheme(),
      darkTheme: getApplicationDarkTheme(),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
