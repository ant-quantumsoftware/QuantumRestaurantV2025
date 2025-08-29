import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Groupbox extends StatelessWidget {
  final String? baslik;
  final double? altpad, ustpad;
  final List<Widget> children;
  const Groupbox(
      {super.key,
      this.altpad = 15,
      this.ustpad = 15,
      this.baslik = "",
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: CupertinoFormSection(
              backgroundColor: Colors.transparent,
              header: Text(
                baslik!,
              ),
              margin: EdgeInsets.only(
                  right: 10, left: 10, bottom: altpad!, top: ustpad!),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: const Color.fromARGB(58, 158, 158, 158),
                  width: 2.5,
                ),
              ),
              children: children),
        ),
      ],
    );
  }
}
