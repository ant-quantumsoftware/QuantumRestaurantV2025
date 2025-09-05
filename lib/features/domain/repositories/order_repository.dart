import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../data/models/dataGet/card_item_model.dart';
import '../../data/repositories/order_repository_impl.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl();
});

abstract class OrderRepository {
  Future<Result<List<CardItemModel>>> getCardItemAll();
  Future<Result<List<CardItemModel>>> getCardItemGetirId(int type);
}
