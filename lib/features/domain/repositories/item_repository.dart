import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../data/models/dataGet/food_item_model.dart';
import '../../data/repositories/item_repository_impl.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl();
});

abstract class ItemRepository {
  Future<Result<List<FoodItemModel>>> getFoodItemAll();
  Future<Result<List<FoodItemModel>>> getFoodItemCategories(
    String categoryCode,
  );
  Future<Result<List<FoodItemModel>>> getFoodItemGetirId(int type);
}
