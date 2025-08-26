import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/bill_repository.dart';

final getFavoriteItemsUsecaseProvider = Provider<GetFavoriteItemsUsecase>((
  ref,
) {
  return GetFavoriteItemsUsecase(ref.read(billRepositoryProvider));
});

class GetFavoriteItemsUsecase
    extends UseCase<Result<List<FoodItemModel>>, void> {
  final BillRepository _billRepository;

  GetFavoriteItemsUsecase(this._billRepository);

  @override
  Future<Result<List<FoodItemModel>>> call(void params) async {
    try {
      final result = await _billRepository.getFavoriteItems();
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
