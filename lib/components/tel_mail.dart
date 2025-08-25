import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../components/liste_menu.dart';
import '../config/config.dart';

class ContactBox extends StatelessWidget {
  final String phone, name, mail, web;
  final String? avatar, info;
  final Function()? onpress;
  final bool? showmessage, showphone, showwhatsapp, showmail, showweb;
  const ContactBox({
    super.key,
    required this.phone,
    required this.name,
    this.mail = "",
    this.web = "",
    this.info = "",
    this.avatar = "",
    this.showmessage = true,
    this.showphone = true,
    this.showwhatsapp = false,
    this.showmail = false,
    this.showweb = false,
    this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 0, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          ListeMenu(
            tablo: true,
            baslik: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    name == "" ? "Yönetici adı belirtilmemiş" : name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    phone == "" ? "Telefon bilgisi yok..." : phone,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                info != ""
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          info!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : const SizedBox(height: 0),
              ],
            ),
            ikon: avatar.toString() != ""
                ? Image.memory(base64Decode(avatar!))
                : CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: name == ""
                        ? const Text("YA")
                        : Text(name.substring(0, 2)),
                  ),
            onpress:
                onpress ??
                () {
                  if (avatar != null) {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return CupertinoActionSheet(
                              title: Text('$name Resim/Logo'),
                              cancelButton: CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                child: const Text("Vazgeç"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text("Kaydet"),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Config.saveimagestr(context, avatar!);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                },
          ),
          CupertinoFormRow(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Visibility(
                    visible: showmessage!,
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          if (phone != "") {
                            launchUrl(Uri.parse("sms://$phone"));
                          }
                        },
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: phone == "" ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.conversation_bubble,
                                size: 28,
                                color: Colors.white,
                              ),
                              Text(
                                "Mesaj",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showmessage!,
                    child: const SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: showphone!,
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          if (phone != "") {
                            launchUrl(Uri.parse("tel://$phone"));
                          }
                        },
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: phone == "" ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.phone,
                                size: 28,
                                color: Colors.white,
                              ),
                              Text(
                                "ara",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showphone!,
                    child: const SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: showwhatsapp!,
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          if (phone != "") {
                            launchUrl(
                              Uri.parse("whatsapp://send?phone=+9$phone"),
                            );
                          }
                        },
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: phone == "" ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble_2,
                                size: 28,
                                color: Colors.white,
                              ),
                              Text(
                                "Whatsapp",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showmail!,
                    child: const SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: showmail!,
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          if (mail != "") {
                            launchUrl(Uri.parse("mailto:$mail"));
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 50,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: mail == "" ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.envelope,
                                size: 28,
                                color: Colors.white,
                              ),
                              Text(
                                "e-posta",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showweb!,
                    child: const SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: showweb!,
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          if (web != "") {
                            launchUrl(Uri.parse("https:$web"));
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 50,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: web == "" ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.globe,
                                size: 28,
                                color: Colors.white,
                              ),
                              Text(
                                "WEB",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
