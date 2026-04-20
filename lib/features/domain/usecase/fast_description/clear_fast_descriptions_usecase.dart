import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../repositories/fast_description_repository.dart';

final clearFastDescriptionsUsecaseProvider =
    Provider<ClearFastDescriptionsUsecase>((ref) {
      return ClearFastDescriptionsUsecase(
        ref.read(fastDescriptionRepositoryProvider),
      );
    });

class ClearFastDescriptionsUsecase extends NoParamsUseCase<Result<void>> {
  final FastDescriptionRepository _fastDescriptionRepository;

  ClearFastDescriptionsUsecase(this._fastDescriptionRepository);

  @override
  Future<Result<void>> call() async {
    try {
      final result = await _fastDescriptionRepository.clearDescriptions();
      return result;
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
