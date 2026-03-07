import 'package:farm_express/app.dart';
import 'package:farm_express/core/services/hive/hive_service.dart';
import 'package:farm_express/core/services/image_cache/image_cache_service.dart';
import 'package:farm_express/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  await ImageCacheService().init();

  // shared pref
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const MyApp(),
    ),
  );
}
