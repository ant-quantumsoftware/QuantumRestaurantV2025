import 'package:equatable/equatable.dart';

class FastDescriptionEntity extends Equatable {
  final int? id;
  final int? productId;
  final int? ingredientId;
  final String? ingredientName;
  final String description;
  final String? localeCode;
  final DateTime? updatedAt;

  const FastDescriptionEntity({
    this.id,
    this.productId,
    this.ingredientId,
    this.ingredientName,
    this.description = '',
    this.localeCode,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    ingredientId,
    ingredientName,
    description,
    localeCode,
    updatedAt,
  ];
}
