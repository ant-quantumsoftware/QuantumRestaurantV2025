import 'dart:convert';

import '../config/http_services.dart';


class AdisyonModel {
  int? id;
  String? adi;

  double? fiyatd;
  String? ozellik1;
  String? ozellik2;
  String? ozellik3;
  int? kisisayisi;
  int? malzemeid;
  int? masaid;

  late double miktar = 0;
  List<String>? etraozellikler;
  bool isVeg = false;
  String? secenek;

  // Sipariş Girilen ürünler

  AdisyonModel({
    this.id,
    this.adi,
    this.etraozellikler,
    this.fiyatd,
    this.ozellik1,
    this.ozellik2,
    this.ozellik3,
    this.kisisayisi,
    this.miktar = 0,
    this.malzemeid,
    this.masaid,
    this.secenek,
  });

  AdisyonModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    fiyatd = json['Fiyat'];
    miktar = json['Miktar'];
    ozellik1 = json['Ozellik1'];
    ozellik2 = json['Ozellik2'];
    ozellik3 = json['Ozellik3'];
    kisisayisi = json['KisiSayisi'];
    malzemeid = json['MalzemeId'];
    masaid = json['MasaId'];
    secenek = json['Secenek'];
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
    data['KisiSayisi'] = kisisayisi;
    data['MalzemeId'] = malzemeid;
    data['MasaId'] = masaid;
    data['Secenek'] = secenek;

    return data;
  }
}

Future<bool> sendSiparisAdisyon(AdisyonModel siparis) async {
  var sonuc = await HttpServices().PostMethod(
    "RestOrderV1/post",
    jsonEncode(siparis),
  );

  return sonuc;
}

Future<bool> sendSiparisAciklama(AdisyonModel siparis) async {
  var sonuc = await HttpServices().PostMethod(
    "RestOrderV1/postdetails",
    jsonEncode(siparis),
  );

  return sonuc;
}

Future<bool> deleteSiparisAdisyon(int id) async {
  String ids = id.toString();

  var sonuc = await HttpServices().DeleteMethod("RestOrderV1/delete/$ids");

  return sonuc;
}

Future<bool> printSiparisAdisyon(int id) async {
  String ids = id.toString();

  var sonuc = await HttpServices().DeleteMethod("RestOrderV1/deleteprint/$ids");

  return sonuc;
}

Future<bool> printSiparisMutfak(int id) async {
  String ids = id.toString();

  var sonuc = await HttpServices().DeleteMethod(
    "RestOrderV1/deleteprintall/$ids",
  );

  return sonuc;
}

Future<bool> replaceSiparisAdisyon(int id, int yeniId) async {
  String ids = id.toString();
  String yeniids = yeniId.toString();

  var data = json.encode({"Id": ids, "YeniId": yeniids});

  var sonuc = await HttpServices().PostMethod(
    "RestOrderV1/PostReplaceMasa",
    data,
  );

  return sonuc;
}
