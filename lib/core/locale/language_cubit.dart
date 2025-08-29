import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('tr'));

  void localeSelected(String value) {
    emit(Locale(value));
  }

  Future<void> getCurrentLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currLang = sharedPreferences.containsKey("currentLanguageKey")
        ? sharedPreferences.getString("currentLanguageKey")!
        : AppConfig.languageDefault;
    localeSelected(currLang);
  }

  Future<void> setCurrentLanguage(String langCode, bool save) async {
    if (save) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("currentLanguageKey", langCode);
    }
    localeSelected(langCode);
  }
}
