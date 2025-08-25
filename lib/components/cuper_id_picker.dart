import 'package:flutter/cupertino.dart';

import '../config/config.dart';

class IdVeriSecici extends StatelessWidget {
  final Function? degistir;
  final List<dynamic> liste;
  final List<String> names;
  final dynamic ideleman, nameeleman;
  final int index;
  final bool sigdir;

  const IdVeriSecici(
      {super.key,
      this.degistir,
      this.sigdir = false,
      required this.liste,
      required this.names,
      required this.index,
      this.ideleman,
      this.nameeleman});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 10),
      onPressed: () => Config.showDialogCoportion(
        context,
        CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: index),
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32,
          onSelectedItemChanged: (selectedItem) {
            degistir!(
              selectedItem,
            );
          },
          children: List<Widget>.generate(liste.length, (int index) {
            return Center(
              child: Text(
                names[index].toString(),
              ),
            );
          }),
        ),
      ),
      child: (sigdir)
          ? FittedBox(
              fit: BoxFit.fill,
              child: Text(
                names[index].toString(),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            )
          : Text(
              names[index].toString(),
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
    );
  }
}
