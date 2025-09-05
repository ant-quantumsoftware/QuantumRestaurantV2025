import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../data/models/dataGet/food_categori_model.dart';
import '../../data/repositories/item_category_repository_impl.dart';

final itemCategoryRepositoryProvider = Provider<ItemCategoryRepository>((ref) {
  return ItemCategoryRepositoryImpl();
});

abstract class ItemCategoryRepository {
  Future<Result<List<FoodCategoriModel>>> getFoodCategoryAll();
  Future<Result<List<FoodCategoriModel>>> getFoodCategoryGetirId(int type);
}
