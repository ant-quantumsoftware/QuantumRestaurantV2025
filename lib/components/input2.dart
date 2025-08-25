import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Input2 extends StatelessWidget {
  final String label, errorText, inputValue;
  final Function? textValue, textval, complete;
  final Function()? silbtn;
  final bool passwordstatus, readyval, auto, buyukharf, basbuyukharf;
  final int? maxline, maxuzunluk;
  final TextInputType inputype;
  final TextInputAction nextType;
  final Color? bgcolors, textcolor;
  final TextEditingController? texteditcontrol;
  final Widget? sagwigdet;
  final Widget? solwidget;
  final double textsize;
  final FocusNode? focusnode;

  const Input2({
    super.key,
    this.sagwigdet,
    this.solwidget,
    this.textcolor,
    this.textsize = 17,
    this.bgcolors = Colors.grey,
    this.nextType = TextInputAction.next,
    this.texteditcontrol,
    this.passwordstatus = false,
    this.readyval = false,
    this.auto = false,
    this.buyukharf = false,
    this.basbuyukharf = false,
    this.maxline,
    this.maxuzunluk,
    this.inputype = TextInputType.multiline,
    this.label = "",
    this.textval,
    this.complete,
    this.inputValue = "",
    this.errorText = "",
    this.textValue,
    this.silbtn,
    this.focusnode,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      
      maxLength: maxuzunluk,
      style: TextStyle(
        fontSize: textsize,
        color: (inputype == TextInputType.phone)
            ? Colors.blue
            : (inputype == TextInputType.emailAddress)
                ? Colors.green
                : textcolor ?? Theme.of(context).hintColor,
      ),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: inputype,
      controller: texteditcontrol ?? TextEditingController(text: inputValue),
      obscureText: passwordstatus,
      textInputAction: nextType,
      textCapitalization: buyukharf
          ? TextCapitalization.characters
          : basbuyukharf
              ? TextCapitalization.words
              : TextCapitalization.sentences,
      placeholder: label,
      placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey.shade700),
      readOnly: readyval,
      focusNode: focusnode,
      maxLines: maxline,
      suffixMode: OverlayVisibilityMode.editing,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border(
          top: BorderSide(
            color: bgcolors!,
            width: 1.0,
          ),
          bottom: BorderSide(
            color: bgcolors!,
            width: 1.0,
          ),
          left: BorderSide(
            color: bgcolors!,
            width: 1.0,
          ),
          right: BorderSide(
            color: bgcolors!,
            width: 1.0,
          ),
        ),
      ),
      prefix: solwidget,
      suffix: (inputype == TextInputType.phone)
          ? CupertinoButton(
              child: const Icon(
                CupertinoIcons.phone,
                size: 16,
              ),
              onPressed: () {
                if (inputValue != '' && inputValue.length > 10) {
                  launchUrl(
                    Uri.parse("tel://$inputValue"),
                  );
                }
              },
            )
          : (inputype == TextInputType.emailAddress)
              ? CupertinoButton(
                  child: const Icon(
                    CupertinoIcons.mail,
                    size: 16,
                  ),
                  onPressed: () {
                    if (inputValue != '' && inputValue.length > 10) {
                      launchUrl(
                        Uri.parse("mailto:$inputValue"),
                      );
                    }
                  },
                )
              : (inputype == TextInputType.url)
                  ? CupertinoButton(
                      child: const Icon(
                        CupertinoIcons.globe,
                        size: 16,
                      ),
                      onPressed: () {
                        if (inputValue != '' && inputValue.length > 10) {
                          launchUrl(
                            Uri.parse("http:$inputValue"),
                          );
                        }
                      },
                    )
                  : (auto)
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: (() {
                            silbtn!();
                          }),
                          child: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: Color.fromARGB(255, 226, 113, 105),
                            size: 16,
                          ),
                        )
                      : sagwigdet,
      onEditingComplete: () {
        complete!();
      },
      onChanged: (text) {
        textValue!(text);
      },
    );
  }
}
