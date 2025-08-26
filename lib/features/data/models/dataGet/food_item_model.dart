import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import '../../dataSources/remote/http_services.dart';

part 'food_item_model.g.dart';

@HiveType(typeId: 0)
class FoodItemModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? adi;

  @HiveField(2)
  String? resim;

  @HiveField(3)
  String? fiyats;

  @HiveField(4)
  String? birim;

  @HiveField(5)
  String? kategori;

  @HiveField(6)
  double? fiyatd;

  @HiveField(7)
  double? stok;

  @HiveField(8)
  int count = 0;

  @HiveField(9)
  bool isVeg = false;

  @HiveField(10)
  bool isSelected = false;

  @HiveField(11)
  String? secenek1;

  @HiveField(12)
  String? secenek2;

  @HiveField(13)
  String? secenek3;

  @HiveField(14)
  String? secenek4;

  @HiveField(15)
  String? secenek5;

  @HiveField(16)
  String? secenek6;

  FoodItemModel({
    this.id,
    this.adi,
    this.resim,
    this.fiyats,
    this.stok,
    this.fiyatd,
    this.count = 0,
    this.birim,
    this.kategori,
    this.secenek1,
    this.secenek2,
    this.secenek3,
    this.secenek4,
    this.secenek5,
    this.secenek6,
  });

  FoodItemModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    resim = json['Kategori'] == "" ? json['Resim'] : "assets/resimnull.png";
    fiyats = json['Fiyat1Dahil'].toString();
    fiyatd = json['Fiyat1Dahil'];
    stok = json['Stok'];
    birim = json['Birim'];
    kategori = json['Kategori'];
    secenek1 = json['Secenek1'] ?? '';
    secenek2 = json['Secenek2'] ?? '';
    secenek3 = json['Secenek3'] ?? '';
    secenek4 = json['Secenek4'] ?? '';
    secenek5 = json['Secenek5'] ?? '';
    secenek6 = json['Secenek6'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Adi'] = adi;
    data['Kategori'] = resim;
    data['Fiyat1Dahil'] = fiyatd;
    data['Stok'] = stok;
    data['Birim'] = birim;
    data['Kategori'] = kategori;
    data['Secenek1'] = secenek1;
    data['Secenek2'] = secenek2;
    data['Secenek3'] = secenek3;
    data['Secenek4'] = secenek4;
    data['Secenek5'] = secenek5;
    data['Secenek6'] = secenek6;
    return data;
  }
}

Future<List<FoodItemModel>> getFoodItemAll() async {
  var sonuc = await HttpServices().getMethod("ItemsV1/get");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => FoodItemModel.fromJson(e)).toList();
}

Future<List<FoodItemModel>> getFoodItemCategories(String kategoriKodu) async {
  var sonuc = await HttpServices().getMethod(
    "ItemsV1/GetCategories?KategoriKodu=$kategoriKodu",
  );
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => FoodItemModel.fromJson(e)).toList();
}

Future<List<FoodItemModel>> getFoodItemGetirId(int tipx) async {
  var sonuc = await HttpServices().getMethod("ItemsV1/get/$tipx");
  var body = jsonDecode(sonuc) as List;
  return body.map((e) => FoodItemModel.fromJson(e)).toList();
}
