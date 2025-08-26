import 'package:quantum_restaurant/features/domain/repositories/bill_repository.dart';

import '../dataSources/local/hive_database_service.dart';
import '../models/dataGet/food_item_model.dart';

class BillRepositoryImpl extends BillRepository {
  final HiveDatabaseService _hiveService;
  final String _favoriteBillsBoxName = 'favorite_bills';

  BillRepositoryImpl(this._hiveService);

  @override
  Future<List<FoodItemModel>> getFavoriteItems() async {
    final list = await _hiveService.getAllData<FoodItemModel>(
      _favoriteBillsBoxName,
    );
    List<FoodItemModel> favoriteBills = [];
    for (var element in list) {
      favoriteBills.add(element);
    }
    return list;
  }

  @override
  Future<void> addFavoriteItem(FoodItemModel bill) async {
    await _hiveService.putData<FoodItemModel>(
      _favoriteBillsBoxName,
      bill.id.toString(),
      bill,
    );
  }

  @override
  Future<void> removeFavoriteItem(FoodItemModel bill) async {
    await _hiveService.deleteData<FoodItemModel>(
      _favoriteBillsBoxName,
      bill.id.toString(),
    );
  }
}
