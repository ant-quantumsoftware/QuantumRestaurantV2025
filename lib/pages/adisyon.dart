import 'package:animate_do/animate_do.dart';
import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../components/custom_circular_button.dart';
import '../components/liste_menu.dart';
import '../config/settings.dart';
import '../dataGet/card_item_model.dart';
import '../dataGet/food_categori_model.dart';
import '../dataGet/food_item_model.dart';
import '../dataPost/adisyon_model.dart';
import '../pages/cuper_alert.dart';
import '../routes/routes.dart';
import '../utils.dart';
import 'dialog_aciklama_siparis.dart';
import 'dialog_miktar_siparis.dart';

class AdisyonPage extends StatefulWidget {
  final int masaid;
  final String masaadi;
  const AdisyonPage({super.key, required this.masaid, required this.masaadi});

  @override
  State<AdisyonPage> createState() => _AdisyonPageState();
}

class _AdisyonPageState extends State<AdisyonPage>
    with TickerProviderStateMixin {
  // Yeni Metodlar
  bool login = true;
  bool logindetails = true;

  bool multiselect = false, selected = false, konumvar = false;
  String? referans, site, montaj, seciliad = "Montaj";
  late List<CardItemModel> cartItems = []; // Girilen Siparişler
  late List<FoodItemModel> foodItems = []; // Tüm Ürünler
  late List<FoodItemModel> foodItemsS = []; // Tüm Ürünler Arama Sonucu
  late List<FoodCategoriModel> foodCategoriItems = [];

  late TabController _tabcontroller;

  SnackBar snackBar(String mesaj) {
    return SnackBar(
      content: Text(mesaj),
      action: SnackBarAction(
        label: 'Uyarı',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: list.length, vsync: this);

    masaid = widget.masaid;
    masaadi = widget.masaadi;

    _tabcontroller.addListener(() {
      setState(() {
        if (_tabcontroller.index == 1) {
          verigetirgirilenler();
        }
      });
    });
    verigetironcelikli();
  }

  Future<void> verigetironcelikli() async {
    setState(() {
      foodCategoriItems = Settings.getFoodCategoriItems();
    });
    await verigetir();
  }

  Future<void> verigetir() async {
    var cartItems = await getCardItemGetirId(masaid);
    setState(() {
      cartItems = cartItems;

      login = false;
      verigetirMalzeme();
    });
  }

  Future<void> verigetirgirilenler() async {
    yazdirmaDurumuAdisyon = "";
    yazdirmaDurumuMutfak = "";

    var cartItems = await getCardItemGetirId(masaid);

    setState(() {
      cartItems = cartItems;

      login = false;
      verigetirMalzeme();
    });
  }

  Future<void> verigetirMalzeme() async {
    kategoriFunc(foodCategoriItems[currentIndex].kodu!);

    setState(() {
      logindetails = false;
    });
  }

  // Arama Fonksiyonu
  void searchFunc(String value) {
    if (value == "") {
      foodItemsS = foodItems;
    } else {
      foodItemsS = [];

      for (var people in Settings.getFoodItemAll()) {
        if (people.adi!.toLowerCase().trim().contains(value)) {
          if (!foodItemsS.contains(people)) {
            foodItemsS.add(people);
            setState(() {});
          }
        }
      }
    }
  }

  // Arama Fonksiyonu
  void kategoriFunc(String value) {
    if (value == "") {
      foodItemsS = foodItems;
    } else {
      foodItemsS = [];

      for (var people in Settings.getFoodItemAll()) {
        if (people.kategori!.contains(value)) {
          if (!foodItemsS.contains(people)) {
            foodItemsS.add(people);
            setState(() {});
          }
        }
      }
    }
  }

  // Yeni Servisten Çekmek İçin

  String? img, name;
  int drawerCount = 0;
  int currentIndex = 0;
  String masaadi = "";
  int masaid = 0;

  final PageController _pageController = PageController();

  bool isOrderPlaced = false;

  late Dialog dialog;
  String aktifMiktarStr = "1.00";
  double aktifMiktar = 1;

  void openAlertYeni(
    BuildContext context,
    String malzemeAdi,
    int malzemeId,
    String secenek1,
    String secenek2,
    String secenek3,
    String secenek4,
    String secenek5,
    String secenek6,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return MyDialog(
          adi: malzemeAdi,
          malzemeId: malzemeId,
          masaid: masaid,
          secenek1: secenek1,
          secenek2: secenek2,
          secenek3: secenek3,
          secenek4: secenek4,
          secenek5: secenek5,
          secenek6: secenek6,
        );
      },
    );
  }

  Future<void> openAlertAciklama(
    BuildContext context,
    String malzemeAdi,
    int detayId,
  ) async {
    bool shouldUpdate = await showDialog(
      context: context,
      builder: (_) {
        return MyDialogAciklama(adi: malzemeAdi, detayid: detayId);
      },
    );

    if (shouldUpdate) {
      verigetirgirilenler();
    }

    if (shouldUpdate) {}
  }

  List<Widget> list = [
    const Tab(text: "Yeni ekle"),
    const Tab(text: 'Adisyon'),
    const Tab(text: 'İşlemler'),
  ];

  Future<void> _refreshlist() {
    setState(() {
      verigetirgirilenler();
    });

    return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: true,
                padding: const EdgeInsetsDirectional.all(0),
                largeTitle: FadeInUp(
                  duration: const Duration(milliseconds: 1700),
                  child: Text(masaadi),
                ),
              ),
            ],
            body: SizedBox(
              height: 500,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabcontroller,
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(child: siparisgirisi(context)),
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(child: girilensiparisadisyon(context)),
                  ),
                  SingleChildScrollView(child: _islemlerMenuYeni(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build2(BuildContext context) {
  //   var locale = AppLocalizations.of(context)!;

  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: DefaultTabController(
  //       length: 3,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           bottom: TabBar(
  //             physics: const NeverScrollableScrollPhysics(),
  //             controller: _tabcontroller,
  //             tabs: list,
  //           ),
  //           actions: [
  //             buildItemsGeriButon(context),
  //             buildItemsInMasaButton(context),
  //             Container(
  //               width: 190,
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 10,
  //                 horizontal: 4,
  //               ),
  //               child: TextFormField(
  //                 textAlignVertical: TextAlignVertical.center,
  //                 decoration: InputDecoration(
  //                   prefixIconColor: const Color(0x917a7b82),
  //                   prefixIcon: const Icon(Icons.search),
  //                   hintText: locale.searchItem,
  //                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
  //                   filled: true,
  //                   hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                     color: const Color(0x917a7b82),
  //                   ),
  //                   fillColor: Theme.of(context).scaffoldBackgroundColor,
  //                   border: OutlineInputBorder(
  //                     borderSide: BorderSide.none,
  //                     borderRadius: BorderRadius.circular(40),
  //                   ),
  //                 ),
  //                 onFieldSubmitted: (value) {
  //                   setState(() {
  //                     searchFunc(value);
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         body: TabBarView(
  //           physics: const NeverScrollableScrollPhysics(),
  //           controller: _tabcontroller,
  //           children: [
  //             Container(
  //               color: Colors.white,
  //               child: Center(child: siparisgirisi(context)),
  //             ),
  //             Container(
  //               color: Colors.white,
  //               child: Center(child: girilensiparisadisyon(context)),
  //             ),
  //             SingleChildScrollView(child: _islemlerMenuYeni(context)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildPage() {
    if (logindetails) {
      return const Center(child: CupertinoActivityIndicator(radius: 20.0));
    }

    // MALZEME KALEMLERİ
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 3, bottom: 3, top: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 27, 119, 73), // Set border color
          width: 1.0,
        ), // Set border width
        borderRadius: const BorderRadius.all(
          Radius.circular(2.0),
        ), // Set rounded corner radius
        // Make rounded corner of border
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsetsDirectional.only(
          top: 10,
          bottom: 10,
          start: 1,
          end: 3,
        ),
        itemCount: foodItemsS.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 5,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.white : Colors.white,
              border: Border.all(
                color: Colors.green, // Set border color
                width: 1.0,
              ), // Set border width
              borderRadius: const BorderRadius.all(
                Radius.circular(2.0),
              ), // Set rounded corner radius
              // Make rounded corner of border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 22,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        foodItemsS[index].isSelected =
                            !foodItemsS[index].isSelected;
                        //itemSelected = true;
                      });

                      if (foodItemsS[index].fiyatd! > 0) {
                        openAlertYeni(
                          context,
                          foodItemsS[index].adi!,
                          foodItemsS[index].id!,
                          foodItemsS[index].secenek1 == null
                              ? ""
                              : foodItemsS[index].secenek1!,
                          foodItemsS[index].secenek2 == null
                              ? ""
                              : foodItemsS[index].secenek2!,
                          foodItemsS[index].secenek3 == null
                              ? ""
                              : foodItemsS[index].secenek3!,
                          foodItemsS[index].secenek4 == null
                              ? ""
                              : foodItemsS[index].secenek4!,
                          foodItemsS[index].secenek5 == null
                              ? ""
                              : foodItemsS[index].secenek5!,
                          foodItemsS[index].secenek6 == null
                              ? ""
                              : foodItemsS[index].secenek6!,
                        );

                        verigetirgirilenler();
                      } else {
                        CuperAlert.show(
                          context: this.context,
                          destructive: true,
                          title: 'Hata',
                          content: 'Fiyat Sıfır Olan Ürün Satılamaz!',
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          child: Opacity(
                            opacity: 0.6,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          start: 5,
                          top: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    73,
                                    143,
                                    108,
                                  ),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      73,
                                      143,
                                      108,
                                    ), // Set border color
                                    width: 1.0,
                                  ), // Set border width
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ), // Set rounded corner radius
                                  // Make rounded corner of border
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  '${foodItemsS[index].kategori} ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                                foodItemsS[index].adi!,
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          end: 12,
                          top: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${Utils.format.format(foodItemsS[index].fiyatd)} TL',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  CustomButton buildItemsInMasaButton(BuildContext context) {
    return CustomButton(
      onTap: () {
        setState(() {});
      },
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(masaadi, style: Theme.of(context).textTheme.bodyMedium),
      bgColor: Colors.green[600],
    );
  }

  CustomButton buildItemsGeriButon(BuildContext context) {
    return CustomButton(
      onTap: () {
        setState(() {
          setState(() {
            adisyonMutfakYaz(masaid);
          });

          Navigator.pushNamed(
            context,
            PageRoutes.tableSelectionPage,
            arguments: {
              'garsonId': Settings.getGarsonId(),
              'garsonadi': Settings.getGarsonAdi(),
            },
          );
        });
      },
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(
        'Masalara Dön',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      bgColor: Colors.blue[600],
    );
  }

  Container siparisgirisi(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: foodCategoriItems.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 1);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      logindetails = true;
                      verigetirMalzeme();
                      // katregoriye göre malzeme listesini yenile
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.green[100]
                              : Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: currentIndex == index
                                  ? Colors.green
                                  : Colors.white,
                            ),
                            left: BorderSide(
                              color: currentIndex == index
                                  ? Colors.green
                                  : Colors.white,
                            ),
                            right: BorderSide(
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.white,
                            ),
                            bottom: BorderSide(
                              color: currentIndex == index
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                          // Set rounded corner radius
                          // Make rounded corner of border
                        ),
                        child: Text(
                          foodCategoriItems[index].adi!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [buildPage()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  RefreshIndicator girilensiparisadisyon(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: 0,
      color: Colors.white,
      backgroundColor: const Color.fromARGB(255, 6, 174, 204),
      onRefresh: _refreshlist,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Sipariş Girilen Malzemeler Yeni
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemCount: cartItems.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              return Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  //dismissible: DismissiblePane(onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (_) {
                        deleteSiparis(cartItems[index].id!);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Sil',
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        openAlertAciklama(
                          context,
                          cartItems[index].adi!,
                          cartItems[index].id!,
                        );
                        verigetirgirilenler();
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.description,
                      label: 'Açıklama',
                    ),
                  ],
                ),

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 2,
                  ),
                  title: Row(
                    children: [
                      Text(
                        cartItems[index].miktar.toString(),
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                      ),
                      const SizedBox(width: 5),
                      const Text('X'),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 220,
                        child: Text(
                          ('${cartItems[index].adi!}                             ')
                              .substring(0, 30),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            ' ${Utils.format.format(cartItems[index].genel!)} TL',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle:
                      cartItems[index].ozellik1!.isEmpty &&
                          cartItems[index].secenek!.isEmpty
                      ? null
                      : Column(
                          children: [
                            (cartItems[index].secenek != null &&
                                    cartItems[index].secenek!.isNotEmpty &&
                                    cartItems[index].secenek!.length > 1)
                                ? Row(
                                    children: [
                                      Text(
                                        '  -> ${cartItems[index].secenek!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.blue[900],
                                            ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),

                            // Özellik 1
                            (cartItems[index].ozellik1 != null &&
                                    cartItems[index].ozellik1!.isNotEmpty)
                                ? Row(
                                    children: [
                                      Text(
                                        '  -> ${cartItems[index].ozellik1!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.green[800],
                                            ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            // Özellik 2
                            (cartItems[index].ozellik2 != null &&
                                    cartItems[index].ozellik2!.isNotEmpty)
                                ? Row(
                                    children: [
                                      Text(
                                        '  -> ${cartItems[index].ozellik2!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.green[800],
                                            ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            // Özellik 3
                            (cartItems[index].ozellik3 != null &&
                                    cartItems[index].ozellik3!.isNotEmpty)
                                ? Row(
                                    children: [
                                      Text(
                                        '  -> ${cartItems[index].ozellik3!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.green[800],
                                            ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                ),
              );
            },
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  'Toplamlar',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: Text(
                  'Kdv Dahil  : ${toplamgenel()}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 010.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  '',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: Text(
                  'Vergi  : ${toplamvergi()}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> deleteSiparis(int id) async {
    bool stringFuture = false;

    try {
      stringFuture = await deleteSiparisAdisyon(id);

      if (stringFuture) {
        verigetirgirilenler();
      } else {
        if (mounted) {
          CuperAlert.show(
            context: context,
            destructive: true,
            title: 'Hata',
            content: 'Silme Hatası!\nMutfak veya Bar a Yazılmış!',
          );
          snackBar('hata Oluştu');
        }
      }
    } catch (error) {
      if (mounted) {
        snackBar('hata Oluştu : $error');
      }
    }

    return stringFuture;
  }

  late String yazdirmaDurumuAdisyon = "";
  late String yazdirmaDurumuMutfak = "";

  Future<bool> adisyonYaz(int id) async {
    yazdirmaDurumuAdisyon = "";

    bool stringFuture = false;
    try {
      stringFuture = await printSiparisAdisyon(id);
      if (stringFuture == false) {
        setState(() {
          yazdirmaDurumuAdisyon = "Daha Önce Yazılmış!";
        });
      } else {
        setState(() {
          yazdirmaDurumuAdisyon = "Adisyon Yazıldı.";
        });
      }
    } catch (error) {
      if (mounted) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Adisyon Yazma Hatası!\n$error',
        );
      }
    }

    return stringFuture;
  }

  Future<bool> adisyonMutfakYaz(int id) async {
    yazdirmaDurumuMutfak = "";

    bool stringFuture = false;
    try {
      stringFuture = await printSiparisMutfak(id);

      if (stringFuture == false) {
        setState(() {
          yazdirmaDurumuMutfak = "Daha Önce Yazılmış!";
        });
      } else {
        setState(() {
          yazdirmaDurumuMutfak = "Mutfak Bar Yazıldı.";
        });
      }
    } catch (error) {
      if (mounted) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Mutfak Bar Yazma Hatası!\n$error',
        );
      }
    }
    return stringFuture;
  }

  Future<bool> masaAktar(int id, String masaAdi) async {
    yazdirmaDurumuMutfak = "";

    bool stringFuture = false;

    Navigator.pop(context);

    try {
      Navigator.pushNamed(
        context,
        PageRoutes.masaaktar,
        arguments: {'masaid': id, 'masaadi': masaAdi},
      );
    } catch (error) {
      if (mounted) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Masa Aktarma Hatası!\n$error',
        );
      }
    }
    return stringFuture;
  }

  String toplamgenel() {
    double toplam = 0;

    for (var e in cartItems) {
      toplam += (e.fiyatd! * e.miktar);
    }

    return Utils.format.format(toplam);
  }

  String toplamvergi() {
    double toplam = 0;

    return Utils.format.format(toplam);
  }

  Widget _islemlerMenuYeni(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: CupertinoFormSection(
        header: const Text("Seçenekler"),
        margin: const EdgeInsets.only(right: 15, left: 15, bottom: 700, top: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        children: <Widget>[
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Icon(
                CupertinoIcons.printer,
                color: Color.fromARGB(255, 223, 149, 0),
                size: 32,
              ),
              baslik: Text(
                "Adisyon Yaz",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              altbaslik: Text(
                yazdirmaDurumuAdisyon,
                style: TextStyle(
                  color: yazdirmaDurumuAdisyon == "Daha Önce Yazılmış!"
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              onpress: () {
                adisyonYaz(masaid);
              },
            ),
          ),
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Icon(
                CupertinoIcons.printer_fill,
                color: Colors.green,
                size: 32,
              ),
              baslik: Text(
                "Mutfaga Yaz",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              altbaslik: Text(
                yazdirmaDurumuAdisyon,
                style: TextStyle(
                  color: yazdirmaDurumuAdisyon == "Daha Önce Yazılmış!"
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              onpress: () {
                adisyonMutfakYaz(masaid);
              },
            ),
          ),
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Icon(
                CupertinoIcons.arrow_right_arrow_left_square_fill,
                color: Colors.blue,
                size: 32,
              ),
              baslik: Text(
                "Masa Aktar",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              onpress: () {
                masaAktar(masaid, masaadi);
              },
            ),
          ),
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Text(
                "₺",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: 'BakbakOne',
                ),
              ),
              baslik: Text(
                "Tahsilat",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              onpress: () {},
            ),
          ),
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Icon(
                CupertinoIcons.arrow_right_arrow_left_square,
                color: Colors.blue,
                size: 32,
              ),
              baslik: Text(
                "Fişten Hareket Aktar",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              altbaslik: const Text(
                "Masa içi ürünü başka masaya aktar",
                style: TextStyle(color: Colors.grey),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              onpress: () {},
            ),
          ),
          CupertinoFormRow(
            child: ListeMenu(
              ikon: const Icon(
                CupertinoIcons.mail,
                color: Colors.blue,
                size: 32,
              ),
              baslik: Text(
                "TSM Gönder",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              altbaslik: const Text(
                "Pos cihazına gönder",
                style: TextStyle(color: Colors.grey),
              ),
              komponet: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 16,
              ),
              onpress: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ListView _islemlerMenuYeni2(BuildContext context) {
  //   final Color colorr = const Color.fromRGBO(70, 103, 48, 1);
  //   List<MenuItem> menuItem = <MenuItem>[
  //     MenuItem(
  //       icon: Icons.print,
  //       color: colorr,
  //       title: 'Adisyon Yaz$yazdirmaDurumuAdisyon',
  //       subtitle: '',
  //       disabled: false,
  //       child: const SizedBox(width: 0),

  //       // menüyü aç
  //     ),
  //     MenuItem(
  //       icon: Icons.print,
  //       color: colorr,
  //       title: 'Mutfağa Yaz$yazdirmaDurumuMutfak',
  //       subtitle: '',
  //       disabled: false,
  //       child: const SizedBox(width: 0),

  //       // menüyü aç
  //     ),
  //     MenuItem(
  //       icon: Icons.event,
  //       color: colorr,
  //       title: 'Masa Aktar',
  //       subtitle: '',
  //       disabled: false,
  //       child: const SizedBox(width: 0), // menüyü aç
  //     ),
  //     MenuItem(
  //       icon: Icons.money,
  //       color: colorr,
  //       title: 'Tahsilat',
  //       subtitle: '',
  //       disabled: false,
  //       child: const SizedBox(width: 0), // menüyü aç
  //     ),
  //   ];

  //   return ListView(
  //     physics: const BouncingScrollPhysics(),
  //     children: [
  //       ListView.separated(
  //         physics: const NeverScrollableScrollPhysics(),
  //         padding: const EdgeInsets.only(bottom: 10),
  //         itemCount: menuItem.length,
  //         shrinkWrap: true,
  //         separatorBuilder: (context, index) {
  //           return const Divider();
  //         },
  //         itemBuilder: (context, index) {
  //           return Column(
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   if (index == 0) {
  //                     // Adisyon Yaz
  //                     setState(() {
  //                       adisyonYaz(masaid);
  //                     });
  //                   } else if (index == 1) {
  //                     // Mutfağa Yaz
  //                     setState(() {
  //                       adisyonMutfakYaz(masaid);
  //                     });
  //                   } else if (index == 2) {
  //                     // MasaAktar
  //                     setState(() {
  //                       masaAktar(masaid, masaadi);
  //                     });
  //                   }
  //                 },
  //                 child: ListTile(
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     vertical: 2,
  //                     horizontal: 2,
  //                   ),
  //                   leading: FadedScaleAnimation(
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(20),
  //                       child: FadedScaleAnimation(
  //                         child: Icon(
  //                           menuItem[index].icon,
  //                           size: 50,
  //                           color: Colors.green,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   title: Text(
  //                     menuItem[index].title,
  //                     maxLines: 3,
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.justify,
  //                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   subtitle: Text(menuItem[index].subtitle),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }
}

// Girilen Siparişlerde
// Sağa Çekme Sola Çekme İşlemleri

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  const SlideMenu({super.key, required this.child, required this.menuItems});

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here the end field will determine the size of buttons which will appear after sliding
    //If you need to appear them at the beginning, you need to change to "+" Offset coordinates (0.2, 0.0)
    final animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.2, 0.0),
    ).animate(CurveTween(curve: Curves.decelerate).animate(_controller));

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          //Here we set value of Animation controller depending on our finger move in horizontal axis
          //If you want to slide to the right, change "-" to "+"
          _controller.value -=
              (data.primaryDelta! / (context.size!.width * 0.3));
        });
      },
      onHorizontalDragEnd: (data) {
        //To change slide direction, change to data.primaryVelocity! < -1500
        if (data.primaryVelocity! > 1500) {
          _controller.animateTo(
            .0,
          ); //close menu on fast swipe in the right direction
        }
        //To change slide direction, change to data.primaryVelocity! > 1500
        else if (_controller.value >= .5 || data.primaryVelocity! < -1500) {
          _controller.animateTo(
            1.0,
          ); // fully open if dragged a lot to left or on fast swipe to left
        } else {
          // close if none of above
          _controller.animateTo(.0);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              SlideTransition(position: animation, child: widget.child),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  //To change slide direction to right, replace the right parameter with left:
                  return Positioned(
                    right: .0,
                    top: .0,
                    bottom: .0,
                    width: constraint.maxWidth * animation.value.dx * -1,
                    child: Row(
                      children: widget.menuItems.map((child) {
                        return Expanded(child: child);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// Örnek

/* 
 */
// // Sağa Çekme Sola Çekme İşlemleri
