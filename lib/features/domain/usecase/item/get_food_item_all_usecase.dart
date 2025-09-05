import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/item_repository.dart';

final getFoodItemAllUsecaseProvider = Provider<GetFoodItemAllUsecase>((ref) {
  return GetFoodItemAllUsecase(ref.read(itemRepositoryProvider));
});

class GetFoodItemAllUsecase extends UseCase<Result<List<FoodItemModel>>, void> {
  final ItemRepository _itemRepository;

  GetFoodItemAllUsecase(this._itemRepository);

  @override
  Future<Result<List<FoodItemModel>>> call(void params) async {
    try {
      final result = await _itemRepository.getFoodItemAll();
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
