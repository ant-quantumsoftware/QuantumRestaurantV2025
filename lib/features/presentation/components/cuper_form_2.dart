import 'package:flutter/material.dart';

class Cuperform2 extends StatelessWidget {
  final Widget? ikon, baslik, altbaslik, komponet;
  final Color color, selectedcolor;
  final bool aktif, tablo;
  final VoidCallback? onpress;
  final VoidCallback? onlongpress;
  const Cuperform2({
    super.key,
    this.ikon,
    this.baslik,
    this.altbaslik,
    this.komponet,
    this.onpress,
    this.onlongpress,
    this.color = Colors.transparent,
    this.selectedcolor = Colors.transparent,
    this.aktif = true,
    this.tablo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selectedcolor,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          enabled: aktif,
          onTap: aktif ? onpress : null,
          onLongPress: aktif ? onlongpress : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          splashColor: Colors.blue.withValues(alpha: 0.1),
          leading:
              (ikon != null)
                  ? (tablo == false)
                      ? Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ikon,
                      )
                      : ikon
                  : null,
          title: baslik,
          subtitle: altbaslik,
          trailing: komponet,
        ),
      ),
    );
  }
}
