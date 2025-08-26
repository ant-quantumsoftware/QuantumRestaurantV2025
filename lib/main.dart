import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/login/login.dart';
import 'features/data/models/dataGet/food_item_model.dart';
import 'locale/language_cubit.dart';
import 'locale/locales.dart';
import 'core/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Veritabanı Ayarla
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemModelAdapter());
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]); */

  runApp(ProviderScope(child: Phoenix(child: const SuzlonOrdering())));
}

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
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
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
            themeMode: ThemeMode.system,
            home: const MyLogin(),
            routes: PageRoutes().routes(),
            theme: ThemeData(
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
                headlineSmall: TextStyle(
                  fontSize: 102,
                  color: Color(0xff222831),
                ),
                headlineMedium: TextStyle(
                  fontSize: 64,
                  color: Color(0xff222831),
                ),
                headlineLarge: TextStyle(
                  fontSize: 51,
                  color: Color(0xff222831),
                ),
                displayLarge: TextStyle(fontSize: 36, color: Color(0xff222831)),
                displayMedium: TextStyle(
                  fontSize: 25,
                  color: Color(0xff222831),
                ),
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
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.black,
              brightness: Brightness.dark,
              dividerColor: Colors.black12,
              hintColor: Colors.white,
              splashColor: const Color.fromARGB(255, 24, 23, 23),
              dividerTheme: const DividerThemeData(color: Colors.white38),
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.black,
              iconTheme: const IconThemeData(color: Color(0xffeeeeee)),
              textTheme: const TextTheme(
                headlineSmall: TextStyle(
                  fontSize: 102,
                  color: Color(0xffeeeeee),
                ),
                headlineMedium: TextStyle(
                  fontSize: 64,
                  color: Color(0xffeeeeee),
                ),
                headlineLarge: TextStyle(
                  fontSize: 51,
                  color: Color(0xffeeeeee),
                ),
                displayLarge: TextStyle(fontSize: 36, color: Color(0xffeeeeee)),
                displayMedium: TextStyle(
                  fontSize: 25,
                  color: Color(0xffeeeeee),
                ),
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
            ),
          );
        },
      ),
    );
  }
}
