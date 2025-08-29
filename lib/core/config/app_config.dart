import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';

import '../locale/languages/arabic.dart';
import '../locale/languages/english.dart';
import '../locale/languages/french.dart';
import '../locale/languages/german.dart';
import '../locale/languages/indonesian.dart';
import '../locale/languages/italian.dart';
import '../locale/languages/portuguese.dart';
import '../locale/languages/romanian.dart';
import '../locale/languages/spanish.dart';
import '../locale/languages/swahili.dart';
import '../locale/languages/turkish.dart';

class AppConfig {
  static const String appName = "Quantum Restaurants";
  static const bool isDemoMode = false;
  static const String languageDefault = "en";
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English", english()),
    "ar": AppLanguage("عربى", arabic()),
    "pt": AppLanguage("Portugal", portuguese()),
    "fr": AppLanguage("Français", french()),
    "id": AppLanguage("Bahasa Indonesia", indonesian()),
    "es": AppLanguage("Español", spanish()),
    "it": AppLanguage("italiano", italian()),
    "tr": AppLanguage("Türk", turkish()),
    "sw": AppLanguage("Kiswahili", swahili()),
    "de": AppLanguage("Deutsch", german()),
    "ro": AppLanguage("Română", romanian()),
  };

  static List<String> backlist = [];

  static Future<T?> gotopage<T>(
    BuildContext context,
    Widget page,
    String perm,
    String backname, {
    bool fullscreen = false,
    bool yarim = false,
    bool autoclose = true,
    String baslik = "",
    String message = "",
  }) async {
    if (perm != "") {
      //Yetkiyi kontrol eden metot yada api yazın
      // if (!await yetki(context, perm)) {
      //   return null;
      // }
    }

    if (!context.mounted) return null;

    if (!yarim) {
      if (!fullscreen) {
        backlist.add(backname);
      }

      Widget gespage = GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: page,
      );

      return Navigator.push<T>(
        context,
        CupertinoPageRoute(
          builder: (context) => gespage,
          fullscreenDialog: fullscreen,
        ),
      );
    } else {
      return showCupertinoModalPopup(
        barrierDismissible: autoclose,
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: baslik != ""
                ? FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      baslik,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'BakbakOne',
                      ),
                    ),
                  )
                : null,
            message: message != ""
                ? FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Text(message),
                  )
                : null,
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text("Bitti"),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                Navigator.pop(context);
              },
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  child: page,
                ),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class AppLanguage {
  final String name;
  final Map<String, String> values;
  AppLanguage(this.name, this.values);
}
