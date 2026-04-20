import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/config/sabit_list.dart';
import '../../../../core/routes/route_names.dart';
import '../../../data/models/dataGet/table_item_group.dart';
import '../../../data/models/dataGet/table_item_model.dart';
import '../../components/arama_kutusu.dart';
import '../../components/cuper_form_2.dart';
import '../../components/cuper_picker.dart';
import '../../components/custom_circular_button.dart';
import '../../widgets/table_card.dart';

class HomeView extends StatefulWidget {
  final int garsonid;
  final String garsonadi;
  const HomeView({super.key, required this.garsonid, required this.garsonadi});

  @override
  HomeViewState createState() => HomeViewState();
}

// MASA SEÇİM SAYFASI ANA SAYFA

// class TableDetail {
//   Color color;
//   String time;
//   String? items;
//   String? masaAdi;
//   TableDetail(this.color, this.time, this.items, this.masaAdi);
// }

class HomeViewState extends State<HomeView> {
  // Yeni Metodlar
  bool login = true;
  bool logindetails = true;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool multiselect = false, selected = false, konumvar = false;
  String? referans, site, montaj, seciliad = "Montaj";
  late List<TableItemModel> ordersList = [];
  late List<TableItemModel> ordersLists = [];
  late List<TableItemGroup> gruplist = [];

  late String seciliMasaGrubu;
  late String seciliAramaTxt;

  String? dropdownValue;
  int? garsonId;
  int filterindex = 3;
  String? garsonadi;

  int selectedPersonCount = 1;
  bool itemSelected = false;
  int drawerCount = 0;
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    seciliAramaTxt = '';
    seciliMasaGrubu = '';

    masatipleriGetir();

