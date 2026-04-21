import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.system);

  static const String _themeModeKey = 'themeModeKey';

  Future<void> getCurrentThemeMode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final value = sharedPreferences.getString(_themeModeKey);

    switch (value) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
        break;
    }
  }

  Future<void> setThemeMode(ThemeMode mode, {bool save = true}) async {
    if (save) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(_themeModeKey, _toStorageValue(mode));
    }
    emit(mode);
  }

  String _toStorageValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
