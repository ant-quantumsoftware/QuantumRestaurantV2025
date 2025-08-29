import 'package:flutter/material.dart';

import '../../features/presentation/pages/dialogmasa_aktar.dart';
import '../../features/presentation/pages/home_page.dart';
import '../../features/presentation/pages/login/api_ayari.dart';
import '../../features/presentation/pages/login/login.dart';

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