    verigetir();
  }

  Future<void> masatipleriGetir() async {
    var grupliste = await getTableGroupAll();

    setState(() {
      gruplist = grupliste;

      masagruplari.clear();

      masagruplari.add("Tüm Masalar");

      for (var people in gruplist) {
        masagruplari.add(people.grupAdi!);
      }
    });
  }

  Future<void> verigetir() async {
    List<TableItemModel> cartItems;

    switch (filterindex) {
      case 0:
        {
          cartItems = await getTableItemStatus(1);
          break;
        }
      case 1:
        {
          cartItems = await getTableItemStatus(0);
          break;
        }
      case 2:
        {
          cartItems = await getTableItemGarson(garsonId ?? -1);
          break;
        }
      case 3:
        {
          cartItems = await getTableItemAll();
          break;
        }
      default:
        {
          cartItems = await getTableItemAll();
          break;
        }
    }

    // TEST: 3 örnek masa — tüm renk durumlarını görmek için
    cartItems.addAll([
      TableItemModel(
        id: -1,
        adi: 'Test Kapalı',
        masaAcik: false,
        adisyonYazildi: false,
        acanGarson: null,
        sureDk: 0,
        sonUrun: null,
        toplam: 0,
        grupadi: '',
      ),
      TableItemModel(
        id: -2,
        adi: 'Test Açık',
        masaAcik: true,
        adisyonYazildi: false,
        acanGarson: 'Ahmet',
        sureDk: 45,
        sonUrun: 'Çay',
        toplam: 120.50,
        grupadi: '',
      ),
      TableItemModel(
        id: -3,
        adi: 'Test Adisyon',
        masaAcik: true,
        adisyonYazildi: true,
        acanGarson: 'Mehmet',
        sureDk: 90,
        sonUrun: 'Kebap',
        toplam: 850.00,
        grupadi: '',
      ),
    ]);

    setState(() {
      ordersList = cartItems;

      ordersLists = ordersList;
      searchFunc(seciliAramaTxt, seciliMasaGrubu);
      login = false;
    });
  }

  // Arama Fonksiyonu
  void searchFunc(String value, String grupadi) {
    final searchValue = value.toLowerCase().trim();
    final searchGroup = grupadi.toLowerCase().trim();

    seciliAramaTxt = searchValue;
    seciliMasaGrubu = searchGroup;

    ordersLists = ordersList.where((table) {
      final tableName = (table.adi ?? '').toLowerCase().trim();
      final tableGroup = (table.grupadi ?? '').toLowerCase().trim();

      final nameMatches =
          searchValue.isEmpty || tableName.contains(searchValue);
      final groupMatches =
          searchGroup.isEmpty || tableGroup.contains(searchGroup);

      return nameMatches && groupMatches;
    }).toList();
  }

  // Yeni Servisten Çekmek İçin

  List<String> masagruplari = <String>[];

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
            as Map;
    garsonId = 0;

    garsonId = arguments['garsonId'];
    garsonadi = arguments['garsonadi'];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Çıkış Yap'),
              content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    // Uygulamayı kapat
                    Navigator.of(context).pop(true);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      // import 'dart:io' is required at the top of the file
                      exit(0);
                    });
                  },
                  child: const Text('Evet'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,

        // floatingActionButton: SizedBox(
        //   width: 40,
        //   height: 40,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     onPressed: () {
        //       scaffoldKey.currentState?.openDrawer();
        //     },
        //     child: Image.asset("assets/logo.png"),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: FadeInUp(
            duration: const Duration(milliseconds: 1700),
            child: Align(
              alignment: Alignment.center,
              child: SearchTextField(
                fieldValue: (String value) {
                  setState(() {
                    searchFunc(value, seciliMasaGrubu);
                  });
                },
              ),
            ),
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () async {
                    await _signOut(context);
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: FadeInUp(
              duration: const Duration(milliseconds: 1700),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                child: VeriSecici(
                  liste: MyList.masalar,
                  index: filterindex,
                  degistir: (int selectedItem) {
                    filterindex = selectedItem;
                    login = true;

                    setState(() {
                      verigetir();
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // CupertinoSliverNavigationBar(
            //   backgroundColor: Theme.of(context).colorScheme.surface,
            //   automaticallyImplyLeading: false,
            //   largeTitle: FadeInUp(
            //     duration: const Duration(milliseconds: 1700),
            //     child: Align(
            //       alignment: Alignment.center,
            //       child: VeriSecici(
            //         liste: MyList.masalar,
            //         index: filterindex,
            //         degistir: (int selectedItem) {
            //           filterindex = selectedItem;
            //           login = true;

            //           setState(() {
            //             verigetir();
            //           });
            //         },
            //       ),
            //     ),
            //   ),
            //   middle: Padding(
            //     padding: const EdgeInsets.only(right: 30, left: 10, top: 3),
            //     child: FadeInUp(
            //       duration: const Duration(milliseconds: 1700),
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: SearchTextField(
            //           fieldValue: (String value) {
            //             setState(() {
            //               searchFunc(value, seciliMasaGrubu);
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
          body: (login)
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Consumer(
                  builder: (context, ref, child) {
                    return RefreshIndicator.adaptive(
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: _refreshlist,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        itemCount: ordersLists.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1.65,
                            ),
                        itemBuilder: (context, index) {
                          final table = ordersLists[index];
                          return TableCard(table: table);
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _refreshlist() {
    setState(() {
      verigetir();
    });

    return Future.delayed(const Duration(seconds: 0));
  }

  CustomButton buildItemsInGarson(BuildContext context) {
    return CustomButton(
      onTap: () {
        setState(() {
          drawerCount = 0;
        });
        if (itemSelected) {
          _scaffoldKey.currentState!.openEndDrawer();
        }
      },
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(garsonadi!, style: Theme.of(context).textTheme.bodyMedium),
      bgColor: Colors.green[600],
    );
  }

  DropdownButton buildItemsmasagruplari(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      underline: Container(height: 2, color: Colors.green),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          seciliMasaGrubu = value;
          if (seciliMasaGrubu == 'Tüm Masalar') {
            seciliMasaGrubu = '';
          }
          searchFunc(seciliAramaTxt, seciliMasaGrubu);
        });
      },
      items: masagruplari.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  List<String> list = <String>['Tüm Masalar', 'Açık', 'Kapalı', 'Kendi Masa'];

  DropdownButton masadurumuDropdown(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          verigetir();
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  BottomNavigationBar altbar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tüm Masalar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_filled),
          label: 'Açık Masalar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Kapalı'),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Kendi Masalarım',
        ),
      ],
      currentIndex: filterindex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      filterindex = index;
      login = true;
      verigetir();
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        persistentFooterAlignment: AlignmentDirectional.centerStart,
        persistentFooterButtons: const [
          Text(
            'Copyright © 2005\nQuantum Yazılım',
            style: TextStyle(
              color: Color.fromARGB(85, 128, 131, 133),
              fontSize: 14,
            ),
          ),
        ],
        body: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 90),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            garsonadi ?? "Garson",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 22,
                              fontFamily: "Montserrat-Bold",
                            ),
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      backgroundColor: Colors.transparent,
                      header: const Text(""),
                      margin: const EdgeInsets.only(
                        right: 15,
                        left: 15,
                        bottom: 15,
                        top: 0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      children: <Widget>[
                        Cuperform2(
                          tablo: false,
                          ikon: const Icon(
                            Icons.list_alt_rounded,
                            color: Colors.blue,
                            size: 24,
                          ),
                          baslik: Text(
                            "Hazır Açıklamalar",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () {
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).pushNamed(RouteNames.fastDescriptionPage);
                          },
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: const Icon(
                            Icons.list_alt_rounded,
                            color: Colors.blue,
                            size: 24,
                          ),
                          baslik: Text(
                            "Uygulama Logları",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () {
                            // TODO: Logları Göster Metodu
                          },
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: const Icon(
                            Icons.color_lens_rounded,
                            color: Colors.blue,
                            size: 24,
                          ),
                          baslik: Text(
                            "Tema Seçenekleri",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () {
                            // TODO: Ayarlar Metodu
                          },
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: const Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                            size: 24,
                          ),
                          baslik: Text(
                            "Çıkış",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () async {
                            Navigator.pop(context);
                            _signOut(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return CupertinoActionSheet(
              title: Text(
                "$garsonadi hesabından çıkış yapılacak.\nDevam edilsin mi?",
              ),
              cancelButton: CupertinoActionSheetAction(
                child: const Text("Vazgeç"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  child: const Text("Devam et"),
                  onPressed: () async {
                    Box box1;

                    box1 = await Hive.openBox('logininfo');

                    box1.put('password', '');

                    //ÇIKIŞ YAP METODu
                    if (!context.mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
