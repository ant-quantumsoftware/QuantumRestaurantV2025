import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_categori_model.dart';
import '../../repositories/item_category_repository.dart';

final getFoodCategoryAllUsecaseProvider = Provider<GetFoodCategoryAllUsecase>((
  ref,
) {
  return GetFoodCategoryAllUsecase(ref.read(itemCategoryRepositoryProvider));
});

class GetFoodCategoryAllUsecase
    extends UseCase<Result<List<FoodCategoriModel>>, void> {
  final ItemCategoryRepository _itemCategoryRepository;

  GetFoodCategoryAllUsecase(this._itemCategoryRepository);

  @override
  Future<Result<List<FoodCategoriModel>>> call(void params) async {
    try {
      final result = await _itemCategoryRepository.getFoodCategoryAll();
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
