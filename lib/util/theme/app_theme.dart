import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.blue,
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.grey.shade200,
      cardColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.blue),
        prefixIconColor: Colors.blue, // Icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.blueGrey,
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[850],
      shadowColor: Colors.black.withOpacity(0.7),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.blueAccent),
        prefixIconColor: Colors.blueAccent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueGrey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
