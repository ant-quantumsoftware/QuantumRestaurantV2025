import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CuperAlert {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required bool destructive,
    Image? image,
  }) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(alignment: Alignment.center, child: Text(title)),
            ),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(content),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      image ??
                      (destructive
                          ? Icon(Icons.error, color: Colors.red)
                          : Icon(Icons.check_circle, color: Colors.green)),
                ),
              ],
            ),
          ),
    );
  }
}
