import 'package:flutter/cupertino.dart';

import '../config/config.dart';

class VeriSecici extends StatelessWidget {
  final Function? degistir;
  final List<dynamic> liste;
  final int index;
  final bool sigdir;
  final double? fontsize;

  const VeriSecici({
    super.key,
    this.degistir,
    this.fontsize = 18.0,
    this.sigdir = false,
    required this.liste,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    int sonindex = liste.length - 1 < index ? 0 : index;
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 10),
      onPressed: () => Config.showDialogCoportion(
        context,
        CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: sonindex),
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32,
          onSelectedItemChanged: (int selectedItem) {
            degistir!(selectedItem);
          },
          children: List<Widget>.generate(liste.length, (int sonindex) {
            return Center(child: Text(liste[sonindex]));
          }),
        ),
      ),
      child: (sigdir)
          ? FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                liste[sonindex],
                style: TextStyle(fontSize: fontsize),
              ),
            )
          : Text(liste[sonindex], style: TextStyle(fontSize: fontsize)),
    );
  }
}
