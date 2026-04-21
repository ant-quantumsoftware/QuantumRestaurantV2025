import 'dart:convert';

import '../../dataSources/remote/http_services.dart';

class CardItemModel {
  int? id;
  String? adi;
  int? malzemeId;
  int? masaId;
  int? kisiSayisi;
  double? fiyatd;
  String? ozellikAciklama;
  String? ozellikAciklama2;
  String? ozellikAciklama3;
  String? secenek;
  double? genel;
  late double miktar = 0;
  List<String>? extraozellikler;
  bool isVeg = false;
  String? aciklama;

  // Sipariş Girilen ürünler

  CardItemModel({
    this.id,
    this.adi,
    this.extraozellikler,
    this.fiyatd,
    this.ozellikAciklama,
    this.ozellikAciklama2,
    this.ozellikAciklama3,
    this.miktar = 0,
    this.secenek,
    this.genel,
    this.malzemeId,
    this.masaId,
    this.kisiSayisi,
    this.aciklama,
  });

  CardItemModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    fiyatd = json['Fiyat'];
    miktar = json['Miktar'];
    ozellikAciklama = json['OzellikAciklama1'];
    ozellikAciklama2 = json['OzellikAciklama2'];
    ozellikAciklama3 = json['OzellikAciklama3'];
    secenek = json['Secenek'];
    extraozellikler = List<String>.from(json['EtraOzellikler'] ?? []);
    malzemeId = json['MalzemeId'];
    masaId = json['MasaId'];
    kisiSayisi = json['KisiSayisi'];
    genel = (fiyatd! * miktar);
    aciklama = json['Aciklama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Adi'] = adi;
    data['Fiyat'] = fiyatd;
    data['Miktar'] = miktar;
    data['OzellikAciklama1'] = ozellikAciklama;
    data['OzellikAciklama2'] = ozellikAciklama2;
    data['OzellikAciklama3'] = ozellikAciklama3;
    data['Secenek'] = secenek;
    data['EtraOzellikler'] = extraozellikler;
    data['MalzemeId'] = malzemeId;
    data['MasaId'] = masaId;
    data['KisiSayisi'] = kisiSayisi;
    data['Aciklama'] = aciklama;
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
