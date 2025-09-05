import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/table_item_model.dart';
import '../../repositories/table_repository.dart';

final getTableItemAllUsecaseProvider = Provider<GetTableItemAllUsecase>((ref) {
  return GetTableItemAllUsecase(ref.read(tableRepositoryProvider));
});

class GetTableItemAllUsecase
    extends UseCase<Result<List<TableItemModel>>, void> {
  final TableRepository _tableRepository;

  GetTableItemAllUsecase(this._tableRepository);

  @override
  Future<Result<List<TableItemModel>>> call(void params) async {
    try {
      final result = await _tableRepository.getTableItemAll();
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
