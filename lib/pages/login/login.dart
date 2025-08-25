import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



import '../../components/input2.dart';
import '../../components/tablo_satir.dart';
import '../../config/config.dart';
import '../../config/settings.dart';
import '../../dataGet/food_categori_model.dart';
import '../../dataGet/food_item_model.dart';
import '../../dataPost/login_model.dart';
import '../../pages/cuper_alert.dart';
import '../../pages/masalar/table_selection.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: (autologin)
            ? Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade800,
                      Colors.blue.shade900,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 3000),
                      child: const Text(
                        "Quantum",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          fontFamily: 'BakbakOne',
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 5000),
                      child: const Text(
                        "Restaurant",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'BakbakOne',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue.shade100,
                      Colors.blue.shade600,
                      Colors.blue.shade900,
                    ],
                  ),
                ),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  persistentFooterButtons: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1700),
                      child: CupertinoButton(
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Bağlantı Ayarları",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        onPressed: () => {
                          Config.gotopage(
                            context,
                            const ApiAyari(),
                            "",
                            "Asansör Ana Sayfa",
                            yarim: true,
                            baslik: "Bağlantı Ayarları",
                            message: "Lütfen IP Adresinizi yazın ve kaydedin.",
                          ),
                        },
                      ),
                    ),
                    // FadeInUp(
                    //   duration: const Duration(milliseconds: 1700),
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: Container(
                    //       height: 60,
                    //       width: 180,
                    //       alignment: Alignment.center,
                    //       decoration: const BoxDecoration(
                    //         image: DecorationImage(
                    //           image: AssetImage("assets/logores.png"),
                    //           fit: BoxFit.fill,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MediaQuery.of(context).size.height > 800
                          ? const SizedBox(height: 50)
                          : const SizedBox(height: 0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 50),
                                    FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/logo.png",
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "Quantum",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 3000,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 95),
                                        child: Text(
                                          "Restaurant",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 20),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 3000,
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Kullanıcı Adı veya e-Posta",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1400,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  27,
                                                  90,
                                                  225,
                                                  0.306,
                                                ),
                                                blurRadius: 20,
                                                offset: Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: Input2(
                                              bgcolors: Colors.transparent,
                                              textcolor: Colors.black,
                                              texteditcontrol: email,
                                              textsize: 16,
                                              label:
                                                  "Kullanıcı Adı, TC Kimlik, Tel, e-Posta",
                                              solwidget: const Icon(
                                                CupertinoIcons.person_2_fill,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              textValue: (val) {
                                                email.text = val.toString();
                                              },
                                              inputValue: email.text,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 3000,
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Parola",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  27,
                                                  90,
                                                  225,
                                                  0.306,
                                                ),
                                                blurRadius: 20,
                                                offset: Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                  ),
                                                ),
                                                child: Input2(
                                                  textcolor: Colors.black,
                                                  bgcolors: Colors.transparent,
                                                  textsize: 16,
                                                  texteditcontrol: password,
                                                  label: "Parolanız",
                                                  maxline: 1,
                                                  passwordstatus: passwordshow,
                                                  textValue: (val) {
                                                    password.text = val
                                                        .toString();
                                                  },
                                                  inputValue: password.text,
                                                  solwidget: const Icon(
                                                    CupertinoIcons.lock_fill,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  sagwigdet: CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: passwordshow
                                                        ? const Icon(
                                                            CupertinoIcons.eye,
                                                            size: 16,
                                                          )
                                                        : const Icon(
                                                            CupertinoIcons
                                                                .eye_slash,
                                                            size: 16,
                                                          ),
                                                    onPressed: () {
                                                      setState(() {
                                                        passwordshow =
                                                            !passwordshow;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      FormSatir(
                                        baslik: const Text("Beni Hatırla"),
                                        onpress: () {
                                          isChecked = !isChecked;
                                          setState(() {});
                                        },
                                        komponet: CupertinoSwitch(
                                          value: isChecked,
                                          onChanged: (bool value) {
                                            isChecked = value;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1600,
                                        ),
                                        child: CupertinoButton.filled(
                                          child: const Text("Giriş Yap"),
                                          onPressed: () {
                                            hatatxt = "";

                                            login();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
          TableSelectionPage(garsonid: 1, garsonadi: email.text),
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
