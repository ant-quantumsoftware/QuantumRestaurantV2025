import 'package:flutter/material.dart';

import '../components/input2.dart';

class LookUpEdit2<T extends Object> extends StatelessWidget {
  final List<T> liste;
  final dynamic value;
  final Function(dynamic)? onItemSelected;
  final Function(dynamic)? onItemEntered;
  final Function() clear;
  final String filterKey;
  final String displayKey;
  final String label;
  final Map<String, dynamic> Function(T) toJson;

  const LookUpEdit2({
    super.key,
    required this.liste,
    required this.value,
    required this.clear,
    this.onItemSelected,
    this.onItemEntered,
    required this.filterKey,
    required this.displayKey,
    required this.label,
    required this.toJson,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = filterKey != displayKey
                ? fieldBuilder(
                    liste.map((e) => toJson(e)).toList(),
                    value,
                    filterKey,
                    displayKey,
                  )
                : value;
            return Input2(
              buyukharf: true,
              label: label,
              auto: true,
              silbtn: () {
                clear();
              },
              texteditcontrol: textEditingController,
              focusnode: focusNode,
              textValue: onItemEntered,
            );
          },
      displayStringForOption: (T option) {
        var json = toJson(option);
        return json[displayKey].toString();
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        return liste.where((T option) {
          var json = toJson(option);
          return json[displayKey].toString().toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        }).toList();
      },
      onSelected: (T selection) {
        var json = toJson(selection);
        onItemSelected!(json[filterKey]);
      },
    );
  }

  String fieldBuilder(
    List<Map<String, dynamic>> liste,
    dynamic filterValue,
    String filterKey,
    String targetField,
  ) {
    List<Map<String, dynamic>> sonuc = liste.where((item) {
      return item[filterKey] == filterValue;
    }).toList();

    if (sonuc.isNotEmpty) {
      return sonuc[0][targetField].toString();
    } else {
      return "";
    }
  }
}
