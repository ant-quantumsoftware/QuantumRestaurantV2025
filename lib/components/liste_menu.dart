import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListeMenu extends StatelessWidget {
  final Widget? ikon, altbaslik, komponet, info;
  final Widget baslik;
  final Color color, selectedcolor;
  final bool aktif, tablo, divider;
  final VoidCallback? onpress, onlongpress;
  final double? ikonsize;
  const ListeMenu(
      {super.key,
      this.ikon,
      this.ikonsize = 70,
      this.info,
      required this.baslik,
      this.altbaslik,
      this.komponet,
      this.onpress,
      this.onlongpress,
      this.color = Colors.transparent,
      this.selectedcolor = Colors.transparent,
      this.aktif = true,
      this.tablo = false,
      this.divider = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onlongpress,
      child: Container(
        color: selectedcolor,
        child: Column(
          children: [
            CupertinoListTile(
              onTap: aktif ? onpress : () {},
              padding: const EdgeInsets.all(8),
              leadingSize: tablo ? ikonsize! : 30,
              leading: (ikon != null)
                  ? (tablo == false)
                      ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(child: ikon),
                        )
                      : ikon
                  : null,
              title: baslik,
              subtitle: altbaslik,
              trailing: komponet,
              additionalInfo: info,
            ),
            Divider(
              color: (divider)
                  ? const Color.fromARGB(99, 158, 158, 158)
                  : Colors
                      .transparent, // Ayırıcı rengini ve kalınlığını ayarlayabilirsiniz.
              height:
                  (divider) ? 1 : 0, // Ayırıcı yüksekliğini ayarlayabilirsiniz.
            ),
          ],
        ),
      ),
    );
  }
}
