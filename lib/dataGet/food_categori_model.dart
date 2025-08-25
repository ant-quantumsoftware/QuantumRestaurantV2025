import 'dart:convert';

import '../config/http_services.dart';

class FoodCategoriModel {
  int? id;
  String? adi;
  String? kodu;
  bool? selected;

  FoodCategoriModel({this.id, this.adi, this.kodu, this.selected});

  FoodCategoriModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    kodu = json['Kodu'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Adi'] = adi;
    data['Kodu'] = kodu;

    return data;
  }
}

Future<List<FoodCategoriModel>> getFoodCategoriAll() async {
  var sonuc = await HttpServices().getMethod("ItemsCategoriV1/get");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => FoodCategoriModel.fromJson(e)).toList();
}

Future<List<FoodCategoriModel>> getFoodCategoriGetirId(int tipx) async {
  var sonuc = await HttpServices().getMethod("ItemsCategoriV1/get/$tipx");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => FoodCategoriModel.fromJson(e)).toList();
}
