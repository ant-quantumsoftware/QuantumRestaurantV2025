import 'package:flutter/material.dart';

import '../../features/presentation/pages/app_logs_page.dart';
import '../../features/presentation/pages/dialogmasa_aktar.dart';
import '../../features/presentation/pages/fast_description_list_page.dart';
import '../../features/presentation/pages/home/table_card_theme_page.dart';
import '../../features/presentation/pages/home_page.dart';
import '../../features/presentation/pages/login/connection_settings.dart';
import '../../features/presentation/pages/login/login.dart';
import 'route_names.dart';

class PageRoutes {
  Map<String, WidgetBuilder> routes() {
    return {
      RouteNames.homePage: (context) => const HomePage(),
      // tableSelectionPage: (context) => const TableSelectionPage(),
      // adisyonpage: (context) => const AdisyonPage(),
      RouteNames.settingspage: (context) => const ConnectionSettings(),
      RouteNames.fastDescriptionPage: (context) =>
          const FastDescriptionListPage(),
      RouteNames.appLogsPage: (context) => const AppLogsPage(),
      RouteNames.tableCardThemePage: (context) => const TableCardThemePage(),
      RouteNames.loginpage: (context) => const MyLogin(),
      RouteNames.masaaktar: (context) => const MyDialogMasaAktar(),
    };
  }
}
