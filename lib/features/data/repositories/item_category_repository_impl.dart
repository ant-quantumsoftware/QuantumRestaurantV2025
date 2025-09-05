import 'dart:convert';

import '../../../core/usecase/result.dart';
import '../../domain/repositories/item_category_repository.dart';
import '../dataSources/remote/http_services.dart';
import '../models/dataGet/food_categori_model.dart';

class ItemCategoryRepositoryImpl implements ItemCategoryRepository {
  @override
  Future<Result<List<FoodCategoriModel>>> getFoodCategoryAll() async {
    try {
      var sonuc = await HttpServices().getMethod("ItemsCategoriV1/get");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => FoodCategoriModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<FoodCategoriModel>>> getFoodCategoryGetirId(
    int type,
  ) async {
    try {
      var sonuc = await HttpServices().getMethod("ItemsCategoriV1/get/$type");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => FoodCategoriModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
