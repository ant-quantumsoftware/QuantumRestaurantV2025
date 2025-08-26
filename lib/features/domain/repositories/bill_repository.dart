import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dataSources/local/hive_database_service.dart';
import '../../data/models/dataGet/food_item_model.dart';
import '../../data/repositories/bill_repository_impl.dart';

final billRepositoryProvider = Provider<BillRepository>((ref) {
  return BillRepositoryImpl(ref.read(hiveDatabaseServiceProvider));
});

abstract class BillRepository {
  Future<List<FoodItemModel>> getFavoriteItems();
  Future<void> addFavoriteItem(FoodItemModel item);
  Future<void> removeFavoriteItem(FoodItemModel item);
}
