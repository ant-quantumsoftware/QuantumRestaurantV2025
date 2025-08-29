import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:grock/grock.dart';

import '../../../core/utils/utils.dart';

class YeniSiparis extends StatelessWidget {
  const YeniSiparis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeni Sipariş',
      home: Home(),
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  final dio = Dio();
  FocusNode? _focusNode;

  /// TODO: Arama işlemi değişkenleri
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  List<Malzeme> peopleList = [];
  List<Malzeme> searchList = [];

  void searchFunc(String value) {
    for (var people in peopleList) {
      if (people.adi!.toLowerCase().trim().contains(
        searchController.text.toLowerCase().trim(),
      )) {
        if (!searchList.contains(people)) {
          searchList.add(people);
          setState(() {});
        }
      }
    }
  }

  ///
  Future<MalzemeModel> getData() async {
    setState(() {
      isLoading = true;
    });

    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiUXVhbnR1bSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3NpZCI6IjQiLCJleHAiOjE3MTYyMTIyMTcsImlzcyI6InF1YW50dW1hcGkiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAifQ.SnnLZ6VBlmbH-QLaiI0ckC-wfcI-t8isFUZ5b3vp4AU';

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Auth"] = token;

    final response = await dio.get(
      'http://api.quantumyazilim.com/CurrentAccounts/get',
    );
    return MalzemeModel.fromJson(response.data);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    getData().then(
      (value) => setState(() {
        peopleList = value.malzemeler!;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: appbarTitle(),
        trailing: searchIconWidget(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : GrockList(
              itemCount: searchList.isNotEmpty
                  ? searchList.length
                  : peopleList.length,
              itemBuilder: (context, index) {
                var item = searchList.isNotEmpty
                    ? searchList[index]
                    : peopleList[index];
                return Card(
                  child: ListTile(
                    title: Text("${item.adi}"),
                    subtitle: Text('${item.kodu!} ${item.kodu!}'),
                    leading: CircleAvatar(backgroundImage: NetworkImage('')),
                    trailing: Text(Utils.format.format(item.fiyat1)),
                    onTap: () {
                      //navigateToDetail(item);
                    },
                  ),
                );
              },
            ),
    );
  }

  /*void navigateToDetail(Cariler item) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Malzeme(cari: item)));
    if (result == true) {
      getData();
    }
  }*/

  Widget appbarTitle() {
    if (isSearch) {
      return CupertinoTextField(
        controller: searchController,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        placeholder: 'Ara',
        onSubmitted: (value) {
          searchFunc(value);
        },
      );
    } else {
      return const Text('Yeni Sipariş');
    }
  }

  Widget searchIconWidget() {
    if (isSearch) {
      return GrockContainer(
        padding: 10.onlyLeftP,
        child: const Icon(CupertinoIcons.clear, size: 24),
        onTap: () {
          setState(() {
            _focusNode!.unfocus();
            isSearch = false;
            searchList.clear();
          });
        },
      );
    } else {
      return GrockContainer(
        padding: 10.onlyLeftP,
        child: const Icon(CupertinoIcons.search, size: 24),
        onTap: () {
          setState(() {
            _focusNode!.requestFocus();
            isSearch = true;
          });
        },
      );
    }
  }
}

class MalzemeModel {
  List<Malzeme>? malzemeler;
  String? controller;
  String? action;
  bool? hata;
  String? mesaj;

  MalzemeModel({
    required this.malzemeler,
    required this.controller,
    required this.action,
    required this.hata,
    required this.mesaj,
  });

  MalzemeModel.fromJson(Map<String, dynamic> json) {
    if (json['Malzemeler'] != null) {
      malzemeler = <Malzeme>[];
      json['Malzemeler'].forEach((v) {
        malzemeler!.add(Malzeme.fromJson(v));
      });
    }
    controller = json['controller'];
    action = json['action'];
    hata = json['hata'];
    mesaj = json['mesaj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (malzemeler != null) {
      data['Malzemeler'] = malzemeler!.map((v) => v.toJson()).toList();
    }
    data['controller'] = controller;
    data['action'] = action;
    data['hata'] = hata;
    data['mesaj'] = mesaj;
    return data;
  }
}

class Malzeme {
  int? id;
  String? kodu;
  String? adi;
  String? kategori;
  String? altKategori;
  bool? aktif;
  String? grupKodu;
  double? stok;
  double? fiyat1;
  double? fiyat2;
  double? kdvOran;
  double? fiyat1Dahil;
  double? fiyatDinamikSatis;
  double? fiyatDinamikSatisDahil;
  String? turu;

  Malzeme({
    this.id,
    this.kodu,
    this.adi,
    this.kategori,
    this.altKategori,
    this.aktif,
    this.grupKodu,
    this.stok,
    this.fiyat1,
    this.fiyat2,
    this.kdvOran,
    this.fiyat1Dahil,
    this.fiyatDinamikSatis,
    this.fiyatDinamikSatisDahil,
    this.turu,
  });

  Malzeme.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    kodu = json['Kodu'];
    adi = json['Adi'];
    kategori = json['Kategori'];
    altKategori = json['AltKategori'];
    aktif = json['Aktif'];
    grupKodu = json['GrupKodu'];
    stok = json['Stok'];
    fiyat1 = json['Fiyat1'];
    fiyat2 = json['Fiyat2'];
    kdvOran = json['KdvOran'];
    fiyat1Dahil = json['Fiyat1Dahil'];
    fiyatDinamikSatis = json['FiyatDinamikSatis'];
    fiyatDinamikSatisDahil = json['FiyatDinamikSatisDahil'];
    turu = json['Turu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Kodu'] = kodu;
    data['Adi'] = adi;
    data['Kategori'] = kategori;
    data['AltKategori'] = altKategori;
    data['Aktif'] = aktif;
    data['GrupKodu'] = grupKodu;
    data['Stok'] = stok;
    data['Fiyat1'] = fiyat1;
    data['Fiyat2'] = fiyat2;
    data['KdvOran'] = kdvOran;
    data['Fiyat1Dahil'] = fiyat1Dahil;
    data['FiyatDinamikSatis'] = fiyatDinamikSatis;
    data['FiyatDinamikSatisDahil'] = fiyatDinamikSatisDahil;
    data['Turu'] = turu;
    return data;
  }
}
