import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/bottom_bar.dart';
import '../config/app_config.dart';
import '../core/routes/routes.dart';
import 'language_cubit.dart';

class LanguageList {
  final String? title;

  LanguageList({this.title});
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool sliderValue = false;
  late LanguageCubit _languageCubit;
  String? selectedLocal;

  @override
  void initState() {
    super.initState();
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Dil Seçimi',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        // titleSpacing: 0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.chevron_left,
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              BlocBuilder<LanguageCubit, Locale>(
                builder: (context, currentLocale) {
                  selectedLocal ??= currentLocale.languageCode;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppConfig.languagesSupported.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => RadioListTile(
                      value: AppConfig.languagesSupported.keys.elementAt(index),
                      groupValue: selectedLocal,
                      title: Text(
                        AppConfig
                            .languagesSupported[AppConfig
                                .languagesSupported
                                .keys
                                .elementAt(index)]!
                            .name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(),
                      ),
                      onChanged: (langCode) =>
                          setState(() => selectedLocal = langCode as String),
                    ),
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              text: 'Onayla',
              onTap: () {
                _languageCubit.setCurrentLanguage(selectedLocal!, true);
                Navigator.pushNamed(context, PageRoutes.tableSelectionPage);
              },
            ),
          ),
        ],
      ),
    );
  }
}
