import 'package:flutter/material.dart';
import 'package:wedel/consts/app_colors.dart';

class styles
{
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context})
  {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColor.darkScafold
          :AppColor.lightScaffoldColor,
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 0, 0, 0)
          : AppColor.lightCardColor,
      brightness: isDarkTheme? Brightness.light :Brightness.dark,
    );
  }
}