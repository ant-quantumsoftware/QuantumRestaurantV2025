import 'dart:convert';

import '../config/http_services.dart';

class CardItemModel {
  int? id;
  String? adi;
  String? fiyats;
  double? fiyatd;
  String? ozellik1;
  String? ozellik2;
  String? ozellik3;
  String? secenek;
  double? genel;
  late double miktar = 0;
  List<String>? extraozellikler;
  bool isVeg = false;

  // Sipariş Girilen ürünler

  CardItemModel(
      {this.id,
      this.adi,
      this.fiyats,
      this.extraozellikler,
      this.fiyatd,
      this.ozellik1,
      this.ozellik2,
      this.ozellik3,
      this.miktar = 0,
      this.secenek});

  CardItemModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    fiyatd = json['Fiyat'];
    fiyats = json['Fiyat'].toString();
    miktar = json['Miktar'];
    ozellik1 = json['Ozellik1'];
    ozellik2 = json['Ozellik2'];
    ozellik3 = json['Ozellik3'];
    secenek = json['Secenek'];
    genel = (fiyatd! * miktar);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Adi'] = adi;
    data['Fiyat'] = fiyatd;
    data['Miktar'] = miktar;
    data['Ozellik1'] = ozellik1;
    data['Ozellik2'] = ozellik2;
    data['Ozellik3'] = ozellik3;
    data['Secenek'] = secenek;

    return data;
  }
}

Future<List<CardItemModel>> getCardItemAll() async {
  var sonuc = await HttpServices().getMethod("RestOrderV1/get");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => CardItemModel.fromJson(e)).toList();
}

Future<List<CardItemModel>> getCardItemGetirId(int tipx) async {
  var sonuc = await HttpServices().getMethod("RestOrderV1/get/$tipx");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => CardItemModel.fromJson(e)).toList();
}
