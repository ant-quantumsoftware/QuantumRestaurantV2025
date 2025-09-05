import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/card_item_model.dart';
import '../../repositories/order_repository.dart';

final getCardItemGetirIdUsecaseProvider = Provider<GetCardItemGetirIdUsecase>((
  ref,
) {
  return GetCardItemGetirIdUsecase(ref.read(orderRepositoryProvider));
});

class GetCardItemGetirIdUsecase
    extends UseCase<Result<List<CardItemModel>>, int> {
  final OrderRepository _orderRepository;

  GetCardItemGetirIdUsecase(this._orderRepository);

  @override
  Future<Result<List<CardItemModel>>> call(int params) async {
    try {
      final result = await _orderRepository.getCardItemGetirId(params);
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
