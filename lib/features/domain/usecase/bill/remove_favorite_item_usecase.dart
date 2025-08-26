import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/bill_repository.dart';

final removeFavoriteItemUsecaseProvider = Provider<RemoveFavoriteItemUsecase>((
  ref,
) {
  return RemoveFavoriteItemUsecase(ref.read(billRepositoryProvider));
});

class RemoveFavoriteItemUsecase extends UseCase<Result<void>, FoodItemModel> {
  final BillRepository _billRepository;

  RemoveFavoriteItemUsecase(this._billRepository);

  @override
  Future<Result<void>> call(FoodItemModel params) async {
    try {
      await _billRepository.removeFavoriteItem(params);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
