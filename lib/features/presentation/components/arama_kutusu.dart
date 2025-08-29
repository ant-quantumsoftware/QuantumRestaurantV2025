import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String> fieldValue;
  final String infotxt;
  const SearchTextField(
      {super.key, required this.fieldValue, this.infotxt = "Arama yap..."});

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      style: TextStyle(color: Theme.of(context).hintColor),
      suffixIcon: const Icon(
        CupertinoIcons.clear_circled_solid,
        color: Color.fromARGB(255, 255, 0, 0),
        size: 18,
      ),
      placeholder: infotxt,
      onChanged: (String value) {
        fieldValue(value);
      },
      onSubmitted: (String value) {
        fieldValue(value);
      },
    );
  }
}
