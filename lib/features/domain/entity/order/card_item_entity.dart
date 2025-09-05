import 'package:equatable/equatable.dart';

class CardItemEntity extends Equatable {
  final int? id;
  final String? adi;
  final String? fiyats;
  final double? fiyatd;
  final String? ozellik1;
  final String? ozellik2;
  final String? ozellik3;
  final String? secenek;
  final double? genel;
  final double miktar;
  final List<String>? extraozellikler;
  final bool isVeg;

  const CardItemEntity({
    this.id,
    this.adi,
    this.fiyats,
    this.fiyatd,
    this.ozellik1,
    this.ozellik2,
    this.ozellik3,
    this.secenek,
    this.genel,
    this.miktar = 0,
    this.extraozellikler,
    this.isVeg = false,
  });

  @override
  List<Object?> get props => [
    id,
    adi,
    fiyats,
    fiyatd,
    ozellik1,
    ozellik2,
    ozellik3,
    secenek,
    genel,
    miktar,
    extraozellikler,
    isVeg,
  ];
}
