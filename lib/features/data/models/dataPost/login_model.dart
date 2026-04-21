import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/login/restaurant_login_entity.dart';
import '../../dataSources/remote/http_services.dart';

final loginModelProvider = StateProvider<RestaurantLoginModel?>((ref) => null);

class RestaurantLoginModel extends RestaurantLoginEntity {
  const RestaurantLoginModel({
    super.kullaniciAdi,
    super.adiSoyadi,
    super.tokenExtDate,
    super.token,
    super.restaurantGarson,
    super.fastSellRestaurantAdisyonKapat,
    super.fastSellRestaurantAdisyonSil,
    super.fastSellRestaurantAdisyonYaz,
    super.fastSellRestaurantFiyat,
    super.fastSellRestaurantIkramIade,
    super.fastSellRestaurantYazilanMiktarDegisim,
    super.adminYetki,
  });

  factory RestaurantLoginModel.fromJson(Map<String, dynamic> json) {
    return RestaurantLoginModel(
      kullaniciAdi: (json['KullaniciAdi'] ?? '').toString(),
      adiSoyadi: (json['AdiSoyadi'] ?? '').toString(),
      tokenExtDate: DateTime.tryParse((json['TokenExtDate'] ?? '').toString()),
      token: (json['Token'] ?? '').toString(),
      restaurantGarson: json['RestaurantGarson'] == true,
      fastSellRestaurantAdisyonKapat:
          json['FastSellRestaurantAdisyonKapat'] == true,
      fastSellRestaurantAdisyonSil:
          json['FastSellRestaurantAdisyonSil'] == true,
      fastSellRestaurantAdisyonYaz:
          json['FastSellRestaurantAdisyonYaz'] == true,
      fastSellRestaurantFiyat: json['FastSellRestaurantFiyat'] == true,
      fastSellRestaurantIkramIade: json['FastSellRestaurantIkramIade'] == true,
      fastSellRestaurantYazilanMiktarDegisim:
          json['FastSellRestaurantYazilanMiktarDegisim'] == true,
      adminYetki: json['AdminYetki'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KullaniciAdi': kullaniciAdi,
      'AdiSoyadi': adiSoyadi,
      'TokenExtDate': tokenExtDate?.toIso8601String(),
      'Token': token,
      'RestaurantGarson': restaurantGarson,
      'FastSellRestaurantAdisyonKapat': fastSellRestaurantAdisyonKapat,
      'FastSellRestaurantAdisyonSil': fastSellRestaurantAdisyonSil,
      'FastSellRestaurantAdisyonYaz': fastSellRestaurantAdisyonYaz,
      'FastSellRestaurantFiyat': fastSellRestaurantFiyat,
      'FastSellRestaurantIkramIade': fastSellRestaurantIkramIade,
      'FastSellRestaurantYazilanMiktarDegisim':
          fastSellRestaurantYazilanMiktarDegisim,
      'AdminYetki': adminYetki,
    };
  }
}

class LoginModel {
  String? userName;
  String? parola;

  LoginModel({this.userName, this.parola});

  Future<String> getLoginToken() async {
    final loginResult = await getRestaurantLogin();

    return loginResult?.token ?? '';
  }

  Future<RestaurantLoginModel?> getRestaurantLogin() async {
    final sonuc = await HttpServices().LoginRestaurantMethod(
      userName!,
      parola!,
    );

    if (sonuc == '') {
      return null;
    }

    final body = jsonDecode(sonuc);

    if (body is Map<String, dynamic>) {
      return RestaurantLoginModel.fromJson(body);
    }

    // Backward compatibility: older endpoint may return token directly as string
    if (body is String) {
      return RestaurantLoginModel(token: body);
    }

    return null;
  }
}
