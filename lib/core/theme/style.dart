import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'ProductSans',
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 252, 252),
  primaryColor: Color.fromARGB(255, 101, 180, 137),
  cardColor: Color.fromARGB(255, 170, 172, 197),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 122, 120, 120), // AppBar rengi
    elevation: 0.0,
  ),

  //text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(),
    titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
    headlineSmall: TextStyle(),
    bodySmall: TextStyle(),
  ).apply(bodyColor: Colors.black),

  radioTheme: RadioThemeData(
    overlayColor: WidgetStateProperty.all(AppColors.whiteColor),
    fillColor: WidgetStateProperty.all(AppColors.whiteColor),
  ),
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: Color.fromARGB(255, 143, 143, 170),
  ),
);

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headlineSmall    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// titleMedium    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyLarge)
/// body2        14.0  regular  0.25  (bodyMedium)
/// button       14.0  medium   1.25
/// bodySmall      12.0  regular  0.4
/// overline     10.0  regular  1.5
