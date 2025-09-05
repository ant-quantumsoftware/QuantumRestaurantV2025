import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/card_item_model.dart';
import '../../repositories/order_repository.dart';

final getCardItemAllUsecaseProvider = Provider<GetCardItemAllUsecase>((ref) {
  return GetCardItemAllUsecase(ref.read(orderRepositoryProvider));
});

class GetCardItemAllUsecase extends UseCase<Result<List<CardItemModel>>, void> {
  final OrderRepository _orderRepository;

  GetCardItemAllUsecase(this._orderRepository);

  @override
  Future<Result<List<CardItemModel>>> call(void params) async {
    try {
      final result = await _orderRepository.getCardItemAll();
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
