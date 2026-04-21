import 'package:equatable/equatable.dart';

class RestaurantLoginEntity extends Equatable {
  final String kullaniciAdi;
  final String adiSoyadi;
  final DateTime? tokenExtDate;
  final String token;
  final bool restaurantGarson;
  final bool fastSellRestaurantAdisyonKapat;
  final bool fastSellRestaurantAdisyonSil;
  final bool fastSellRestaurantAdisyonYaz;
  final bool fastSellRestaurantFiyat;
  final bool fastSellRestaurantIkramIade;
  final bool fastSellRestaurantYazilanMiktarDegisim;
  final bool adminYetki;

  const RestaurantLoginEntity({
    this.kullaniciAdi = '',
    this.adiSoyadi = '',
    this.tokenExtDate,
    this.token = '',
    this.restaurantGarson = false,
    this.fastSellRestaurantAdisyonKapat = false,
    this.fastSellRestaurantAdisyonSil = false,
    this.fastSellRestaurantAdisyonYaz = false,
    this.fastSellRestaurantFiyat = false,
    this.fastSellRestaurantIkramIade = false,
    this.fastSellRestaurantYazilanMiktarDegisim = false,
    this.adminYetki = false,
  });

  @override
  List<Object?> get props => [
    kullaniciAdi,
    adiSoyadi,
    tokenExtDate,
    token,
    restaurantGarson,
    fastSellRestaurantAdisyonKapat,
    fastSellRestaurantAdisyonSil,
    fastSellRestaurantAdisyonYaz,
    fastSellRestaurantFiyat,
    fastSellRestaurantIkramIade,
    fastSellRestaurantYazilanMiktarDegisim,
    adminYetki,
  ];
}
