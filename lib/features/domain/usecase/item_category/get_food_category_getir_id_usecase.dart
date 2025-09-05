import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_categori_model.dart';
import '../../repositories/item_category_repository.dart';

final getFoodCategoryGetirIdUsecaseProvider =
    Provider<GetFoodCategoryGetirIdUsecase>((ref) {
      return GetFoodCategoryGetirIdUsecase(
        ref.read(itemCategoryRepositoryProvider),
      );
    });

class GetFoodCategoryGetirIdUsecase
    extends UseCase<Result<List<FoodCategoriModel>>, int> {
  final ItemCategoryRepository _itemCategoryRepository;

  GetFoodCategoryGetirIdUsecase(this._itemCategoryRepository);

  @override
  Future<Result<List<FoodCategoriModel>>> call(int params) async {
    try {
      final result = await _itemCategoryRepository.getFoodCategoryGetirId(
        params,
      );
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
