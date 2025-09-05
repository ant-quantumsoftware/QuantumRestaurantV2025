import 'dart:convert';

import 'package:quantum_restaurant/core/usecase/result.dart';

import 'package:quantum_restaurant/features/data/models/dataGet/food_item_model.dart';

import '../../domain/repositories/item_repository.dart';
import '../dataSources/remote/http_services.dart';

class ItemRepositoryImpl implements ItemRepository {
  @override
  Future<Result<List<FoodItemModel>>> getFoodItemAll() async {
    try {
      var sonuc = await HttpServices().getMethod("ItemsV1/get");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => FoodItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<FoodItemModel>>> getFoodItemCategories(
    String categoryCode,
  ) async {
    try {
      var sonuc = await HttpServices().getMethod(
        "ItemsV1/GetCategories?KategoriKodu=$categoryCode",
      );
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => FoodItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<FoodItemModel>>> getFoodItemGetirId(int type) async {
    try {
      var sonuc = await HttpServices().getMethod("ItemsV1/get/$type");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => FoodItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
