import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';

class SpinEdit extends StatelessWidget {
  final double max, min, step, value;
  final int decimals;
  final String birim;
  final Function? onChanged;
  final Function? canChanged;
  final bool buttonac;

  const SpinEdit(
      {super.key,
      required this.max,
      this.min = 0,
      this.step = 1,
      this.value = 0,
      this.decimals = 0,
      this.birim = "",
      this.onChanged,
      this.canChanged,
      this.buttonac = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: CupertinoSpinBox(
            showButtons: buttonac,
            onChanged: (value) {
              onChanged!(value);
            },
            canChange: (value) {
              canChanged!(value);
              return true;
            },
            min: min,
            max: max,
            step: step,
            value: value < min ? min : value,
            decimals: decimals,
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor),
          ),
        ),
        birim != ""
            ? Expanded(
                flex: 1,
                child: Text(
                  birim,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 176, 128, 128),
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ))
            : const SizedBox(
                width: 0,
              ),
      ],
    );
  }
}
