import 'package:flutter/material.dart';
/// Основные цвета для темы
class AppColors {
  static const Color background = Color(0xFF0E1124);
  static const Color appBar = Color(0xFF1E2342);
  static const Color bubbleMe = Color(0xFF1C2A93);
  static const Color bubbleOther = Color(0xFF262B45);
  static const Color inputBackground = Color(0xFF101330);
}

/// Тема оформления приложения
class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBar,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.appBar,
    ),
  );
}
