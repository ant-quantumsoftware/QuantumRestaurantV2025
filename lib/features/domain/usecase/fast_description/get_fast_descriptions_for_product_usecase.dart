import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../entity/fast_description_entity.dart';
import '../../repositories/fast_description_repository.dart';

class GetFastDescriptionsForProductUsecaseParams {
  final int? productId;
  final String? localeCode;

  const GetFastDescriptionsForProductUsecaseParams({
    this.productId,
    this.localeCode,
  });
}

final getFastDescriptionsForProductUsecaseProvider =
    Provider<GetFastDescriptionsForProductUsecase>((ref) {
      return GetFastDescriptionsForProductUsecase(
        ref.read(fastDescriptionRepositoryProvider),
      );
    });

class GetFastDescriptionsForProductUsecase
    extends
        UseCase<
          Result<List<FastDescriptionEntity>>,
          GetFastDescriptionsForProductUsecaseParams
        > {
  final FastDescriptionRepository _fastDescriptionRepository;

  GetFastDescriptionsForProductUsecase(this._fastDescriptionRepository);

  @override
  Future<Result<List<FastDescriptionEntity>>> call(
    GetFastDescriptionsForProductUsecaseParams params,
  ) async {
    try {
      final result = await _fastDescriptionRepository.getDescriptionsForProduct(
        params.productId,
        localeCode: params.localeCode,
      );
      return result;
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
