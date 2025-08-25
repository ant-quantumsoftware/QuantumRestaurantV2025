import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Segmenter extends StatelessWidget {
  final Function? secim;
  final List<String> liste;
  final int index;

  const Segmenter({
    super.key,
    this.secim,
    required this.liste,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      backgroundColor: Colors.grey.shade400,
      thumbColor: const Color.fromARGB(255, 0, 115, 223),
      groupValue: index,
      onValueChanged: (value) {
        secim!(value);
      },
      children: {
        for (int i = 0; i < liste.length; i++)
          i: Text(
            liste[i],
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
      },
    );
  }
}
