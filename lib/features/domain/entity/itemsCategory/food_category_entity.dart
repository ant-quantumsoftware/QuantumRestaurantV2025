import 'package:equatable/equatable.dart';

class FoodCategoryEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final bool? isSelected;

  const FoodCategoryEntity({this.id, this.name, this.code, this.isSelected});

  @override
  List<Object?> get props => [id, name, code, isSelected];
}
