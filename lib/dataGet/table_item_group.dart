import 'dart:convert';

import '../config/http_services.dart';

class TableItemGroup {
  String? grupAdi;

  TableItemGroup({
    this.grupAdi,
  });

  TableItemGroup.fromJson(Map<String, dynamic> json) {
    grupAdi = json['GrupAdi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['GrupAdi'] = grupAdi;

    return data;
  }
}

Future<List<TableItemGroup>> getTableGroupAll() async {
  var sonuc = await HttpServices().getMethod("RestTablesV1/GetMasaGruplari");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => TableItemGroup.fromJson(e)).toList();
}
