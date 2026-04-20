import 'package:hive/hive.dart';

import '../../domain/entity/fast_description_entity.dart';

part 'fast_description_model.g.dart';

@HiveType(typeId: 1)
class FastDescriptionModel extends HiveObject {
  static const String boxName = 'fast_descriptions';

  @HiveField(0)
  int? id;

  @HiveField(1)
  int productId;

  @HiveField(2)
  int ingredientId;

  @HiveField(3)
  String? ingredientName;

  @HiveField(4)
  String description;

  @HiveField(5)
  String? localeCode;

  @HiveField(6)
  DateTime? updatedAt;

  FastDescriptionModel({
    this.id,
    required this.productId,
    required this.ingredientId,
    this.ingredientName,
    this.description = '',
    this.localeCode,
    this.updatedAt,
  });

  factory FastDescriptionModel.fromEntity(FastDescriptionEntity entity) {
    return FastDescriptionModel(
      id: entity.id,
      productId: entity.productId,
      ingredientId: entity.ingredientId,
      ingredientName: entity.ingredientName,
      description: entity.description,
      localeCode: entity.localeCode,
      updatedAt: entity.updatedAt,
    );
  }

  FastDescriptionEntity toEntity() {
    return FastDescriptionEntity(
      id: id,
      productId: productId,
      ingredientId: ingredientId,
      ingredientName: ingredientName,
      description: description,
      localeCode: localeCode,
      updatedAt: updatedAt,
    );
  }

  String get storageKey => buildStorageKey(
    productId: productId,
    ingredientId: ingredientId,
    localeCode: localeCode,
  );

  static String buildStorageKey({
    required int productId,
    required int ingredientId,
    String? localeCode,
  }) {
    final normalizedLocale = localeCode?.trim();
    return '$productId:$ingredientId:${(normalizedLocale == null || normalizedLocale.isEmpty) ? 'default' : normalizedLocale}';
  }
}
