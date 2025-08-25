import 'package:intl/intl.dart';

class Utils {
  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  static var format = NumberFormat("#,##0.00", "tr");

  static var formatdatetime = DateFormat('dd.MM.yyyy');
}
