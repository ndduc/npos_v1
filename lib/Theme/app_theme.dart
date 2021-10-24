import 'package:flutter/material.dart';
class AppThemes{
  static final appThemData={
    AppTheme.lightTheme:ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.deepOrange,
      accentColor: Colors.white,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    AppTheme.darkTheme:ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: Colors.teal,
      backgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.white,
        ),
      ),
    )
  };
}
enum AppTheme {
  lightTheme,
  darkTheme,
}