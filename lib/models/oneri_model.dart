
class OneriModel {
  int? id;
  String? value;
  int? count;

  OneriModel({this.id, this.value, this.count});

  OneriModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['count'] = count;
    return data;
  }
}

// Future<List<OneriModel>> getbakimonerileriGetir(String index, String id) async {
//   //model alma metodu
// }
