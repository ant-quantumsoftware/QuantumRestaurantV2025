import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../repositories/bill_repository.dart';

final addFavoriteItemUsecaseProvider = Provider<AddFavoriteItemUsecase>((ref) {
  return AddFavoriteItemUsecase(ref.read(billRepositoryProvider));
});

class AddFavoriteItemUsecase extends UseCase<Result<void>, FoodItemModel> {
  final BillRepository _billRepository;

  AddFavoriteItemUsecase(this._billRepository);

  @override
  Future<Result<void>> call(FoodItemModel params) async {
    try {
      await _billRepository.addFavoriteItem(params);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
