
import 'package:flutter/material.dart';

class XFlatButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double height;
  final IconData? iconData;
  final Color bgColor;
  final Color iconColor;
  final TextStyle textStyle;

  const XFlatButton(
      {required this.text,
      this.onPressed,
      this.width = 200,
      this.height = 40,
      super.key,
      this.iconData,
      this.bgColor = Colors.blue,
      this.iconColor = Colors.white,
      this.textStyle = const TextStyle(color: Colors.white)});
  @override
  Widget build(BuildContext context) {
    final flatButtonStyle = TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        //backgroundColor: bgColor,
        backgroundColor: onPressed == null
            ? Theme.of(context).colorScheme.primaryContainer
            : bgColor);
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
          onPressed: onPressed,
          style: flatButtonStyle,
          //child: Text(text),
          child: iconData == null
              ? Text(
                  text,
                  style: textStyle,
                )
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    iconData,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                    style: textStyle,
                  ),
                ])),
    );
  }
}
