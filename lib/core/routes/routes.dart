import 'package:flutter/material.dart';

import '../../features/presentation/pages/dialogmasa_aktar.dart';
import '../../features/presentation/pages/home_page.dart';
import '../../features/presentation/pages/login/api_ayari.dart';
import '../../features/presentation/pages/login/login.dart';
import 'route_names.dart';

class PageRoutes {
  Map<String, WidgetBuilder> routes() {
    return {
      RouteNames.homePage: (context) => const HomePage(),
      // tableSelectionPage: (context) => const TableSelectionPage(),
      // adisyonpage: (context) => const AdisyonPage(),
      RouteNames.settingspage: (context) => const ApiAyari(),
      RouteNames.loginpage: (context) => const MyLogin(),
      RouteNames.masaaktar: (context) => const MyDialogMasaAktar(),
    };
  }
}
