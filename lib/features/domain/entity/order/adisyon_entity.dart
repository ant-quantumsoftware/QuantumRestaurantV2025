import 'package:equatable/equatable.dart';

class AdisyonEntity extends Equatable {
  final int? id;
  final String? adi;
  final double? fiyatd;
  final String? ozellik1;
  final String? ozellik2;
  final String? ozellik3;
  final int? kisisayisi;
  final int? malzemeid;
  final int? masaid;
  final double miktar;
  final List<String>? etraozellikler;
  final bool isVeg;
  final String? secenek;

  const AdisyonEntity({
    this.id,
    this.adi,
    this.fiyatd,
    this.ozellik1,
    this.ozellik2,
    this.ozellik3,
    this.kisisayisi,
    this.malzemeid,
    this.masaid,
    this.etraozellikler,
    this.isVeg = false,
    this.secenek,
    this.miktar = 0,
  });

  @override
  List<Object?> get props => [
    id,
    adi,
    fiyatd,
    miktar,
    ozellik1,
    ozellik2,
    ozellik3,
    kisisayisi,
    malzemeid,
    masaid,
    miktar,
    etraozellikler,
    isVeg,
    secenek,
  ];
}
