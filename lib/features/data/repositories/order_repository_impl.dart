import 'dart:convert';

import 'package:quantum_restaurant/core/usecase/result.dart';

import 'package:quantum_restaurant/features/data/models/dataGet/card_item_model.dart';

import '../../domain/repositories/order_repository.dart';
import '../dataSources/remote/http_services.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<Result<List<CardItemModel>>> getCardItemAll() async {
    try {
      var sonuc = await HttpServices().getMethod("RestOrderV1/get");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => CardItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<CardItemModel>>> getCardItemGetirId(int type) async {
    try {
      var sonuc = await HttpServices().getMethod("RestOrderV1/get/$type");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => CardItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
