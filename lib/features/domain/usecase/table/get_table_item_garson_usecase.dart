import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/table_item_model.dart';
import '../../repositories/table_repository.dart';

final getTableItemGarsonUsecaseProvider = Provider<GetTableItemGarsonUsecase>((
  ref,
) {
  return GetTableItemGarsonUsecase(ref.read(tableRepositoryProvider));
});

class GetTableItemGarsonUsecase
    extends UseCase<Result<List<TableItemModel>>, int> {
  final TableRepository _tableRepository;

  GetTableItemGarsonUsecase(this._tableRepository);

  @override
  Future<Result<List<TableItemModel>>> call(int params) async {
    try {
      final result = await _tableRepository.getTableItemGarson(params);
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
