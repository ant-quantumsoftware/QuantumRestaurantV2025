import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/result.dart';
import '../../../data/models/dataGet/table_item_group.dart';
import '../../repositories/table_repository.dart';

final getTableItemGroupAllUsecaseProvider =
    Provider<GetTableItemGroupAllUsecase>((ref) {
      return GetTableItemGroupAllUsecase(ref.read(tableRepositoryProvider));
    });

class GetTableItemGroupAllUsecase
    extends UseCase<Result<List<TableItemGroup>>, void> {
  final TableRepository _tableRepository;

  GetTableItemGroupAllUsecase(this._tableRepository);

  @override
  Future<Result<List<TableItemGroup>>> call(void params) async {
    try {
      final result = await _tableRepository.getTableItemGroupAll();
      return result;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
