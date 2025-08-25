import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../components/arama_kutusu.dart';
import '../../components/cuper_alert.dart';
import '../../components/cuper_form_2.dart';
import '../../components/liste_menu.dart';
import '../../config/config.dart';
import '../../config/settings.dart';
import '../../dataGet/card_item_model.dart';
import '../../dataGet/food_categori_model.dart';
import '../../dataGet/food_item_model.dart';
import '../../dataPost/adisyon_model.dart';
import '../../models/food_item_info.dart';
import '../adisyon/module/adisyon_notifier.dart';
import '../dialog_aciklama_siparis.dart';
import 'adisyon_miktar.dart';

class Adisyon extends ConsumerStatefulWidget {
  final int masaid;
  final String masaadi;
  const Adisyon({super.key, required this.masaid, required this.masaadi});

  @override
  ConsumerState<Adisyon> createState() => _AdisyonState();
}

class _AdisyonState extends ConsumerState<Adisyon> {
  bool login = true, logindetails = true, favori = false;
  int pageindex = 0;
  int masaid = 0;
  String masaadi = '';
  String katname = 'Tüm Ürünler';
  String? img, name;
  int drawerCount = 0;
  int currentIndex = 0;
  int pageIndex = 0;

  late String yazdirmaDurumuAdisyon = "";
  late String yazdirmaDurumuMutfak = "";

  late List<CardItemModel> cartItems = []; // Girilen Siparişler
  late List<FoodItemModel> foodItems = []; // Tüm Ürünler
  late List<FoodItemModel> foodItemsS = []; // Tüm Ürünler Arama Sonucu
  late List<FoodCategoriModel> foodCategoriItems = [];

