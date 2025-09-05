import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../data/models/dataGet/table_item_group.dart';
import '../../data/models/dataGet/table_item_model.dart';
import '../../data/repositories/table_repository_impl.dart';

final tableRepositoryProvider = Provider<TableRepository>((ref) {
  return TableRepositoryImpl();
});

abstract class TableRepository {
  Future<Result<List<TableItemModel>>> getTableItemAll();
  Future<Result<List<TableItemModel>>> getTableItemGarson(int garsonId);
  Future<Result<List<TableItemModel>>> getTableItemStatus(int tipx);
  Future<Result<List<TableItemGroup>>> getTableItemGroupAll();
}
