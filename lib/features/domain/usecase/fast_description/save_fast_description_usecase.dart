import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../entity/fast_description_entity.dart';
import '../../repositories/fast_description_repository.dart';

final saveFastDescriptionUsecaseProvider = Provider<SaveFastDescriptionUsecase>(
  (ref) {
    return SaveFastDescriptionUsecase(
      ref.read(fastDescriptionRepositoryProvider),
    );
  },
);

class SaveFastDescriptionUsecase
    extends UseCase<Result<void>, FastDescriptionEntity> {
  final FastDescriptionRepository _fastDescriptionRepository;

  SaveFastDescriptionUsecase(this._fastDescriptionRepository);

  @override
  Future<Result<void>> call(FastDescriptionEntity params) async {
    try {
      final result = await _fastDescriptionRepository.saveDescription(params);
      return result;
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