  @override
  void initState() {
    super.initState();

    masaid = widget.masaid;
    masaadi = widget.masaadi;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await verigetir();
      ref.read(adisyonNotifierProvider.notifier).getAdisyonList(masaid);
    });
  }

  Future<void> verigetir() async {
    var katagoriler = Settings.getFoodCategoriItems();
    var cartItemleri = await getCardItemGetirId(masaid);
    foodCategoriItems = katagoriler;
    cartItems = cartItemleri;
    kategoriFunc(foodCategoriItems[currentIndex].kodu!);

    setState(() {
      logindetails = false;
      login = false;
    });
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

  Future<void> verigetirgirilenler() async {
    yazdirmaDurumuAdisyon = "";
    yazdirmaDurumuMutfak = "";

    var cartItemx = await getCardItemGetirId(masaid);

    setState(() {
      cartItems = cartItemx;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: (value) {
            pageIndex = value;
            setState(() {});
          },
          height: 60,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus_circle_fill),
              label: 'Yeni Sipariş',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: 'Adisyon',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_bullet),
              label: 'İşlemler',
            ),
          ],
        ),
        body: (login)
            ? const Center(child: CupertinoActivityIndicator(radius: 15.0))
            : Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 200,
                          child: CupertinoButton(
                            onPressed: () {
                              adisyonMutfakYaz(masaid);
                              Navigator.pop(context);
                            },
                            minimumSize: Size(20, 20),
                            child: const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.back,
                                  color: Color.fromARGB(255, 92, 20, 150),
                                  size: 28,
                                ),
                                Expanded(
                                  child: Text(
                                    "Masalara Dön",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 92, 20, 150),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Text(
                              masaadi,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'BakbakOne',
                              ),
                            ),
                            const Text("Adisyon Numarası"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: selectpage(context)),
                ],
              ),
      ),
    );
  }

  Widget selectpage(BuildContext context) {
    switch (pageIndex) {
      case 0:
        {
          return yenipage(context);
        }
      case 1:
        {
          return adspage(context);
        }
      case 2:
        {
          return islempage(context);
        }
      default:
        {
          return yenipage(context);
        }
    }
  }

  Widget yenipage(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 250),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Cuperform2(
                  ikon: Icon(
                    favori ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    color: favori ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  baslik: const Text("Favoriler"),
                  onpress: () {
                    favori = !favori;
                    //FAVORİLERİ ÇAGIR & İpTal et
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: 500,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    color: const Color.fromARGB(255, 92, 20, 150),
                    child: const Text(
                      "Kategoriler",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: const Border(
                        right: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Slidable(
                          closeOnScroll: true,
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                autoClose: true,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  17,
                                  108,
                                  255,
                                ),
                                label: '+',
                                onPressed: (BuildContext context) async {
                                  //Sık kullanılanlara ekle
                                },
                              ),
                            ],
                          ),
                          child: ListeMenu(
                            onpress: () {
                              var secili = foodCategoriItems
                                  .where((e) => e.selected == true)
                                  .toList();
                              if (secili.isNotEmpty) {
                                for (int i = 0; i < secili.length; i++) {
                                  secili[i].selected = false;
                                }
                              }

                              katname = foodCategoriItems[index].adi.toString();

                              foodCategoriItems[index].selected = true;

                              setState(() {
                                currentIndex = index;
                                logindetails = true;
                                verigetirMalzeme();
                                // katregoriye göre malzeme listesini yenile
                              });
                            },
                            onlongpress: () {},
                            selectedcolor: (foodCategoriItems[index].selected!)
                                ? const Color.fromARGB(160, 91, 20, 150)
                                : Colors.transparent,
                            baslik: Text(
                              foodCategoriItems[index].adi.toString(),
                              style: TextStyle(
                                color: !(foodCategoriItems[index].selected!)
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(color: Colors.grey);
                      },
                      itemCount: foodCategoriItems.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Cuperform2(
                  baslik: SearchTextField(
                    fieldValue: (String value) {
                      searchFunc(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    color: const Color.fromARGB(255, 92, 20, 150),
                    child: Text(
                      katname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return Slidable(
                        closeOnScroll: true,
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              autoClose: true,
                              backgroundColor: const Color.fromARGB(
                                255,
                                17,
                                81,
                                255,
                              ),
                              label: 'Fav',
                              onPressed: (BuildContext context) async {},
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey, width: 1.0),
                          ),
                          child: Cuperform2(
                            onpress: () async {
                              setState(() {
                                foodItemsS[index].isSelected =
                                    !foodItemsS[index].isSelected;
                                //itemSelected = true;
                              });

                              if (foodItemsS[index].fiyatd! > 0) {
                                await Config.gotopage(
                                  context,
                                  AdsMiktar(
                                    masaid: masaid,
                                    masaadi: masaadi,
                                    urunid: foodItemsS[index].id!,
                                    urunadi: foodItemsS[index].adi!,
                                    aciklama: '',
                                    mevcut: 1,
                                    fruitliste: createFruit(index, false),
                                    adisyon: false,
                                    onOrderAdded: () {
                                      // Sipariş eklendikten sonra listeyi yenile
                                      verigetirgirilenler();
                                    },
                                  ),
                                  "",
                                  "Miktar",
                                  yarim: true,
                                  baslik: foodItemsS[index].adi ?? 'Ürün',
                                );
                              } else {
                                CuperAlert.show(
                                  context: this.context,
                                  destructive: true,
                                  title: 'Hata',
                                  content: 'Fiyat Sıfır Olan Ürün Satılamaz!',
                                );
                              }
                            },
                            onlongpress: () {},
                            baslik: Text(
                              foodItemsS[index].adi.toString(),
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            komponet: Text(
                              "${Config.formatter.format(foodItemsS[index].fiyatd)} ₺",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.transparent);
                    },
                    itemCount: foodItemsS.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget adspage(BuildContext context) {
    final cartItems = ref.watch(adisyonNotifierProvider).adisyonList ?? [];
    return Column(
      children: [
        const Text(
          "Adisyon",
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        const Divider(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Listeyi yenile
              await ref
                  .read(adisyonNotifierProvider.notifier)
                  .refreshAdisyonList(masaid);
            },
            child: ListView(
              padding: const EdgeInsets.all(15),
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
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            autoClose: true,
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
                      child: Cuperform2(
                        onpress: () async {
                          //ADİSYON GÜNCELLEME İŞLEVİ

                          // setState(() {
                          //   foodItemsS[index].isSelected =
                          //       !foodItemsS[index].isSelected;
                          //   //itemSelected = true;
                          // });

                          // if (foodItemsS[index].fiyatd! > 0) {
                          //   await Config.gotopage(
                          //       context,
                          //       AdsMiktar(
                          //         masaid: masaid,
                          //         masaadi: masaadi,
                          //         urunid: cartItems[index].id!,
                          //         urunadi: cartItems[index].adi!,
                          //         aciklama: cartItems[index].ozellik1!,
                          //         mevcut: cartItems[index].miktar,
                          //         fruitliste: createFruit(index, true),
                          //         adisyon: true,
                          //       ),
                          //       "",
                          //       "Miktar",
                          //       yarim: true,
                          //       baslik: foodItemsS[index].adi ?? 'Ürün');

                          //   verigetirgirilenler();
                          // } else {
                          //   CuperAlert.show(
                          //     context: this.context,
                          //     destructive: true,
                          //     title: 'Hata',
                          //     content: 'Fiyat Sıfır Olan Ürün Satılamaz!',
                          //   );
                          // }
                        },
                        ikon: Text(
                          "${cartItems[index].miktar.toString()} X",
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontSize: 14, color: Colors.red),
                        ),
                        baslik: Text(
                          cartItems[index].adi!,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(fontSize: 12),
                        ),
                        komponet: Text(
                          Config.formatter.format(cartItems[index].genel),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(fontSize: 12),
                        ),
                        altbaslik:
                            cartItems[index].ozellik1!.isEmpty &&
                                cartItems[index].secenek!.isEmpty
                            ? null
                            : Column(
                                children: [
                                  (cartItems[index].secenek != null &&
                                          cartItems[index]
                                              .secenek!
                                              .isNotEmpty &&
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
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: CupertinoButton.filled(
                    child: const Text(
                      "Adisyon Yaz",
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      if (yazdirmaDurumuAdisyon == "Daha Önce Yazılmış!") {
                        if (!context.mounted) return;
                        Config.showsnack(
                          context,
                          'Daha Önce Yazılmış!',
                          color: const Color.fromARGB(255, 244, 67, 54),
                        );
                      } else {
                        var sonuc = await adisyonYaz(masaid);

                        if (sonuc) {
                          if (!context.mounted) return;
                          Config.showsnack(
                            context,
                            'Adisyon Yazıldı',
                            color: const Color.fromARGB(255, 29, 157, 25),
                          );
                        } else {
                          if (!context.mounted) return;
                          Config.showsnack(
                            context,
                            'Yazdırma Hatası',
                            color: const Color.fromARGB(255, 244, 67, 54),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: CupertinoButton.filled(
                  child: const Text(
                    "Mutfağa Yaz",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () async {
                    if (yazdirmaDurumuMutfak == "Daha Önce Yazılmış!") {
                      if (!context.mounted) return;
                      Config.showsnack(
                        context,
                        'Daha Önce Yazılmış!',
                        color: const Color.fromARGB(255, 244, 67, 54),
                      );
                    } else {
                      var sonuc = await adisyonMutfakYaz(masaid);

                      if (sonuc) {
                        if (!context.mounted) return;
                        Config.showsnack(
                          context,
                          'Mutfak Yazıldı',
                          color: const Color.fromARGB(255, 29, 157, 25),
                        );
                      } else {
                        if (!context.mounted) return;
                        Config.showsnack(
                          context,
                          'Yazdırma Hatası',
                          color: const Color.fromARGB(255, 244, 67, 54),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        // ListeMenu(
        //   ikon: const Icon(
        //     CupertinoIcons.circle_fill,
        //     color: Colors.grey,
        //     size: 12,
        //   ),
        //   baslik: const Text("Toplam : "),
        //   komponet: Text(
        //     toplamgenel(),
        //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //           fontSize: 18,
        //           fontWeight: FontWeight.w700,
        //           color: Colors.green.shade800,
        //           letterSpacing: 1.4,
        //         ),
        //   ),
        // ),
        // ListeMenu(
        //   ikon: const Icon(
        //     CupertinoIcons.circle_fill,
        //     color: Colors.grey,
        //     size: 12,
        //   ),
        //   baslik: const Text("Vergi : "),
        //   komponet: Text(
        //     toplamvergi(),
        //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //           fontSize: 18,
        //           fontWeight: FontWeight.w700,
        //           color: Colors.green.shade800,
        //           letterSpacing: 1.4,
        //         ),
        //   ),
        // ),
        ListeMenu(
          ikon: const Icon(
            CupertinoIcons.circle_fill,
            color: Colors.grey,
            size: 12,
          ),
          baslik: const Text("Genel Toplam : "),
          komponet: Text(
            totali(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade800,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  String toplamgenel() {
    double toplam = 0;

    for (var e in cartItems) {
      toplam += (e.fiyatd! * e.miktar);
    }

    double vergi = 0;

    vergi = toplam * 0.2;

    toplam = toplam - vergi;

    return Config.formatter.format(toplam);
  }

  String totali() {
    double total = 0;

    for (var e in cartItems) {
      total += (e.fiyatd! * e.miktar);
    }

    return Config.formatter.format(total);
  }

  String toplamvergi() {
    double toplam = 0;

    for (var e in cartItems) {
      toplam += (e.fiyatd! * e.miktar);
    }

    double vergi = 0;

    vergi = toplam * 0.2;

    return Config.formatter.format(vergi);
  }

  Widget islempage(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: SingleChildScrollView(
        child: CupertinoFormSection(
          header: const Text("Seçenekler"),
          margin: const EdgeInsets.only(
            right: 15,
            left: 15,
            bottom: 500,
            top: 0,
          ),
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
                  if (yazdirmaDurumuAdisyon == "Daha Önce Yazılmış!") {
                    if (!context.mounted) return;
                    Config.showsnack(
                      context,
                      'Daha Önce Yazılmış!',
                      color: const Color.fromARGB(255, 244, 67, 54),
                    );
                    return;
                  }
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
                  "Mutfağa Yaz",
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
                  if (yazdirmaDurumuMutfak == "Daha Önce Yazılmış!") {
                    if (!context.mounted) return;
                    Config.showsnack(
                      context,
                      'Daha Önce Yazılmış!',
                      color: const Color.fromARGB(255, 244, 67, 54),
                    );
                    return;
                  }
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
      ),
    );
  }

  //Adisyondan gelmiyorsa seçenek listesini oluşturur
  //Adisyondan geliyorsa food index bulur secenek belirle seçili olanı seçer
  List<SecenekModel> createFruit(int index, bool adisyon) {
    List<SecenekModel> seclistesi = [];
    try {
      if (!adisyon) {
        if (foodItemsS[index].secenek1 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek1!, false));
        }

        if (foodItemsS[index].secenek2 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek2!, false));
        }

        if (foodItemsS[index].secenek3 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek3!, false));
        }

        if (foodItemsS[index].secenek4 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek4!, false));
        }

        if (foodItemsS[index].secenek5 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek5!, false));
        }

        if (foodItemsS[index].secenek6 != "") {
          seclistesi.add(SecenekModel(foodItemsS[index].secenek6!, false));
        }
      } else {
        //FOOD listesindeki id ile adisyon listesindeki id aynı degil mi ?????

        int findex = foodItemsS.indexWhere((e) => e.id == cartItems[index].id);

        if (foodItemsS[findex].secenek1 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek1!,
              cartItems[index].secenek == foodItemsS[findex].secenek1!
                  ? true
                  : false,
            ),
          );
        }

        if (foodItemsS[findex].secenek2 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek2!,
              cartItems[index].secenek == foodItemsS[findex].secenek2!
                  ? true
                  : false,
            ),
          );
        }

        if (foodItemsS[findex].secenek3 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek3!,
              cartItems[index].secenek == foodItemsS[findex].secenek3!
                  ? true
                  : false,
            ),
          );
        }

        if (foodItemsS[findex].secenek4 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek4!,
              cartItems[index].secenek == foodItemsS[findex].secenek4!
                  ? true
                  : false,
            ),
          );
        }

        if (foodItemsS[findex].secenek5 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek5!,
              cartItems[index].secenek == foodItemsS[findex].secenek5!
                  ? true
                  : false,
            ),
          );
        }

        if (foodItemsS[findex].secenek6 != "") {
          seclistesi.add(
            SecenekModel(
              foodItemsS[findex].secenek6!,
              cartItems[index].secenek == foodItemsS[findex].secenek6!
                  ? true
                  : false,
            ),
          );
        }
      }

      return seclistesi;
    } catch (e) {
      return seclistesi;
    }
  }

  Future<bool> adisyonMutfakYaz(int id) async {
    yazdirmaDurumuMutfak = "";

    bool stringFuture = false;
    try {
      stringFuture = await printSiparisMutfak(id);

      if (stringFuture == false) {
        yazdirmaDurumuMutfak = "Daha Önce Yazılmış!";
      } else {
        yazdirmaDurumuMutfak = "Mutfak Bar Yazıldı.";
      }
      setState(() {});
    } catch (error) {
      if (!mounted) return false;
      CuperAlert.show(
        context: context,
        destructive: true,
        title: 'Hata',
        content: 'Mutfak Bar Yazma Hatası!\n$error',
      );
    }
    return stringFuture;
  }

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
      if (!mounted) return false;
      CuperAlert.show(
        context: context,
        destructive: true,
        title: 'Hata',
        content: 'Adisyon Yazma Hatası!\n$error',
      );
    }

    return stringFuture;
  }

  Future<bool> masaAktar(int id, String masaAdi) async {
    yazdirmaDurumuMutfak = "";

    bool stringFuture = false;

    Navigator.pop(context);

    try {
      // Navigator.pushNamed(context, PageRoutes.masaaktar, arguments: {
      //   'masaid': id,
      //   'masaadi': MasaAdi,
      // });
    } catch (error) {
      if (!mounted) return false;
      CuperAlert.show(
        context: context,
        destructive: true,
        title: 'Hata',
        content: 'Masa Aktarma Hatası!\n$error',
      );
    }
    return stringFuture;
  }

  Future<bool> deleteSiparis(int id) async {
    bool stringFuture = false;

    try {
      await ref
          .read(adisyonNotifierProvider.notifier)
          .deleteAdisyon(id, masaid);

      if (ref.read(adisyonNotifierProvider).isSuccess == true) {
        if (!mounted) return false;
        Config.showsnack(
          context,
          'Silindi',
          color: const Color.fromARGB(255, 244, 67, 54),
        );
      } else {
        if (!mounted) return false;
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Silme Hatası!\nMutfak veya Bar a Yazılmış!',
        );
        Config.showsnack(context, 'Bir hata oluştu');
      }
    } catch (error) {
      if (!mounted) return false;
      Config.showsnack(context, 'Bir hata oluştu$error');
    }

    return stringFuture;
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
}
