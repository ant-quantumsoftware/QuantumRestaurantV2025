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

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    splashColor: Colors.white,
    hintColor: Colors.black,
    dividerTheme: const DividerThemeData(color: Colors.grey),
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 242, 243, 247),
    iconTheme: const IconThemeData(color: Color(0xff222831)),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 102, color: Color(0xff222831)),
      headlineMedium: TextStyle(fontSize: 64, color: Color(0xff222831)),
      headlineLarge: TextStyle(fontSize: 51, color: Color(0xff222831)),
      displayLarge: TextStyle(fontSize: 36, color: Color(0xff222831)),
      displayMedium: TextStyle(fontSize: 25, color: Color(0xff222831)),
      displaySmall: TextStyle(fontSize: 18, color: Color(0xff222831)),
      titleLarge: TextStyle(fontSize: 17, color: Color(0xff222831)),
      titleMedium: TextStyle(fontSize: 15, color: Color(0xff222831)),
      titleSmall: TextStyle(fontSize: 16, color: Color(0xff222831)),
      bodyLarge: TextStyle(fontSize: 14, color: Color(0xff282828)),
      bodyMedium: TextStyle(fontSize: 15, color: Color(0xff222831)),
      bodySmall: TextStyle(fontSize: 13, color: Color(0xff222831)),
      labelSmall: TextStyle(fontSize: 11, color: Color(0xff222831)),
      labelLarge: TextStyle(fontSize: 11, color: Color(0xff222831)),
      labelMedium: TextStyle(fontSize: 11, color: Color(0xff222831)),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    dividerColor: Colors.black12,
    hintColor: Colors.white,
    splashColor: const Color.fromARGB(255, 24, 23, 23),
    dividerTheme: const DividerThemeData(color: Colors.white38),
    scaffoldBackgroundColor: Colors.black54,
    cardColor: Colors.black,
    iconTheme: const IconThemeData(color: Color(0xffeeeeee)),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 102, color: Color(0xffeeeeee)),
      headlineMedium: TextStyle(fontSize: 64, color: Color(0xffeeeeee)),
      headlineLarge: TextStyle(fontSize: 51, color: Color(0xffeeeeee)),
      displayLarge: TextStyle(fontSize: 36, color: Color(0xffeeeeee)),
      displayMedium: TextStyle(fontSize: 25, color: Color(0xffeeeeee)),
      displaySmall: TextStyle(fontSize: 18, color: Color(0xffeeeeee)),
      titleLarge: TextStyle(fontSize: 17, color: Color(0xffeeeeee)),
      titleMedium: TextStyle(fontSize: 15, color: Color(0xffeeeeee)),
      titleSmall: TextStyle(fontSize: 16, color: Color(0xffeeeeee)),
      bodyLarge: TextStyle(fontSize: 14, color: Color(0xffeeeeee)),
      bodyMedium: TextStyle(fontSize: 15, color: Color(0xffeeeeee)),
      bodySmall: TextStyle(fontSize: 13, color: Color(0xffeeeeee)),
      labelSmall: TextStyle(fontSize: 11, color: Color(0xffeeeeee)),
      labelLarge: TextStyle(fontSize: 11, color: Color(0xffeeeeee)),
      labelMedium: TextStyle(fontSize: 11, color: Color(0xffeeeeee)),
    ),
  );
}
