import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/config.dart';
import 'liste_menu.dart';

class GeriButton extends StatelessWidget {
  const GeriButton({super.key});

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items:
          Config.backlist.map((String item) {
            return PopupMenuItem(
              value: Config.backlist.indexOf(item),
              child: Column(
                children: [
                  ListeMenu(
                    ikon: const Icon(
                      CupertinoIcons.back,
                      color: Color.fromARGB(55, 1, 161, 230),
                      size: 18,
                    ),
                    baslik: Text(
                      item,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                ],
              ),
              onTap: () {
                final int selectedIndex = Config.backlist.indexOf(item);
                final int index = Config.backlist.length - selectedIndex;
                int currentPage = 0;

                if (selectedIndex == 0) {
                  Config.backlist.clear();
                } else {
                  Config.backlist.removeRange(
                    selectedIndex,
                    Config.backlist.length,
                  );
                }

                Navigator.popUntil(context, (route) {
                  // Kontrol, belirtilen sayıda geri dönüş yapıldığında veya başlangıç noktasına ulaşıldığında durur.
                  bool shouldPop = currentPage == index || route.isFirst;
                  if (!shouldPop) currentPage++;
                  return shouldPop;
                });
              },
            );
          }).toList(),
      elevation: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        _showPopupMenu(context);
      },
      child: CupertinoButton(
        minimumSize: const Size(20, 20),
        child: const Icon(CupertinoIcons.back, color: Colors.blue, size: 28),
        onPressed: () {
          if (Config.backlist.isNotEmpty) {
            Config.backlist.removeLast();
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
