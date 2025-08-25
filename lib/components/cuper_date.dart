import 'package:flutter/material.dart';

class CuperDate extends StatelessWidget {
  const CuperDate({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            left: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            right: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
