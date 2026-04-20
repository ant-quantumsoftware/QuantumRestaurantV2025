import 'package:hive/hive.dart';

import '../../domain/entity/fast_description_entity.dart';

part 'fast_description_model.g.dart';

@HiveType(typeId: 1)
class FastDescriptionModel extends HiveObject {
  static const String boxName = 'fast_descriptions';
  static const String _noProductKey = 'no-product';
  static const String _noIngredientKey = 'no-ingredient';

  @HiveField(0)
  int? id;

  @HiveField(1)
  int? productId;

  @HiveField(2)
  int? ingredientId;

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
    this.productId,
    this.ingredientId,
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
    id: id,
    productId: productId,
    ingredientId: ingredientId,
    localeCode: localeCode,
  );

  static String buildStorageKey({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) {
    final normalizedLocale = localeCode?.trim();
    final localePart = (normalizedLocale == null || normalizedLocale.isEmpty)
        ? 'default'
        : normalizedLocale;

    if (productId == null && ingredientId == null) {
      final recordId = id ?? DateTime.now().microsecondsSinceEpoch;
      return '$_noProductKey:$_noIngredientKey:$localePart:$recordId';
    }

    return '${productId ?? _noProductKey}:${ingredientId ?? _noIngredientKey}:$localePart';
  }
}
