import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Config {
  static NumberFormat formatter = NumberFormat('###,###.##');

  static bool loginstatus = false, qrscanstatus = false;

  static List<String> backlist = [];

  static Image? avatar;

  static List<int> bakimidler = [];

  static Map<String, Object> repset = {};

  // Future<Position?> getKonumSec() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return null;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return null;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return null;
  //   }

  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  void loading(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const CupertinoActivityIndicator(),
      ),
    );
  }

  void loadingscan(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          const SizedBox(height: 20, child: CupertinoActivityIndicator()),
    );
  }

  static Future<void> shareFile(
    dynamic docs,
    String name,
    String format, {
    String text = "",
  }) async {
    if (format == "txt") {
      await Share.share(text, subject: name);
    } else {
      Directory? output = await getTemporaryDirectory();

      if (Platform.isIOS) {
        output = await getTemporaryDirectory();
      }

      if (Platform.isAndroid) {
        output = await getExternalStorageDirectory();
      }

      final file = File("${output?.path}/$name.$format");
      await file.writeAsBytes(docs);

      final files = <XFile>[];
      files.add(XFile(file.path));

      if (docs.isEmpty) {
        return;
      } else {
        if (await file.exists()) {
          await Share.shareXFiles(files, subject: name);
        } else {
          await Share.shareXFiles(files, subject: name);
        }
      }
    }
  }

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
      //Yetki kontrol metodu
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
            // cancelButton: CupertinoActionSheetAction(
            //   isDefaultAction: true,
            //   child: const Text("Bitti"),
            //   onPressed: () {
            //     FocusScopeNode currentFocus = FocusScope.of(context);

            //     if (!currentFocus.hasPrimaryFocus) {
            //       currentFocus.unfocus();
            //     }
            //     Navigator.pop(context);
            //   },
            // ),
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

  static void showDialogCoportion(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  static void showsnack(
    BuildContext context,
    String message, {
    Color? color = const Color.fromARGB(111, 27, 111, 255),
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: color,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            color: Color.fromARGB(139, 253, 253, 253),
            fontWeight: FontWeight.bold,
            fontFamily: 'BakbakOne',
          ),
        ),
      ),
    );
  }

  static Future<String> saveimagestr(
    BuildContext context,
    String baseimage,
  ) async {
    if (baseimage == "null") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromARGB(111, 255, 27, 27),
          content: Text(
            textAlign: TextAlign.center,
            "Resim yok",
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(139, 253, 253, 253),
              fontWeight: FontWeight.bold,
              fontFamily: 'BakbakOne',
            ),
          ),
        ),
      );
      return "";
    }

    final encodedStr = baseimage;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/vass.png';
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    ImageGallerySaverPlus.saveImage(bytes);
    if (!context.mounted) return file.path;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Color.fromARGB(111, 27, 111, 255),
        content: Text(
          textAlign: TextAlign.center,
          "Kaydedildi",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(139, 253, 253, 253),
            fontWeight: FontWeight.bold,
            fontFamily: 'BakbakOne',
          ),
        ),
      ),
    );

    return file.path;
  }
}
