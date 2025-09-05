import 'package:equatable/equatable.dart';

class TableItemGroupEntity extends Equatable {
  final String? grupAdi;

  const TableItemGroupEntity({this.grupAdi});

  @override
  List<Object?> get props => [grupAdi];
}
