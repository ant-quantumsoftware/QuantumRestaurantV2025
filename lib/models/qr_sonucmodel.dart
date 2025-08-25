

class QrSonucModel {
  bool? status;
  int? ref1;
  int? ref2;
  String? txt1;
  String? txt2;
  String? txt3;
  String? txt4;

  QrSonucModel(
      {this.status,
      this.ref1,
      this.ref2,
      this.txt1,
      this.txt2,
      this.txt3,
      this.txt4});

  QrSonucModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ref1 = json['ref1'];
    ref2 = json['ref2'];
    txt1 = json['txt1'];
    txt2 = json['txt2'];
    txt3 = json['txt3'];
    txt4 = json['txt4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['ref1'] = ref1;
    data['ref2'] = ref2;
    data['txt1'] = txt1;
    data['txt2'] = txt2;
    data['txt3'] = txt3;
    data['txt4'] = txt4;
    return data;
  }
}

// Future<List<QrSonucModel>> getqrsonucgetir(String code) async {
//   //qrsonuc getiren metod
// }
