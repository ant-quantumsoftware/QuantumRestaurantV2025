import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/table_item_model.dart';
import '../../repositories/table_repository.dart';

final getTableItemStatusUsecaseProvider = Provider<GetTableItemStatusUsecase>((
  ref,
) {
  return GetTableItemStatusUsecase(ref.read(tableRepositoryProvider));
});

class GetTableItemStatusUsecase
    extends UseCase<Result<List<TableItemModel>>, int> {
  final TableRepository _tableRepository;

  GetTableItemStatusUsecase(this._tableRepository);

  @override
  Future<Result<List<TableItemModel>>> call(int params) async {
    try {
      final result = await _tableRepository.getTableItemStatus(params);
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
