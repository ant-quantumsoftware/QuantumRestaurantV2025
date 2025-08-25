import 'package:flutter/material.dart';

import '../components/input2.dart';
import '../models/oneri_model.dart';

class LookUpEdit extends StatelessWidget {
  final String inittext, hinttext;
  final Function()? temizle;
  final Function(String value)? yenideger;
  final Function(OneriModel selection)? secilendeger;
  final bool yenidegergir, secimyap;
  final List<OneriModel> liste;

  const LookUpEdit({
    super.key,
    this.inittext = "",
    this.hinttext = "...",
    this.temizle,
    this.yenidegergir = true,
    this.secimyap = true,
    required this.liste,
    this.yenideger,
    this.secilendeger,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<OneriModel>(
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          textEditingController.text = inittext;
          return Input2(
            buyukharf: true,
            label: hinttext,
            auto: true,
            silbtn: temizle,
            texteditcontrol: textEditingController,
            focusnode: focusNode,
            textValue: yenideger,
          );
        },
        displayStringForOption: (OneriModel option) => option.value.toString(),
        optionsBuilder: (TextEditingValue textEditingValue) {
          return List<OneriModel>.generate(
                  liste.length, (index) => liste[index],
                  growable: true)
              .where(
            (OneriModel option) {
              return option.value
                  .toString()
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            },
          );
        },
        onSelected: secilendeger);
  }
}
