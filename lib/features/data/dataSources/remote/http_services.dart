// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../config/settings.dart';

class HttpServices {
  late String token;
  late String serveradres =
      "api.quantumyazilim.com"; //"http://192.168.1.124:81";

  Future<String> getMethod(String apiEki) async {
    token = 'Olmadı.';

    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    final dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;

    final response = await dio.get("http://$serveradres/$apiEki");

    if (response.statusCode == 200) {
      return json.encode(response.data);
    } else {
      return "";
    }
  }

  Future<String> LoginMethod(String UserName, String Password) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "POST";

    var headers = {'Content-Type': 'application/json'};

    var data = json.encode({"Email": UserName, "Parola": Password});

    var response = await dio.request(
      'http://$serveradres/RestLogin/login',
      options: Options(method: 'POST', headers: headers),
      data: data,
    );
    if (response.statusCode == 200) {
      return json.encode(response.data);
    } else {
      return "";
    }
  }

  Future<bool> PostMethod(String apiEki, String data) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "POST";

    try {
      final response = await dio.post(
        "http://$serveradres/$apiEki",
        data: data,
      );

      if (response.statusCode == 200) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on Exception catch (ex) {
      String hata = ex.toString();
      return false;
    }
  }

  Future<bool> DeleteMethod(String apiEki) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = "DELETE";

    try {
      final response = await dio.delete("http://$serveradres/$apiEki");

      if (response.statusCode == 200) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on Exception catch (ex) {
      String hata = ex.toString();
      return false;
    }
  }

  Future<bool> SampleMethod(String apiEki, String MethodName) async {
    final dio = Dio();
    token = Settings.getToken();
    serveradres = Settings.getApiAdres();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;
    dio.options.method = MethodName;

    try {
      final response = await dio.put("http://$serveradres/$apiEki");

      if (response.statusCode == 200) {
        String resultmesaj = json.encode(response.data);

        return true;
      } else {
        return false;
      }
    } on Exception catch (ex) {
      String hata = ex.toString();
      return false;
    }
  }
}
