import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color? color;
  final Color? textColor;

  const BottomBar({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        color: color ?? Theme.of(context).primaryColor,
        height: 60.0,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}
