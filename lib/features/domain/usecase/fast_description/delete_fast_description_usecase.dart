import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../repositories/fast_description_repository.dart';

class DeleteFastDescriptionUsecaseParams {
  final int productId;
  final int ingredientId;
  final String? localeCode;

  const DeleteFastDescriptionUsecaseParams({
    required this.productId,
    required this.ingredientId,
    this.localeCode,
  });
}

final deleteFastDescriptionUsecaseProvider =
    Provider<DeleteFastDescriptionUsecase>((ref) {
      return DeleteFastDescriptionUsecase(
        ref.read(fastDescriptionRepositoryProvider),
      );
    });

class DeleteFastDescriptionUsecase
    extends UseCase<Result<void>, DeleteFastDescriptionUsecaseParams> {
  final FastDescriptionRepository _fastDescriptionRepository;

  DeleteFastDescriptionUsecase(this._fastDescriptionRepository);

  @override
  Future<Result<void>> call(DeleteFastDescriptionUsecaseParams params) async {
    try {
      final result = await _fastDescriptionRepository.deleteDescription(
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
