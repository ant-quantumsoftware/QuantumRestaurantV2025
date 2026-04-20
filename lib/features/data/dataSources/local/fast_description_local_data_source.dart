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
    await _hiveDatabaseService.putData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      model.storageKey,
      model,
    );
  }

  Future<FastDescriptionModel?> getDescription({
    required int productId,
    required int ingredientId,
    String? localeCode,
  }) async {
    return _hiveDatabaseService.getData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      FastDescriptionModel.buildStorageKey(
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      ),
    );
  }

  Future<List<FastDescriptionModel>> getDescriptionsForProduct(
    int productId, {
    String? localeCode,
  }) async {
    final allDescriptions = await _hiveDatabaseService
        .getAllData<FastDescriptionModel>(FastDescriptionModel.boxName);

    return allDescriptions.where((model) {
      final matchesProduct = model.productId == productId;
      final matchesLocale =
          localeCode == null ||
          localeCode.isEmpty ||
          model.localeCode == localeCode;
      return matchesProduct && matchesLocale;
    }).toList();
  }

  Future<void> deleteDescription({
    required int productId,
    required int ingredientId,
    String? localeCode,
  }) async {
    await _hiveDatabaseService.deleteData<FastDescriptionModel>(
      FastDescriptionModel.boxName,
      FastDescriptionModel.buildStorageKey(
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
