import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget? title;
  final Icon? leading;
  final Function onTap;
  final EdgeInsets? padding;
  final Color? bgColor;
  final EdgeInsets? margin;
  final double? borderRadius;

  const CustomButton({
    super.key,
    this.title,
    this.leading,
    required this.onTap,
    this.padding,
    this.bgColor,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius != null ? borderRadius! : 50,
          ),
          color: bgColor ?? buttonColor,
        ),
        margin: margin ?? const EdgeInsets.symmetric(),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading == null ? const SizedBox.shrink() : leading!,
            title ?? title!,
          ],
        ),
      ),
    );
  }
}
