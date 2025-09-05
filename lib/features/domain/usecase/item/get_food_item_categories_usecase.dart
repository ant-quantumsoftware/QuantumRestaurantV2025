import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/item_repository.dart';

final getFoodItemCategoriesUsecaseProvider =
    Provider<GetFoodItemCategoriesUsecase>((ref) {
      return GetFoodItemCategoriesUsecase(ref.read(itemRepositoryProvider));
    });

class GetFoodItemCategoriesUsecase
    extends UseCase<Result<List<FoodItemModel>>, String> {
  final ItemRepository _itemRepository;

  GetFoodItemCategoriesUsecase(this._itemRepository);

  @override
  Future<Result<List<FoodItemModel>>> call(String params) async {
    try {
      final result = await _itemRepository.getFoodItemCategories(params);
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
