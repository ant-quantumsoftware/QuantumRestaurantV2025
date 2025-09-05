import 'package:equatable/equatable.dart';

class FoodItemEntity extends Equatable {
  final int? id;
  final String? adi;
  final String? resim;
  final String? fiyats;
  final String? birim;
  final String? kategori;
  final double? fiyatd;
  final double? stok;
  final int count;
  final bool isVeg;
  final bool isSelected;
  final String? secenek1;
  final String? secenek2;
  final String? secenek3;
  final String? secenek4;
  final String? secenek5;
  final String? secenek6;

  const FoodItemEntity({
    this.id,
    this.adi,
    this.resim,
    this.fiyats,
    this.birim,
    this.kategori,
    this.fiyatd,
    this.stok,
    this.count = 0,
    this.isVeg = false,
    this.isSelected = false,
    this.secenek1,
    this.secenek2,
    this.secenek3,
    this.secenek4,
    this.secenek5,
    this.secenek6,
  });

  @override
  List<Object?> get props => [
    id,
    adi,
    resim,
    fiyats,
    birim,
    kategori,
    fiyatd,
    stok,
    count,
    isVeg,
    isSelected,
    secenek1,
    secenek2,
    secenek3,
    secenek4,
    secenek5,
    secenek6,
  ];
}
