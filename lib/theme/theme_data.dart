import 'package:farm_express/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: "OpenSans",
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
  );
}
