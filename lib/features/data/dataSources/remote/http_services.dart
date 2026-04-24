// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/config/settings.dart';
import '../../../../core/services/app_log_service.dart';

class HttpServices {
  late String token;
  late String serveradres =
      "api.quantumyazilim.com"; //"http://192.168.1.124:81";

  Future<void> _saveRequestLog({
    required String method,
    required String endpoint,
    int? statusCode,
    required bool success,
    String? message,
  }) async {
    await AppLogService.addRequestLog(
      method: method,
      endpoint: endpoint,
      statusCode: statusCode,
      success: success,
      message: message,
    );
  }

  Future<String> getMethod(String apiEki) async {
    token = 'Olmadı.';

    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = "http://$serveradres/$apiEki";
    final dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;

    try {
      final response = await dio.get(endpoint);
      final isSuccess = response.statusCode == 200;

      await _saveRequestLog(
        method: 'GET',
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        return json.encode(response.data);
      }
      return "";
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: 'GET',
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return "";
    } on Exception catch (ex) {
      await _saveRequestLog(
        method: 'GET',
        endpoint: endpoint,
        success: false,
        message: ex.toString(),
      );
      return "";
    }
  }

  Future<String> LoginMethod(String UserName, String Password) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = 'http://$serveradres/RestLogin/login';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "POST";

    var headers = {'Content-Type': 'application/json'};

    var data = json.encode({"Email": UserName, "Parola": Password});

    try {
      var response = await dio.request(
        endpoint,
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      final isSuccess = response.statusCode == 200;
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        return json.encode(response.data);
      }
      return "";
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return "";
    } on Exception catch (ex) {
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        success: false,
        message: ex.toString(),
      );
      return "";
    }
  }

  Future<String> LoginRestaurantMethod(String UserName, String Password) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = 'http://$serveradres/RestLogin/LoginRestaurant';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "POST";

    var headers = {'Content-Type': 'application/json'};

    var data = json.encode({
      "Email": UserName,
      "Parola": Password,
      "SirketNo": "",
    });

    try {
      var response = await dio.request(
        endpoint,
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      final isSuccess = response.statusCode == 200;
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        return json.encode(response.data);
      }
      log(
        "LoginRestaurantMethod failed with status code: ${response.statusCode}",
      );
      log("Response data: ${response.data}");
      return "";
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return "";
    } on Exception catch (ex) {
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        success: false,
        message: ex.toString(),
      );
      return "";
    }
  }

  Future<bool> PostMethod(String apiEki, String data) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = "http://$serveradres/$apiEki";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "POST";

    try {
      final response = await dio.post(endpoint, data: data);
      log(data);
      final isSuccess = response.statusCode == 200;
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return false;
    } on Exception catch (ex) {
      String hata = ex.toString();
      await _saveRequestLog(
        method: 'POST',
        endpoint: endpoint,
        success: false,
        message: hata,
      );
      return false;
    }
  }

  Future<bool> DeleteMethod(String apiEki) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = "http://$serveradres/$apiEki";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "DELETE";

    try {
      final response = await dio.delete(endpoint);

      final isSuccess = response.statusCode == 200;
      await _saveRequestLog(
        method: 'DELETE',
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: 'DELETE',
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return false;
    } on Exception catch (ex) {
      String hata = ex.toString();
      await _saveRequestLog(
        method: 'DELETE',
        endpoint: endpoint,
        success: false,
        message: hata,
      );
      return false;
    }
  }

  Future<bool> SampleMethod(String apiEki, String MethodName) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final endpoint = "http://$serveradres/$apiEki";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = MethodName;

    try {
      final response = await dio.put(endpoint);

      final normalizedMethod = MethodName.toUpperCase();
      final isSuccess = response.statusCode == 200;
      await _saveRequestLog(
        method: normalizedMethod,
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: isSuccess,
        message: isSuccess ? null : response.statusMessage,
      );

      if (isSuccess) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on DioException catch (ex) {
      await _saveRequestLog(
        method: MethodName.toUpperCase(),
        endpoint: endpoint,
        statusCode: ex.response?.statusCode,
        success: false,
        message: ex.message,
      );
      return false;
    } on Exception catch (ex) {
      String hata = ex.toString();
      await _saveRequestLog(
        method: MethodName.toUpperCase(),
        endpoint: endpoint,
        success: false,
        message: hata,
      );
      return false;
    }
  }
}
