import 'package:flutter/material.dart';

import '../../Pages/dialogmasa_aktar.dart';
import '../../Pages/home_page.dart';
import '../../Pages/login/api_ayari.dart';
import '../../Pages/login/login.dart';

class PageRoutes {
  static const String homePage = 'home_page';
  static const String tableSelectionPage = 'tableSelectionPage';
  static const String malzemeSelectionPage = 'malzemeSelectionPage';
  static const String adisyonpage = 'adisyon';
  static const String settingspage = 'settings';
  static const String loginpage = 'login';
  static const String masaaktar = 'dialogmasaaktar';

  Map<String, WidgetBuilder> routes() {
    return {
      homePage: (context) => const HomePage(),
      // tableSelectionPage: (context) => const TableSelectionPage(),
      // adisyonpage: (context) => const AdisyonPage(),
      settingspage: (context) => const ApiAyari(),
      loginpage: (context) => const MyLogin(),
      masaaktar: (context) => const MyDialogMasaAktar(),
    };
  }
}
