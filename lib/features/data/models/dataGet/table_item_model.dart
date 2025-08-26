import 'dart:convert';

import '../../dataSources/remote/http_services.dart';

class TableItemModel {
  int? id;
  String? adi;
  int? kisiSayisi;
  String? acanGarson;
  String? masaDurumu;
  bool? masaAcik;
  double? miktar;
  double? toplam;
  String? sonUrun;
  double? sureDk;
  String? acilisZaman;
  bool? adisyonYazildi;
  String? grupadi;

  TableItemModel(
      {this.id,
      this.adi,
      this.kisiSayisi,
      this.acanGarson,
      this.masaDurumu,
      this.masaAcik,
      this.miktar,
      this.toplam,
      this.sonUrun,
      this.sureDk,
      this.acilisZaman,
      this.adisyonYazildi,
      this.grupadi});

  TableItemModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    kisiSayisi = json['KisiSayisi'];
    acanGarson = json['AcanGarson'] ?? 'Garson';
    masaDurumu = json['MasaDurumu'];
    masaAcik = json['MasaAcik'] ?? false;
    miktar = json['Miktar'];
    toplam = json['Toplam'];
    sonUrun = json['SonUrun'];
    sureDk = json['SureDk'];
    acilisZaman = json['AcilisZaman'];
    adisyonYazildi = json['AdisyonYazildi'];
    grupadi = json['GrupAdi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Adi'] = adi;
    data['KisiSayisi'] = kisiSayisi;
    data['AcanGarson'] = acanGarson;
    data['MasaDurumu'] = masaDurumu;
    data['MasaAcik'] = masaAcik;
    data['Miktar'] = miktar;
    data['Toplam'] = toplam;
    data['SonUrun'] = sonUrun;
    data['SureDk'] = sureDk;
    data['AcilisZaman'] = acilisZaman;
    data['AdisyonYazildi'] = adisyonYazildi;
    data['GrupAdi'] = grupadi;

    return data;
  }
}

Future<List<TableItemModel>> getTableItemAll() async {
  var sonuc = await HttpServices().getMethod("RestTablesV1/get");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => TableItemModel.fromJson(e)).toList();
}

Future<List<TableItemModel>> getTableItemGarson(int garsonId) async {
  var sonuc = await HttpServices()
      .getMethod("RestTablesV1/GetGarson?GarsonId=$garsonId");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => TableItemModel.fromJson(e)).toList();
}

// 0 Kapalı Masalar
// 1 Açık Masalar
// 2 Tüm Masalar

Future<List<TableItemModel>> getTableItemStatus(int tipx) async {
  var sonuc =
      await HttpServices().getMethod("RestTablesV1/GetStatus?Status=$tipx");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => TableItemModel.fromJson(e)).toList();
}
