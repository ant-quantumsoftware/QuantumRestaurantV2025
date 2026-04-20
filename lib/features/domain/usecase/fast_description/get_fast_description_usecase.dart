import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../entity/fast_description_entity.dart';
import '../../repositories/fast_description_repository.dart';

class FastDescriptionUsecaseParams {
  final int? id;
  final int? productId;
  final int? ingredientId;
  final String? localeCode;

  const FastDescriptionUsecaseParams({
    this.id,
    this.productId,
    this.ingredientId,
    this.localeCode,
  });
}

final getFastDescriptionUsecaseProvider = Provider<GetFastDescriptionUsecase>((
  ref,
) {
  return GetFastDescriptionUsecase(ref.read(fastDescriptionRepositoryProvider));
});

class GetFastDescriptionUsecase
    extends
        UseCase<Result<FastDescriptionEntity?>, FastDescriptionUsecaseParams> {
  final FastDescriptionRepository _fastDescriptionRepository;

  GetFastDescriptionUsecase(this._fastDescriptionRepository);

  @override
  Future<Result<FastDescriptionEntity?>> call(
    FastDescriptionUsecaseParams params,
  ) async {
    try {
      final result = await _fastDescriptionRepository.getDescription(
        id: params.id,
        productId: params.productId,
        ingredientId: params.ingredientId,
        localeCode: params.localeCode,
      );
      return result;
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
