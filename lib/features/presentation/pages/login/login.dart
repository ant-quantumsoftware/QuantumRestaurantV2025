import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/config/config.dart';
import '../../../../core/config/settings.dart';
import '../../../data/models/dataGet/food_categori_model.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../../data/models/dataPost/login_model.dart';
import '../../components/input2.dart';
import '../../components/tablo_satir.dart';
import '../../pages/cuper_alert.dart';
import '../home/home_view.dart';
import 'api_ayari.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false, passwordshow = true, autologin = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
    autologin = false;

    if (box1.get('email') != null) {
      email.text = box1.get('email');
      isChecked = true;
      autologin = true;
    } else {
      autologin = false;
    }

    if (box1.get('password') != null && box1.get('password') != '') {
      password.text = box1.get('password');
      isChecked = true;
      autologin = true;
    } else {
      autologin = false;
    }

    if (box1.get('apiAdres') != null) {
      String apiadres = box1.get('apiAdres');

      if (apiadres != "") {
        Settings.setApiAdres(apiadres);
      }
    }
    if (autologin) {
      hatatxt = "";
      login();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: autologin
            ? _buildSplash(theme, colorScheme)
            : _buildLoginBody(theme, colorScheme),
      ),
    );
  }

  Widget _buildSplash(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.tertiary,
            colorScheme.secondary,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -30,
            child: _buildGlow(140, Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            left: -50,
            bottom: -70,
            child: _buildGlow(180, Colors.white.withValues(alpha: 0.05)),
          ),
          Center(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quantum',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                      fontFamily: 'BakbakOne',
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Restaurant',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontFamily: 'BakbakOne',
                      fontSize: 12,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBody(ThemeData theme, ColorScheme colorScheme) {
    final tintedBackground = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.03),
      theme.scaffoldBackgroundColor,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.07),
            tintedBackground,
            tintedBackground,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: -40,
                right: -30,
                child: _buildGlow(
                  120,
                  colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                bottom: -55,
                left: -35,
                child: _buildGlow(
                  160,
                  colorScheme.tertiary.withValues(alpha: 0.08),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FadeInUp(
                                duration: const Duration(milliseconds: 900),
                                child: _buildHeader(theme, colorScheme),
                              ),
                              const SizedBox(height: 22),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1100),
                                child: _buildLoginCard(theme, colorScheme),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Config.gotopage(
                              context,
                              const ApiAyari(),
                              '',
                              'Asansör Ana Sayfa',
                              yarim: true,
                              baslik: 'Bağlantı Ayarları',
                              message:
                                  'Lütfen IP Adresinizi yazın ve kaydedin.',
                            );
                          },
                          icon: const Icon(CupertinoIcons.settings),
                          label: const Text('Bağlantı Ayarları'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 14),
            Text(
              'Quantum',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontFamily: 'BakbakOne',
                fontSize: 42,
                color: colorScheme.onSurface,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Restaurant yönetim paneli',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Text(
        //   'Hesabınıza giriş yapın',
        //   textAlign: TextAlign.center,
        //   style: theme.textTheme.headlineSmall?.copyWith(
        //     fontSize: 24,
        //     fontWeight: FontWeight.w800,
        //   ),
        // ),
        // const SizedBox(height: 6),
        Text(
          'Kullanıcı bilgilerinizi girerek masalar ve sipariş yönetimine devam edin.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            fontSize: 13,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(ThemeData theme, ColorScheme colorScheme) {
    final cardSurface = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      theme.scaffoldBackgroundColor,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 36,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel(theme, 'Kullanıcı Adı veya e-Posta'),
          const SizedBox(height: 6),
          _buildFieldShell(
            child: Input2(
              bgcolors: colorScheme.outline.withValues(alpha: 0.18),
              textcolor: theme.colorScheme.onSurface,
              texteditcontrol: email,
              textsize: 15,
              label: 'Kullanıcı adı / e-Posta',
              solwidget: Icon(
                CupertinoIcons.person_2_fill,
                size: 18,
                color: colorScheme.primary,
              ),
              textValue: (val) {
                email.text = val.toString();
              },
              inputValue: email.text,
            ),
          ),
          const SizedBox(height: 14),
          _buildFieldLabel(theme, 'Parola'),
          const SizedBox(height: 6),
          _buildFieldShell(
            child: Input2(
              textcolor: theme.colorScheme.onSurface,
              bgcolors: colorScheme.outline.withValues(alpha: 0.18),
              textsize: 15,
              texteditcontrol: password,
              label: 'Parola',
              maxline: 1,
              passwordstatus: passwordshow,
              textValue: (val) {
                password.text = val.toString();
              },
              inputValue: password.text,
              solwidget: Icon(
                CupertinoIcons.lock_fill,
                size: 18,
                color: colorScheme.primary,
              ),
              sagwigdet: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  passwordshow ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  size: 16,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    passwordshow = !passwordshow;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          FormSatir(
            baslik: Text('Beni Hatırla', style: theme.textTheme.titleSmall),
            onpress: () {
              isChecked = !isChecked;
              setState(() {});
            },
            komponet: CupertinoSwitch(
              activeTrackColor: colorScheme.primary,
              value: isChecked,
              onChanged: (bool value) {
                isChecked = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () {
              hatatxt = '';
              login();
            },
            icon: const Icon(CupertinoIcons.arrow_right_circle_fill),
            label: const Text('Giriş Yap'),
          ),
          if (hatatxt != null && hatatxt!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded, color: colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hatatxt!,
                      style: TextStyle(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
      ),
    );
  }

  Widget _buildFieldShell({required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fieldSurface = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: 0.025),
      theme.scaffoldBackgroundColor,
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fieldSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: child,
    );
  }

  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
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

  Future<void> verigetironcelikli() async {
    var foodCategoriItems = await getFoodCategoriAll();
    setState(() {
      Settings.setFoodCategoriItems(foodCategoriItems);

      verigetir();
    });
  }

  Future<void> verigetir() async {
    var fooditemsTum = await getFoodItemAll();

    setState(() {
      Settings.setFoodItemAll(fooditemsTum);
    });
  }

  Future<void> login() async {
    if (password.text == '') {
      autologin = false;
      setState(() {});
      return;
    }

    Config().loading(context);

    if (autologin) {
      Navigator.pop(context);
    }

    String token = "";

    try {
      var tokenkey = await LoginModel(
        userName: email.text,
        parola: password.text,
      ).getLoginToken();
      //Wakelock.enable();

      token = tokenkey;
    } on Exception catch (ex) {
      if (!autologin && mounted) {
        Navigator.pop(context);
      }
      String hata = ex.toString();
      if (mounted) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Erişim Hatası!',
          content: 'Bağlantınızı Kontrol Ediniz!\n$hata',
        );
      }
      token = "";
      autologin = false;
      log("hata: $hata");
      if (mounted) {
        setState(() {});
      }
    }

    if (!autologin && mounted) {
      Navigator.pop(context);
    }

    if (token == "") {
      hatatxt = "Kullanıcı Bilgileri Hatalı!";
      autologin = false;
      setState(() {});
    } else {
      Settings.setToken(token);

      Settings.setGarsonAdi(email.text);

      Settings.setGarsonId(1);

      verigetironcelikli();
      verigetir();

      if (mounted) {
        Config.gotopage(
          context,
          HomeView(garsonid: 1, garsonadi: email.text),
          "",
          "Ana Menü",
        );
      }

      if (isChecked) {
        box1.put('email', email.text);
        box1.put('password', password.text);
      }
    }
  }
}
