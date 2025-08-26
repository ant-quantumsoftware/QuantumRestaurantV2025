// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodItemModelAdapter extends TypeAdapter<FoodItemModel> {
  @override
  final int typeId = 0;

  @override
  FoodItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItemModel(
      id: fields[0] as int?,
      adi: fields[1] as String?,
      resim: fields[2] as String?,
      fiyats: fields[3] as String?,
      stok: fields[7] as double?,
      fiyatd: fields[6] as double?,
      count: fields[8] as int,
      birim: fields[4] as String?,
      kategori: fields[5] as String?,
      secenek1: fields[11] as String?,
      secenek2: fields[12] as String?,
      secenek3: fields[13] as String?,
      secenek4: fields[14] as String?,
      secenek5: fields[15] as String?,
      secenek6: fields[16] as String?,
    )
      ..isVeg = fields[9] as bool
      ..isSelected = fields[10] as bool;
  }

  @override
  void write(BinaryWriter writer, FoodItemModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adi)
      ..writeByte(2)
      ..write(obj.resim)
      ..writeByte(3)
      ..write(obj.fiyats)
      ..writeByte(4)
      ..write(obj.birim)
      ..writeByte(5)
      ..write(obj.kategori)
      ..writeByte(6)
      ..write(obj.fiyatd)
      ..writeByte(7)
      ..write(obj.stok)
      ..writeByte(8)
      ..write(obj.count)
      ..writeByte(9)
      ..write(obj.isVeg)
      ..writeByte(10)
      ..write(obj.isSelected)
      ..writeByte(11)
      ..write(obj.secenek1)
      ..writeByte(12)
      ..write(obj.secenek2)
      ..writeByte(13)
      ..write(obj.secenek3)
      ..writeByte(14)
      ..write(obj.secenek4)
      ..writeByte(15)
      ..write(obj.secenek5)
      ..writeByte(16)
      ..write(obj.secenek6);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
