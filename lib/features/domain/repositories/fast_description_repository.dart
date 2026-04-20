import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../data/dataSources/local/fast_description_local_data_source.dart';
import '../../data/models/fast_description_model.dart';
import '../entity/fast_description_entity.dart';

final fastDescriptionRepositoryProvider = Provider<FastDescriptionRepository>((
  ref,
) {
  return FastDescriptionRepositoryImpl(
    ref.read(fastDescriptionLocalDataSourceProvider),
  );
});

abstract class FastDescriptionRepository {
  Future<Result<List<FastDescriptionEntity>>> getDescriptionsForProduct(
    int? productId, {
    String? localeCode,
  });

  Future<Result<FastDescriptionEntity?>> getDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  });

  Future<Result<void>> saveDescription(FastDescriptionEntity entity);

  Future<Result<void>> deleteDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  });

  Future<Result<void>> clearDescriptions();
}

class FastDescriptionRepositoryImpl implements FastDescriptionRepository {
  final FastDescriptionLocalDataSource _localDataSource;

  FastDescriptionRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<FastDescriptionEntity>>> getDescriptionsForProduct(
    int? productId, {
    String? localeCode,
  }) async {
    try {
      final models = await _localDataSource.getDescriptionsForProduct(
        productId,
        localeCode: localeCode,
      );
      return Success(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Failure(message: error.toString());
    }
  }

  @override
  Future<Result<FastDescriptionEntity?>> getDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    try {
      final model = await _localDataSource.getDescription(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      );
      return Success(model?.toEntity());
    } catch (error) {
      return Failure(message: error.toString());
    }
  }

  @override
  Future<Result<void>> saveDescription(FastDescriptionEntity entity) async {
    try {
      await _localDataSource.saveDescription(
        FastDescriptionModel.fromEntity(entity),
      );
      return Success(null);
    } catch (error) {
      return Failure(message: error.toString());
    }
  }

  @override
  Future<Result<void>> deleteDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    try {
      await _localDataSource.deleteDescription(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      );
      return Success(null);
    } catch (error) {
      return Failure(message: error.toString());
    }
  }

  @override
  Future<Result<void>> clearDescriptions() async {
    try {
      await _localDataSource.clearDescriptions();
      return Success(null);
    } catch (error) {
      return Failure(message: error.toString());
    }
  }
}
