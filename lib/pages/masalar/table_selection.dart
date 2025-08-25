import 'package:animate_do/animate_do.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../components/arama_kutusu.dart';
import '../../components/cuper_form_2.dart';
import '../../components/cuper_picker.dart';
import '../../components/custom_circular_button.dart';
import '../../config/config.dart';
import '../../config/sabit_list.dart';
import '../../dataGet/table_item_group.dart';
import '../../dataGet/table_item_model.dart';
import '../../theme/colors.dart';
import '../../utils.dart';
import '../adisyon/adisyon_main.dart';

class TableSelectionPage extends StatefulWidget {
  final int garsonid;
  final String garsonadi;
  const TableSelectionPage({
    super.key,
    required this.garsonid,
    required this.garsonadi,
  });

  @override
  TableSelectionPageState createState() => TableSelectionPageState();
}

// MASA SEÇİM SAYFASI ANA SAYFA

// class TableDetail {
//   Color color;
//   String time;
//   String? items;
//   String? masaAdi;
//   TableDetail(this.color, this.time, this.items, this.masaAdi);
// }

class TableSelectionPageState extends State<TableSelectionPage> {
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

    setState(() {
      ordersList = cartItems;

      ordersLists = ordersList;
      searchFunc(seciliAramaTxt, seciliMasaGrubu);
      login = false;
    });
  }

  // Arama Fonksiyonu
  void searchFunc(String value, String grupadi) {
    if (value == "" && grupadi == "") {
      ordersLists = ordersList;
    } else if (value != "" && grupadi == "") {
      ordersLists = [];

      for (var people in ordersList) {
        if (people.adi!.toLowerCase().trim().contains(value)) {
          if (!ordersLists.contains(people)) {
            ordersLists.add(people);
            setState(() {});
          }
        }
      }
    } else if (value == "" && grupadi != "") {
      ordersLists = [];

      for (var people in ordersList) {
        if (people.grupadi!.trim().contains(grupadi)) {
          if (!ordersLists.contains(people)) {
            ordersLists.add(people);
            setState(() {});
          }
        }
      }
    } else {
      ordersLists = [];

      for (var people in ordersList) {
        if (people.grupadi!.toLowerCase().trim().contains(grupadi) &&
            people.adi!.toLowerCase().trim().contains(value)) {
          if (!ordersLists.contains(people)) {
            ordersLists.add(people);
            setState(() {});
          }
        }
      }
    }
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Image.asset("assets/logo.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      drawer: builddrawer(context),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            largeTitle: FadeInUp(
              duration: const Duration(milliseconds: 1700),
              child: Align(
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
            middle: Padding(
              padding: const EdgeInsets.only(right: 30, left: 100, top: 3),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1700),
                child: Align(
                  alignment: Alignment.center,
                  child: SearchTextField(
                    fieldValue: (String value) {
                      searchFunc(value, seciliMasaGrubu);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
        body: (login)
            ? const Center(child: CupertinoActivityIndicator(radius: 10.0))
            : RefreshIndicator.adaptive(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: _refreshlist,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  itemCount: ordersLists.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.65,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {
                        Config.gotopage(
                          context,
                          Adisyon(
                            masaid: ordersLists[index].id!,
                            masaadi: ordersLists[index].adi.toString(),
                          ),
                          "",
                          "Ana Menü",
                        ),
                      },
                      child: FadedScaleAnimation(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          height: 90,
                          decoration: BoxDecoration(
                            color: ordersLists[index].masaAcik == true
                                ? ordersLists[index].adisyonYazildi == true
                                      ? Colors.orange[400]
                                      : Colors.red[400]
                                : const Color.fromARGB(81, 10, 103, 13),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ordersLists[index].masaAcik == true
                                  ? ordersLists[index].adisyonYazildi == true
                                        ? Colors.orange
                                        : Colors.red
                                  : Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ordersLists[index].adi.toString(),
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color:
                                          ordersLists[index].adisyonYazildi ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                ordersLists[index].masaAcik == true
                                    ? '${Utils.format.format(ordersLists[index].sureDk)} Dk'
                                    : 'Kapalı',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontSize: 12, color: whiteColor),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                ordersLists[index].sonUrun != null
                                    ? '₺${Utils.format.format(ordersLists[index].toplam)}'
                                    : "",
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                              ),
                              const Spacer(),
                              // ListTile(
                              //   onTap: (){},
                              //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              //   title: Text('Table 1'), trailing: Text('1:33'),),
                              Text(
                                ordersLists[index].masaAcik == true
                                    ? '${ordersLists[index].acanGarson}'
                                    : 'Kapalı',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontSize: 12, color: whiteColor),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  // @override
  // Widget build2(BuildContext context) {
  //   var locale = AppLocalizations.of(context)!;
  //   final arguments =
  //       (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
  //           as Map;
  //   garsonId = 0;

  //   garsonId = arguments['garsonId'];
  //   garsonadi = arguments['garsonadi'];

  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       automaticallyImplyLeading: false,
  //       title: GestureDetector(
  //         onDoubleTap: () {},
  //         child: FadedScaleAnimation(
  //           child: RichText(
  //             text: TextSpan(
  //               children: <TextSpan>[
  //                 TextSpan(
  //                   text: 'Quantum',
  //                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //                     letterSpacing: 1,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: 'Restaurant',
  //                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //                     color: const Color.fromARGB(255, 213, 233, 250),
  //                     letterSpacing: 0,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 11,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         //masadurumuDropdown(context),
  //         buildItemsmasagruplari(context),
  //         buildItemsInGarson(context),

  //         Container(
  //           width: 150,
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
  //           child: TextFormField(
  //             textAlignVertical: TextAlignVertical.center,
  //             decoration: InputDecoration(
  //               prefixIconColor: const Color(0x917a7b82),
  //               prefixIcon: const Icon(Icons.search),
  //               hintText: locale.searchItem,
  //               contentPadding: const EdgeInsets.symmetric(vertical: 0),
  //               filled: true,
  //               hintStyle: Theme.of(
  //                 context,
  //               ).textTheme.bodyLarge?.copyWith(color: const Color(0x917a7b82)),
  //               fillColor: Theme.of(context).scaffoldBackgroundColor,
  //               border: OutlineInputBorder(
  //                 borderSide: BorderSide.none,
  //                 borderRadius: BorderRadius.circular(40),
  //               ),
  //             ),
  //             onFieldSubmitted: (value) {
  //               setState(() {
  //                 seciliAramaTxt = value;
  //                 searchFunc(value, seciliMasaGrubu);
  //               });
  //             },
  //           ),
  //         ),

  //         //buildItemsInCartButton(context) // Butonu Ayarla
  //       ],
  //     ),
  //     body:
  //         (login)
  //             ? const Center(child: CupertinoActivityIndicator(radius: 10.0))
  //             : RefreshIndicator(
  //               edgeOffset: 0,
  //               color: Colors.white,
  //               backgroundColor: const Color.fromARGB(255, 6, 174, 204),
  //               triggerMode: RefreshIndicatorTriggerMode.anywhere,
  //               onRefresh: _refreshlist,
  //               child: GridView.builder(
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 15,
  //                   horizontal: 15,
  //                 ),
  //                 itemCount: ordersLists.length,
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 2,
  //                   crossAxisSpacing: 5,
  //                   mainAxisSpacing: 5,
  //                   childAspectRatio: 1.8,
  //                 ),
  //                 itemBuilder: (context, index) {
  //                   return GestureDetector(
  //                     onTap:
  //                         () => Navigator.pushNamed(
  //                           context,
  //                           PageRoutes.adisyonpage,
  //                           arguments: {
  //                             'masaid': ordersLists[index].id,
  //                             'masaadi': ordersLists[index].adi,
  //                           },
  //                         ),
  //                     child: FadedScaleAnimation(
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 10,
  //                           horizontal: 20,
  //                         ),
  //                         height: 90,
  //                         decoration: BoxDecoration(
  //                           color:
  //                               ordersLists[index].masaAcik == true
  //                                   ? ordersLists[index].adisyonYazildi == true
  //                                       ? Colors.orange[400]
  //                                       : Colors.red[400]
  //                                   : Colors.green[200],
  //                           borderRadius: BorderRadius.circular(10),
  //                           border: Border.all(
  //                             color:
  //                                 ordersLists[index].masaAcik == true
  //                                     ? ordersLists[index].adisyonYazildi ==
  //                                             true
  //                                         ? Colors.orange
  //                                         : Colors.red
  //                                     : Colors.green,
  //                             width: 2,
  //                           ),
  //                         ),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   ordersLists[index].adi.toString(),
  //                                   style: Theme.of(
  //                                     context,
  //                                   ).textTheme.titleMedium!.copyWith(
  //                                     color:
  //                                         ordersLists[index].adisyonYazildi ==
  //                                                 true
  //                                             ? Colors.white
  //                                             : Colors.black,
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.w700,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   ordersLists[index].masaAcik == true
  //                                       ? '${Utils.format.format(ordersLists[index].sureDk)} Dk'
  //                                       : 'Kapalı',
  //                                   style: Theme.of(
  //                                     context,
  //                                   ).textTheme.bodyMedium!.copyWith(
  //                                     fontSize: 12,
  //                                     color: whiteColor,
  //                                   ),
  //                                   overflow: TextOverflow.ellipsis,
  //                                   textAlign: TextAlign.end,
  //                                 ),
  //                               ],
  //                             ),
  //                             Text(
  //                               ordersLists[index].sonUrun != null
  //                                   ? 'Tutar: ${Utils.format.format(ordersLists[index].toplam)}'
  //                                   : "",
  //                               style: Theme.of(
  //                                 context,
  //                               ).textTheme.titleMedium!.copyWith(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w700,
  //                                 color: Colors.deepPurple,
  //                               ),
  //                             ),
  //                             const Spacer(),
  //                             // ListTile(
  //                             //   onTap: (){},
  //                             //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
  //                             //   title: Text('Table 1'), trailing: Text('1:33'),),
  //                             Text(
  //                               ordersLists[index].sonUrun != null
  //                                   ? 'Son Sip: ${ordersLists[index].sonUrun!.substring(0, (ordersLists[index].sonUrun!.length > 18 ? 18 : ordersLists[index].sonUrun!.length))}'
  //                                   : "",
  //                               style: Theme.of(
  //                                 context,
  //                               ).textTheme.titleMedium!.copyWith(
  //                                 fontSize: 8,
  //                                 fontWeight: FontWeight.w700,
  //                                 color: Colors.blue,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //     bottomNavigationBar: altbar(context),
  //   );
  // }

  bool itemSelected = false;
  int drawerCount = 0;
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget builddrawer(BuildContext context) {
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
                          ikon: Icon(
                            Icons.person,
                            color: Theme.of(context).hintColor,
                            size: 24,
                          ),
                          baslik: Text(
                            "Profilim",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () async {},
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: Icon(
                            CupertinoIcons.shield_lefthalf_fill,
                            color: Theme.of(context).hintColor,
                            size: 24,
                          ),
                          baslik: Text(
                            "Sistem Yönetimi",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () {},
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Theme.of(context).hintColor,
                            size: 24,
                          ),
                          baslik: Text(
                            "Destek ve Hata Bildirimi",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onpress: () {},
                        ),
                        Cuperform2(
                          tablo: false,
                          ikon: const Icon(
                            CupertinoIcons.play_circle_fill,
                            color: Colors.red,
                            size: 24,
                          ),
                          baslik: Text(
                            "YouTube",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          altbaslik: const Text(
                            "YouTube kanalımızdan videolar ile ögrenin.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 169, 183, 190),
                              fontSize: 14,
                            ),
                          ),
                          onpress: () async {},
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
                            showCupertinoModalPopup<void>(
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

                                            box1 = await Hive.openBox(
                                              'logininfo',
                                            );

                                            box1.put('password', '');

                                            //ÇIKIŞ YAP METODu
                                            if (!context.mounted) return;

                                            Navigator.of(
                                              context,
                                            ).pushNamedAndRemoveUntil(
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
}
