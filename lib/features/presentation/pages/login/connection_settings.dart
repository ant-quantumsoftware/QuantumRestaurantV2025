import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../components/group_box.dart';
import '../../components/input2.dart';
import '../../components/tablo_satir.dart';

class ConnectionSettings extends StatefulWidget {
  const ConnectionSettings({super.key});

  @override
  State<ConnectionSettings> createState() => _ConnectionSettingsState();
}

class _ConnectionSettingsState extends State<ConnectionSettings> {
  static const String _demoServerAddress = 'api.quantumyazilim.com';
  static const String _defaultAdminPassword = '026012016';
  bool start = false, passshow = true;
  TextEditingController apitxt = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController adminPassword = TextEditingController();
  String? hatatxt = "";
  late Box box1;

  @override
  void initState() {
    //
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logininfo');
    getdata();
  }

  void getdata() async {
    if (box1.get('apiAdres') != null) {
      apitxt.text = box1.get('apiAdres');
      setState(() {
        start = false;
      });
    }
    if (box1.get('apiParolasi') != null) {
      password.text = box1.get('apiParolasi');
      setState(() {
        start = false;
      });
    }
    final storedAdminPassword = box1.get('adminParolasi');
    if (storedAdminPassword is String &&
        storedAdminPassword.trim().isNotEmpty) {
      adminPassword.text = storedAdminPassword.trim();
    } else {
      adminPassword.text = _defaultAdminPassword;
    }
    setState(() {
      start = false;
    });
  }

  @override
  void dispose() {
    apitxt.dispose();
    password.dispose();
    adminPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        child: start
            ? const Center(child: CupertinoActivityIndicator(radius: 15.0))
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.06),
                      colorScheme.surface,
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outline.withValues(
                                alpha: 0.12,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  CupertinoIcons.settings_solid,
                                  color: colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sunucu Bağlantısı',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Uygulamanın bağlanacağı API adresini buradan güncelleyebilirsiniz. Demo sunucu ile örnek ortamı hızlıca açabilirsiniz.',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.hintColor,
                                            height: 1.35,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Groupbox(
                        baslik: 'Ayarlar',
                        children: <Widget>[
                          FormSatir(
                            metin: 'Api Adresi',
                            baslik: Input2(
                              texteditcontrol: apitxt,
                              label: 'Api / IP adresi.',
                              inputype: TextInputType.text,
                              inputValue: apitxt.text,
                              textValue: (val) {
                                apitxt.text = val.toString();
                              },
                            ),
                          ),
                          FormSatir(
                            metin: 'Parola',
                            baslik: Input2(
                              texteditcontrol: password,
                              passwordstatus: passshow,
                              maxline: 1,
                              label: 'Parola.',
                              inputValue: password.text,
                              textValue: (val) async {
                                password.text = val.toString();
                              },
                              sagwigdet: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: passshow
                                    ? const Icon(CupertinoIcons.eye, size: 16)
                                    : const Icon(
                                        CupertinoIcons.eye_slash,
                                        size: 16,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    passshow = !passshow;
                                  });
                                },
                              ),
                            ),
                          ),
                          FormSatir(
                            metin: 'Admin Parolası',
                            baslik: Input2(
                              texteditcontrol: adminPassword,
                              passwordstatus: passshow,
                              maxline: 1,
                              label: 'Admin parolası.',
                              inputValue: adminPassword.text,
                              textValue: (val) {
                                adminPassword.text = val.toString();
                              },
                              sagwigdet: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: passshow
                                    ? const Icon(CupertinoIcons.eye, size: 16)
                                    : const Icon(
                                        CupertinoIcons.eye_slash,
                                        size: 16,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    passshow = !passshow;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    apitxt.text = _demoServerAddress;
                                    hatatxt = '';
                                  });
                                  savesett();
                                },
                                icon: const Icon(CupertinoIcons.globe),
                                label: const Text('Demo sunucu kullan'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () {
                                  hatatxt = '';
                                  savesett();
                                },
                                icon: const Icon(CupertinoIcons.check_mark),
                                label: const Text('Kaydet'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: colorScheme.surfaceContainerHighest,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'İptal',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // void commandLaunch(command) async {
  //   if (await canLaunch(command)) {
  //     await launch(command);
  //   } else {
  //     print(' could not launch $command');
  //   }
  // }

  Future<void> savesett() async {
    box1.put('apiAdres', apitxt.text);
    box1.put('apiParolasi', password.text);
    box1.put(
      'adminParolasi',
      adminPassword.text.trim().isEmpty
          ? _defaultAdminPassword
          : adminPassword.text.trim(),
    );

    Navigator.pop(context);
  }
}
