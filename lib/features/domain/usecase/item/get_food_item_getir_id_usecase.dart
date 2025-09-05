import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/item_repository.dart';

final getFoodItemGetirIdUsecaseProvider = Provider<GetFoodItemGetirIdUsecase>((
  ref,
) {
  return GetFoodItemGetirIdUsecase(ref.read(itemRepositoryProvider));
});

class GetFoodItemGetirIdUsecase
    extends UseCase<Result<List<FoodItemModel>>, int> {
  final ItemRepository _itemRepository;

  GetFoodItemGetirIdUsecase(this._itemRepository);

  @override
  Future<Result<List<FoodItemModel>>> call(int params) async {
    try {
      final result = await _itemRepository.getFoodItemGetirId(params);
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
