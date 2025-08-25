
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrefixWidget extends StatelessWidget {
  const PrefixWidget(
      {super.key,
      this.title = "",
      this.color = Colors.transparent,
      this.icon,
      this.iconsize = 10,
      this.fontsize = 14});

  final IconData? icon;
  final String title;
  final Color color;
  final double iconsize, fontsize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: (icon != null)
              ? Icon(
                  icon,
                  color: CupertinoColors.white,
                  size: iconsize,
                )
              : const SizedBox(width: 0),
        ),
        const SizedBox(width: 5),
        (title != "")
            ? Text(
                title,
              )
            : const SizedBox(width: 0),
      ],
    );
  }
}
