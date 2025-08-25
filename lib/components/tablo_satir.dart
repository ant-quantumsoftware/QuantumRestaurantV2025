import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSatir extends StatelessWidget {
  final Widget? baslik, altbaslik, komponet;
  final String metin;
  final bool aktif;
  final VoidCallback? onpress;
  final VoidCallback? onlongpress;
  const FormSatir({
    super.key,
    this.metin = "",
    this.baslik,
    this.altbaslik,
    this.komponet,
    this.onpress,
    this.onlongpress,
    this.aktif = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      padding: const EdgeInsets.all(0),
      prefix: metin != ""
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 80,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: .3,
                  ),
                )),
                child: Text(
                  metin,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            )
          : null,
      child: ListTile(
        enabled: aktif,
        onTap: onpress,
        onLongPress: onlongpress,
        title: baslik,
        subtitle: altbaslik,
        trailing: komponet,
      ),
    );
  }
}
