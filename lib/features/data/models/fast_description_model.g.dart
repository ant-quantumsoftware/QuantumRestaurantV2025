// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast_description_model.dart';

// ***************************************************************************
// TypeAdapterGenerator
// ***************************************************************************

class FastDescriptionModelAdapter extends TypeAdapter<FastDescriptionModel> {
  @override
  final int typeId = 1;

  @override
  FastDescriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastDescriptionModel(
      id: fields[0] as int?,
      productId: fields[1] as int?,
      ingredientId: fields[2] as int?,
      ingredientName: fields[3] as String?,
      description: fields[4] as String? ?? '',
      localeCode: fields[5] as String?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FastDescriptionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.ingredientId)
      ..writeByte(3)
      ..write(obj.ingredientName)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.localeCode)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastDescriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
