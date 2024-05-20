import 'package:flutter/material.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Colors.transparent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
    ),
    primaryColor: Colors.green,
    primarySwatch: Colors.green,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF154478),
      primary: const Color(0xFF154478),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xD1EAEAEA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(width: 1, color: Color(0xFFF4F4F4)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Lato',
    scaffoldBackgroundColor: const Color(0xFF151619),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
    ),
    primaryColor: Colors.green,
    primarySwatch: Colors.green,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFB5B5B5),
      primary: const Color(0xFFB5B5B5),
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Color(0xFFEAEAEA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Color(0xFFB5B5B5)),
      ),
    ),
  );
}
