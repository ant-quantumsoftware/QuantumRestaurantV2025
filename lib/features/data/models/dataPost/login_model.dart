import 'dart:convert';

import '../../dataSources/remote/http_services.dart';

class LoginModel {
  String? userName;
  String? parola;

  LoginModel({this.userName, this.parola});

  Future<String> getLoginToken() async {
    var sonuc = await HttpServices().LoginMethod(userName!, parola!);
    if (sonuc == "") {
      return sonuc;
    } else {
      var body = jsonDecode(sonuc) as String;
      return body;
    }
  }
}
