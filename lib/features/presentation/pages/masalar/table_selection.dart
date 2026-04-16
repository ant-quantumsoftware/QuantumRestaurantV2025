import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/config/config.dart';
import '../../../../core/config/sabit_list.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/utils.dart';
import '../../../data/models/dataGet/table_item_group.dart';
import '../../../data/models/dataGet/table_item_model.dart';
import '../../components/arama_kutusu.dart';
import '../../components/cuper_form_2.dart';
import '../../components/cuper_picker.dart';
import '../../components/custom_circular_button.dart';
import '../../module/adisyon_notifier.dart';
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

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset("assets/logo.png"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        drawer: _buildDrawer(context),
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
              : Consumer(
                  builder: (context, ref, child) {
                    final adisyonNotifier = ref.watch(
                      adisyonNotifierProvider.notifier,
                    );
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
                          return GestureDetector(
                            onTap: () async {
                              if (table.kisiSayisi == null ||
                                  table.kisiSayisi == 0) {
                                _showPersonCountDialog(context, table);
                              } else {
                                adisyonNotifier.setPersonCount(
                                  table.kisiSayisi!,
                                );
                                Config.gotopage(
                                  context,
                                  Adisyon(
                                    masaid: table.id!,
                                    masaadi: table.adi.toString(),
                                  ),
                                  "",
                                  "Ana Menü",
                                );
                              }
                            },
                            child: _buildTableCard(table),
                          );
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

  Widget _buildTableCard(TableItemModel table) {
    final bool isOpen = table.masaAcik == true;
    final bool isBillWritten = table.adisyonYazildi == true;

    final List<Color> gradientColors = isOpen
        ? isBillWritten
              ? [const Color(0xFF5C3A10), const Color(0xFF7A5228)]
              : [const Color(0xFF5A2020), const Color(0xFF7A3535)]
        : [const Color(0xFF1E3A2A), const Color(0xFF2E5540)];

    final Color accentColor = isOpen
        ? isBillWritten
              ? const Color(0xFFD4A96A)
              : const Color(0xFFCC8080)
        : const Color(0xFF6DAF8A);

    return FadedScaleAnimation(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.45),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Decorative circle overlay
              Positioned(
                top: -28,
                right: -28,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: masa adı + durum badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            table.adi.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOpen
                                ? (isBillWritten ? 'Adisyon' : 'Açık')
                                : 'Kapalı',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(height: 1, color: Colors.white.withOpacity(0.18)),
                    const Spacer(),
                    // Süre
                    if (isOpen)
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${Utils.format.format(table.sureDk)} Dk',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    // Alt satır: garson + toplam
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                size: 11,
                                color: Colors.white.withOpacity(0.75),
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  isOpen ? '${table.acanGarson}' : 'Kapalı',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (table.sonUrun != null)
                          Text(
                            '₺${Utils.format.format(table.toplam)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showPersonCountDialog(BuildContext context, TableItemModel table) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey[100]!, Colors.white, Colors.grey[50]!],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.buttonColor.withOpacity(0.05),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final personCount = ref
                    .watch(adisyonNotifierProvider)
                    .personCount;
                final adisyonNotifier = ref.watch(
                  adisyonNotifierProvider.notifier,
                );
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top decorative element
                    Container(
                      height: 6,
                      width: 60,
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.buttonColor.withOpacity(0.3),
                            AppColors.buttonColor,
                            AppColors.buttonColor.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Header with enhanced design
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.buttonColor.withOpacity(0.06),
                                  AppColors.buttonColor.withOpacity(0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.buttonColor.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.buttonColor,
                                        AppColors.buttonColor.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.buttonColor
                                            .withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.people_alt_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kişi Sayısı Seçin',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.buttonColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.buttonColor
                                              .withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Masa: ${table.adi}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.buttonColor
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Enhanced person count selector
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey[100]!,
                                  Colors.white,
                                  Colors.grey[50]!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.buttonColor.withOpacity(0.12),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.buttonColor.withOpacity(
                                    0.08,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Decrease button with enhanced design
                                GestureDetector(
                                  onTap: () {
                                    if (personCount > 1) {
                                      adisyonNotifier.removePersonCount();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: personCount > 1
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.buttonColor,
                                                AppColors.buttonColor
                                                    .withOpacity(0.8),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey[300]!,
                                                Colors.grey[400]!,
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: personCount > 1
                                          ? [
                                              BoxShadow(
                                                color: AppColors.buttonColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: personCount > 1
                                          ? Colors.white
                                          : Colors.grey[500],
                                      size: 24,
                                    ),
                                  ),
                                ),

                                // Enhanced person count display
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.buttonColor.withOpacity(0.08),
                                        AppColors.buttonColor.withOpacity(0.04),
                                        AppColors.buttonColor.withOpacity(0.12),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: AppColors.buttonColor.withOpacity(
                                        0.6,
                                      ),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.buttonColor
                                            .withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 6,
                                        offset: const Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttonColor,
                                            letterSpacing: 0.8,
                                          ),
                                          child: Text('$personCount'),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          'Kişi',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.buttonColor
                                                .withOpacity(0.7),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Increase button with enhanced design
                                GestureDetector(
                                  onTap: () {
                                    if (personCount < 10) {
                                      adisyonNotifier.addPersonCount();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: personCount < 10
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.buttonColor,
                                                AppColors.buttonColor
                                                    .withOpacity(0.8),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey[300]!,
                                                Colors.grey[400]!,
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: personCount < 10
                                          ? [
                                              BoxShadow(
                                                color: AppColors.buttonColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: personCount < 10
                                          ? Colors.white
                                          : Colors.grey[500],
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Enhanced action buttons
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey[200]!,
                                        Colors.grey[100]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      adisyonNotifier.setPersonCount(1);
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.close_rounded,
                                          color: Colors.grey[600],
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'İptal',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.buttonColor,
                                        AppColors.buttonColor.withOpacity(0.85),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.buttonColor
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Config.gotopage(
                                        context,
                                        Adisyon(
                                          masaid: table.id!,
                                          masaadi: table.adi.toString(),
                                        ),
                                        "",
                                        "Ana Menü",
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Devam Et',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
