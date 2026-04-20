import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/fast_description_model.dart';
import 'hive_database_service.dart';

final fastDescriptionLocalDataSourceProvider =
    Provider<FastDescriptionLocalDataSource>((ref) {
      return FastDescriptionLocalDataSource(
        ref.read(hiveDatabaseServiceProvider),
      );
    });

class FastDescriptionLocalDataSource {
  final HiveDatabaseService _hiveDatabaseService;

  FastDescriptionLocalDataSource(this._hiveDatabaseService);

  Future<void> saveDescription(FastDescriptionModel model) async {
    if (model.productId == null &&
        model.ingredientId == null &&
        model.id == null) {
      model.id = DateTime.now().microsecondsSinceEpoch;
    }

    await _hiveDatabaseService.putData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      model.storageKey,
      model,
    );
  }

  Future<FastDescriptionModel?> getDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    return _hiveDatabaseService.getData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      FastDescriptionModel.buildStorageKey(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      ),
    );
  }

  Future<List<FastDescriptionModel>> getDescriptionsForProduct(
    int? productId, {
    String? localeCode,
  }) async {
    final allDescriptions = await _hiveDatabaseService
        .getAllData<FastDescriptionModel>(FastDescriptionModel.boxName);

    return allDescriptions.where((model) {
      final matchesProduct = productId == null || model.productId == productId;
      final matchesLocale =
          localeCode == null ||
          localeCode.isEmpty ||
          model.localeCode == localeCode;
      return matchesProduct && matchesLocale;
    }).toList();
  }

  Future<void> deleteDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    await _hiveDatabaseService.deleteData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      FastDescriptionModel.buildStorageKey(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      ),
    );
  }

  Future<void> clearDescriptions() async {
    await _hiveDatabaseService.clearBox<FastDescriptionModel>(
      FastDescriptionModel.boxName,
    );
  }
}
