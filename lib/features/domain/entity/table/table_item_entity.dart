import 'package:equatable/equatable.dart';

class TableItemEntity extends Equatable {
  final int? id;
  final String? adi;
  final int? kisiSayisi;
  final String? acanGarson;
  final String? masaDurumu;
  final bool? masaAcik;
  final double? miktar;
  final double? toplam;
  final String? sonUrun;
  final double? sureDk;
  final String? acilisZaman;
  final bool? adisyonYazildi;
  final String? grupadi;

  const TableItemEntity({
    this.id,
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
    this.grupadi,
  });

  @override
  List<Object?> get props => [
    id,
    adi,
    kisiSayisi,
    acanGarson,
    masaDurumu,
    masaAcik,
    miktar,
    toplam,
    sonUrun,
    sureDk,
    acilisZaman,
    adisyonYazildi,
    grupadi,
  ];
}
