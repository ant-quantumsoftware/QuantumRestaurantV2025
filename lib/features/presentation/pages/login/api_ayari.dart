import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../components/group_box.dart';
import '../../components/input2.dart';
import '../../components/tablo_satir.dart';

class ApiAyari extends StatefulWidget {
  const ApiAyari({super.key});

  @override
  State<ApiAyari> createState() => _ApiAyariState();
}

class _ApiAyariState extends State<ApiAyari> {
  bool start = false, passshow = true;
  TextEditingController apitxt = TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: CupertinoButton.filled(
            child: const Text("Kaydet"),
            onPressed: () {
              hatatxt = "";
              savesett();
            },
          ),
        ),
      ],
      body: (start)
          ? const Center(child: CupertinoActivityIndicator(radius: 15.0))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Groupbox(
                    baslik: "Ayarlar",
                    children: <Widget>[
                      FormSatir(
                        metin: "Api Adresi",
                        baslik: Input2(
                          texteditcontrol: apitxt,
                          label: "Api / IP adresi.",
                          inputype: const TextInputType.numberWithOptions(
                            signed: true,
                          ),
                          inputValue: apitxt.text,
                          textValue: (val) {
                            apitxt.text = val.toString();
                          },
                        ),
                      ),
                      FormSatir(
                        metin: "Parola",
                        baslik: Input2(
                          texteditcontrol: password,
                          passwordstatus: passshow,
                          maxline: 1,
                          label: "Parola.",
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
                    ],
                  ),
                  const SizedBox(height: 500),
                ],
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

    Navigator.pop(context);
  }
}
