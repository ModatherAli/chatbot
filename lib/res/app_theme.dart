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
  primarySwatch: Constants.primaryColor,
  cardColor: Constants.darkColor,
  colorScheme: const ColorScheme.dark(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Constants.primaryDarkColor,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),
  scaffoldBackgroundColor: Constants.primaryDarkColor,
);
