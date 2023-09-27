import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Tajawal',
  useMaterial3: true,
  primarySwatch: Constants.primaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade100,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey.shade100,
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Tajawal',
  useMaterial3: true,
  // primarySwatch: Constants.darkColor,
  cardColor: Constants.darkColor,
  colorScheme: const ColorScheme.dark(
    primary: Constants.darkColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF14213d),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF14213d),
);
