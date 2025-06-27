import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// Основные цвета для темы
class AppColors {
  static const Color background = Color.fromRGBO(12,12,12,1);
  static const Color appBar = Color.fromRGBO(78, 78, 78, 0.47);
  static const Color primary = Color.fromRGBO(0, 38, 255, 1.0);
  static const Color primaryContainer = Color.fromRGBO(78, 78, 78, 0.23);
  static const Color secondaryContainer = Color.fromRGBO(78, 78, 78, 0.24);

  //rgba(56, 63, 98, 0.47)
  static const Color bubbleMe = Color.fromRGBO(0, 9, 255, 0.23);
  static const Color bubbleOther = Color.fromRGBO(89, 90, 120, 0.23);
  //rgba(89, 90, 120, 0.23)
  static const Color inputBackground = Color.fromRGBO(93, 93, 93, 0.47);
  static const Color linkColor = Color.fromRGBO(0, 122, 255, 0.85);

  static const Color labelColor = Color.fromRGBO(193, 208, 255, 0.58);

  static const List<Color> buttonGradient = [
    Color.fromRGBO(221, 0, 255, 1),
    Color.fromRGBO(27, 0, 204, 1),
    Color.fromRGBO(0, 196, 255, 1),
  ];


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
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondaryContainer:AppColors.secondaryContainer,
      onSecondaryContainer: Colors.white12
    ),
    textTheme: GoogleFonts.inriaSansTextTheme().apply(displayColor: Colors.white, bodyColor: Colors.white,),
  );
}
