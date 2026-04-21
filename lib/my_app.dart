import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/locale/language_cubit.dart';
import 'core/locale/locales.dart';
import 'core/routes/routes.dart';
import 'core/theme/style.dart';
import 'core/theme/theme_mode_cubit.dart';
import 'features/presentation/pages/login/login.dart';

class SuzlonOrdering extends StatelessWidget {
  const SuzlonOrdering({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]); */

    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
        BlocProvider<ThemeModeCubit>(
          create: (context) => ThemeModeCubit()..getCurrentThemeMode(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return BlocBuilder<ThemeModeCubit, ThemeMode>(
            builder: (_, themeMode) {
              return MaterialApp(
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.getSupportedLocales(),
                locale: locale,
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                home: const MyLogin(),
                routes: PageRoutes().routes(),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
              );
            },
          );
        },
      ),
    );
  }
}
