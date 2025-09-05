import 'dart:convert';

import '../../../core/usecase/result.dart';
import '../../domain/repositories/table_repository.dart';
import '../dataSources/remote/http_services.dart';
import '../models/dataGet/table_item_group.dart';
import '../models/dataGet/table_item_model.dart';

class TableRepositoryImpl implements TableRepository {
  @override
  Future<Result<List<TableItemModel>>> getTableItemAll() async {
    try {
      var sonuc = await HttpServices().getMethod("RestTablesV1/get");
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => TableItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<TableItemModel>>> getTableItemGarson(int garsonId) async {
    try {
      var sonuc = await HttpServices().getMethod(
        "RestTablesV1/GetGarson?GarsonId=$garsonId",
      );
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => TableItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  // 0 Kapalı Masalar
  // 1 Açık Masalar
  // 2 Tüm Masalar

  @override
  Future<Result<List<TableItemModel>>> getTableItemStatus(int tipx) async {
    try {
      var sonuc = await HttpServices().getMethod(
        "RestTablesV1/GetStatus?Status=$tipx",
      );
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => TableItemModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<TableItemGroup>>> getTableItemGroupAll() async {
    try {
      var sonuc = await HttpServices().getMethod(
        "RestTablesV1/GetMasaGruplari",
      );
      var body = jsonDecode(sonuc) as List;
      return Success(body.map((e) => TableItemGroup.fromJson(e)).toList());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
