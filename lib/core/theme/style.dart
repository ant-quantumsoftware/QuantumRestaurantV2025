import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData appTheme = _buildTheme(Brightness.light);

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
  static final ThemeData lightTheme = _buildTheme(Brightness.light);
  static final ThemeData darkTheme = _buildTheme(Brightness.dark);
}

ThemeData _buildTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;
  final Color primaryColor = isDark
      ? const Color(0xff8A93A6)
      : const Color(0xff5E6F86);
  final ColorScheme colorScheme =
      ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ).copyWith(
        primary: primaryColor,
        secondary: AppColors.newOrderColor,
        tertiary: isDark ? const Color(0xff89A9C2) : const Color(0xff4F7898),
        surface: isDark ? const Color(0xff1A1B20) : Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: isDark ? AppColors.darkTextColor : AppColors.lightTextColor,
      );

  final Color scaffoldColor = isDark
      ? AppColors.darkBackgroundColor
      : AppColors.lightBackgroundColor;
  final Color surfaceColor = isDark
      ? AppColors.darkSurfaceColor
      : AppColors.lightSurfaceColor;
  final Color outlineColor = isDark
      ? const Color(0x22FFFFFF)
      : const Color(0x14000000);

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'ProductSans',
    brightness: brightness,
    primaryColor: primaryColor,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: scaffoldColor,
    canvasColor: scaffoldColor,
    cardColor: surfaceColor,
    dividerColor: outlineColor,
    splashColor: primaryColor.withValues(alpha: isDark ? 0.16 : 0.08),
    hintColor: isDark ? Colors.white70 : Colors.black87,
    iconTheme: IconThemeData(
      color: isDark ? AppColors.darkTextColor : AppColors.lightTextColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: isDark ? 1 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
    ),
    dividerTheme: DividerThemeData(color: outlineColor),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(fontSize: 14, color: colorScheme.onSurface),
      bodyMedium: TextStyle(fontSize: 15, color: colorScheme.onSurface),
      bodySmall: TextStyle(
        fontSize: 13,
        color: colorScheme.onSurface.withValues(alpha: 0.85),
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        color: colorScheme.onSurface.withValues(alpha: 0.75),
      ),
      labelLarge: TextStyle(
        fontSize: 11,
        color: colorScheme.onSurface.withValues(alpha: 0.75),
      ),
      labelMedium: TextStyle(
        fontSize: 11,
        color: colorScheme.onSurface.withValues(alpha: 0.75),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outlineColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outlineColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
    ),
    radioTheme: RadioThemeData(
      overlayColor: WidgetStateProperty.all(colorScheme.primary),
      fillColor: WidgetStateProperty.all(colorScheme.primary),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.outline,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.outline,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colorScheme.primary.withValues(alpha: 0.35)
            : colorScheme.outline.withValues(alpha: 0.3),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
    ),
  );
}
