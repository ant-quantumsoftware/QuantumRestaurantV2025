import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quantum_restaurant/core/extensions/context_extension.dart';
import 'package:quantum_restaurant/features/presentation/widgets/check_line_card.dart';

import '../../../../core/config/config.dart';
import '../../../../core/config/settings.dart';
import '../../../data/models/dataGet/card_item_model.dart';
import '../../../data/models/dataGet/food_categori_model.dart';
import '../../../data/models/dataGet/food_item_model.dart';
import '../../../data/models/dataPost/adisyon_model.dart';
import '../../../data/models/dataPost/login_model.dart';
import '../../../data/models/food_item_info.dart';
import '../../components/arama_kutusu.dart';
import '../../components/cuper_alert.dart';
import '../../components/cuper_form_2.dart';
import '../../components/liste_menu.dart';
import '../../module/adisyon_notifier.dart';
import '../../widgets/add_check_dialog.dart';
import '../order_description_dialog.dart';

class OrderListView extends ConsumerStatefulWidget {
  final int masaid;
  final String masaadi;
  const OrderListView({super.key, required this.masaid, required this.masaadi});

  @override
  ConsumerState<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<OrderListView> {
  bool login = true, logindetails = true, favori = false;
  int pageindex = 0;
  int tableId = 0;
  String tableName = '';
  String categoryName = 'Tüm Ürünler';
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

  List<BottomNavigationBarItem> getBottomNavigationItems(bool isAdmin) {
    if (isAdmin) {
      return [
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
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.plus_circle_fill),
          label: 'Yeni Sipariş',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_chart),
          label: 'Adisyon',
        ),
      ];
    }
  }

  @override
  void initState() {
    super.initState();

    tableId = widget.masaid;
    tableName = widget.masaadi;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await verigetir();
      ref.read(adisyonNotifierProvider.notifier).getAdisyonList(tableId);
    });
  }

  Future<void> verigetir() async {
    var kategoriler = Settings.getFoodCategoriItems();

    var cartItemleri = await getCardItemGetirId(tableId);
    foodCategoriItems = kategoriler;
    cartItems = cartItemleri;
    if (foodCategoriItems.isNotEmpty) {
      final safeIndex = currentIndex.clamp(0, foodCategoriItems.length - 1);
      currentIndex = safeIndex;
      kategoriFunc(foodCategoriItems[safeIndex].kodu ?? '');
    } else {
      foodItemsS = [];
    }

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

    var cartItemx = await getCardItemGetirId(tableId);

    setState(() {
      cartItems = cartItemx;

      login = false;
      verigetirMalzeme();
    });
  }

  Future<void> verigetirMalzeme() async {
    if (foodCategoriItems.isNotEmpty) {
      final safeIndex = currentIndex.clamp(0, foodCategoriItems.length - 1);
      currentIndex = safeIndex;
      kategoriFunc(foodCategoriItems[safeIndex].kodu ?? '');
    } else {
      foodItemsS = [];
    }

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
          items: getBottomNavigationItems(
            ref.watch(loginModelProvider)?.adminYetki ?? false,
          ),
        ),
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          elevation: 0,
          leadingWidth: 120,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 10),
            onPressed: () {
              adisyonMutfakYaz(tableId);
              Navigator.pop(context);
            },
            icon: Row(
              children: [
                Icon(
                  CupertinoIcons.back,
                  color: context.theme.hintColor,
                  size: 28,
                ),
                Expanded(
                  child: Text(
                    "Masalara Dön",
                    style: TextStyle(
                      color: context.theme.hintColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            tableName,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'BakbakOne',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10),
              onPressed: () async {
                await openAlertKisiSayisi(context, tableId, tableName);
              },
              icon: Row(
                children: [
                  Icon(Icons.person, color: context.theme.hintColor, size: 28),
                  const SizedBox(width: 4),
                  Text(
                    "Kişi Sayısı\nGüncelle",
                    style: TextStyle(
                      color: context.theme.hintColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
        body: (login)
            ? const Center(child: CupertinoActivityIndicator(radius: 15.0))
            : selectedPage(context),
      ),
    );
  }

  Widget selectedPage(BuildContext context) {
    switch (pageIndex) {
      case 0:
        {
          return _addPage(context);
        }
      case 1:
        {
          return _checkPage(context);
        }
      case 2:
        {
          return islempage(context);
        }
      default:
        {
          return _addPage(context);
        }
    }
  }

  Widget _addPage(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FadeInUp(
      duration: const Duration(milliseconds: 250),
      child: Column(
        children: [
          // Favori Butonu ve Arama Kutusu
          Row(
            children: [
              SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        favori = !favori;
                        // FAVORILERI cagirma ve iptal etme
                        setState(() {});
                      },
                      child: Ink(
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: favori
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.12)
                              : Theme.of(context).colorScheme.surfaceContainer,
                          border: Border.all(
                            color: favori
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                favori
                                    ? CupertinoIcons.star_fill
                                    : CupertinoIcons.star,
                                color: favori
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Favoriler",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Cuperform2(
                  baslik: SearchTextField(
                    fieldValue: (String value) {
                      searchFunc(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          // Kategori ve Alt Kategori Seçimi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.28),
                        width: 0.9,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.square_grid_2x2_fill,
                          color: scheme.onSurfaceVariant,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Kategoriler",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.24),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.tag_fill,
                          color: scheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            categoryName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Kategori Listesi ve Ürün Listesi
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      border: const Border(
                        right: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                    ),
                    child: _categoryList(),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(flex: 5, child: _itemList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemList() {
    final favoriteItems =
        ref.watch(adisyonNotifierProvider).favoriteItems ?? [];
    final activeItems = favori ? favoriteItems : foodItemsS;

    return activeItems.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: activeItems.length,

            itemBuilder: (context, index) {
              final item = activeItems[index];
              final isFavorite = favoriteItems.contains(item);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Slidable(
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
                        backgroundColor: isFavorite ? Colors.green : Colors.red,
                        label: 'Fav',
                        onPressed: (BuildContext context) async {
                          if (isFavorite) {
                            ref
                                .read(adisyonNotifierProvider.notifier)
                                .removeFavoriteItem(item);
                          } else {
                            ref
                                .read(adisyonNotifierProvider.notifier)
                                .addFavoriteItem(item);
                          }
                        },
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
                          item.isSelected = !(item.isSelected);
                          //itemSelected = true;
                        });

                        if ((item.fiyatd ?? 0) > 0) {
                          final sourceIndex = favori
                              ? foodItemsS.indexWhere((e) => e.id == item.id)
                              : index;

                          await Config.gotopage(
                            context,
                            AddCheckDialog(
                              masaid: tableId,
                              masaadi: tableName,
                              urunid: item.id ?? 0,
                              urunadi: item.adi ?? 'Ürün',
                              mevcut: 1,
                              fruitliste: sourceIndex >= 0
                                  ? createFruit(sourceIndex, false)
                                  : <SecenekModel>[],
                              adisyon: false,
                              onOrderAdded: () {
                                // Sipariş eklendikten sonra listeyi yenile
                                verigetirgirilenler();
                              },
                            ),
                            "",
                            "Miktar",
                            yarim: true,
                            baslik: item.adi ?? 'Ürün',
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
                        item.adi ?? '',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      komponet: Text(
                        "${Config.formatter.format(item.fiyatd)} ₺",
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              "Ürün bulunamadı",
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Widget _categoryList() {
    final scheme = Theme.of(context).colorScheme;
    return foodCategoriItems.isNotEmpty
        ? ListView.builder(
            itemCount: foodCategoriItems.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final foodCategoriItem = foodCategoriItems[index];
              return ListeMenu(
                onpress: () {
                  var secili = foodCategoriItems
                      .where((e) => e.selected == true)
                      .toList();
                  if (secili.isNotEmpty) {
                    for (int i = 0; i < secili.length; i++) {
                      secili[i].selected = false;
                    }
                  }

                  categoryName = foodCategoriItem.adi.toString();

                  foodCategoriItem.selected = true;

                  setState(() {
                    currentIndex = index;
                    logindetails = true;
                    verigetirMalzeme();
                    // katregoriye göre malzeme listesini yenile
                  });
                  if (foodCategoriItem.id == 0) {
                    categoryName = 'Tüm Ürünler';
                    foodItemsS = Settings.getFoodItemAll();
                    setState(() {
                      currentIndex = index;
                      logindetails = true;

                      // tüm ürünleri göster
                    });
                  }
                },
                selectedcolor: (foodCategoriItem.selected ?? false)
                    ? scheme.primary.withValues(alpha: 0.18)
                    : Colors.transparent,
                divider: true,
                baslik: Text(
                  foodCategoriItem.adi ?? "Kategori Adı Bulunamadı",
                  style: TextStyle(
                    color: foodCategoriItem.selected!
                        ? scheme.primary
                        : scheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )
        : Text(
            "Kategori bulunamadı",
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          );
  }

  Widget _checkPage(BuildContext context) {
    final cartItems = ref.watch(adisyonNotifierProvider).adisyonList ?? [];
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.doc_text_fill,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Adisyon Kalemleri',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cartItems.length} ürün',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Listeyi yenile
              await ref
                  .read(adisyonNotifierProvider.notifier)
                  .refreshAdisyonList(tableId);
            },
            child: cartItems.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 120),
                      Icon(
                        CupertinoIcons.doc_text_search,
                        size: 42,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bu masada henüz adisyon kalemi yok',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(15, 6, 15, 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return CheckLineCard(
                        onTap: () async {
                          final allItems = Settings.getFoodItemAll();
                          final sourceIndex = allItems.indexWhere(
                            (e) => e.id == cartItem.malzemeId,
                          );

                          await Config.gotopage(
                            context,
                            AddCheckDialog(
                              masaid: tableId,
                              masaadi: tableName,
                              urunid: cartItem.malzemeId ?? 0,
                              urunadi: cartItem.adi ?? 'Ürün',
                              mevcut: 1,
                              existingOrder: cartItem,
                              fruitliste: sourceIndex >= 0
                                  ? createFruit(sourceIndex, false)
                                  : <SecenekModel>[],
                              adisyon: true,

                              onOrderAdded: () {
                                // Sipariş eklendikten sonra listeyi yenile
                                verigetirgirilenler();
                              },
                            ),
                            "",
                            "Miktar",
                            yarim: true,
                            baslik: cartItem.adi ?? 'Ürün',
                          );
                        },
                        cartItem: cartItem,
                        onPressedDelete: (_) {
                          deleteSiparis(cartItem.id!);
                        },
                        onPressed: (_) {
                          openAlertAciklama(
                            context,
                            cartItem.adi!,
                            cartItem.id!,
                          );
                          verigetirgirilenler();
                        },
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  borderRadius: BorderRadius.circular(10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.printer, size: 16),
                      SizedBox(width: 6),
                      Text("Adisyon Yaz", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  onPressed: () async {
                    if (yazdirmaDurumuAdisyon == "Daha Önce Yazılmış!") {
                      if (!context.mounted) return;
                      context.showErrorNotification(
                        "Hata!",
                        "Daha Önce Yazılmış!",
                      );
                    } else {
                      var sonuc = await adisyonYaz(tableId);

                      if (sonuc) {
                        if (!context.mounted) return;
                        context.showSuccessNotification(
                          "Başarılı!",
                          "Adisyon Yazıldı",
                        );
                      } else {
                        if (!context.mounted) return;

                        context.showErrorNotification(
                          "Hata!",
                          "Yazdırma Hatası",
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  borderRadius: BorderRadius.circular(10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.flame_fill, size: 16),
                      SizedBox(width: 6),
                      Text("Mutfağa Yaz", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  onPressed: () async {
                    if (yazdirmaDurumuMutfak == "Daha Önce Yazılmış!") {
                      if (!context.mounted) return;
                      context.showErrorNotification(
                        "Hata!",
                        "Daha Önce Yazılmış!",
                      );
                    } else {
                      var sonuc = await adisyonMutfakYaz(tableId);

                      if (sonuc) {
                        if (!context.mounted) return;
                        context.showSuccessNotification(
                          "Başarılı!",
                          "Mutfak Yazıldı",
                        );
                      } else {
                        if (!context.mounted) return;
                        context.showErrorNotification(
                          "Hata!",
                          "Yazdırma Hatası",
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Consumer(
            builder: (context, ref, child) {
              final total = ref.watch(adisyonNotifierProvider.notifier).total;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Genel Toplam',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green[800],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${Config.formatter.format(total)} ₺',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.green[800],
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              );
            },
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
                  adisyonYaz(tableId);
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
                  adisyonMutfakYaz(tableId);
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
                  masaAktar(tableId, tableName);
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
        context.showErrorNotification("Hata!", 'Daha Önce Yazılmış!');
        yazdirmaDurumuMutfak = "Daha Önce Yazılmış!";
      } else {
        yazdirmaDurumuMutfak = "Mutfak Bar Yazıldı.";
        context.showSuccessNotification(
          "Başarılı!",
          'Mutfak Bar başarıyla yazıldı.',
        );
      }
      setState(() {});
    } catch (error) {
      if (!mounted) return false;
      // CuperAlert.show(
      //   context: context,
      //   destructive: true,
      //   title: 'Hata',
      //   content: 'Mutfak Bar Yazma Hatası!\n$error',
      // );
      context.showErrorNotification(
        "Hata!",
        'Mutfak Bar Yazma Hatası!\n$error',
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
        // setState(() {
        //   yazdirmaDurumuAdisyon = "Daha Önce Yazılmış!";
        // });
        context.showErrorNotification("Hata!", 'Daha Önce Yazılmış!');
      } else {
        setState(() {
          yazdirmaDurumuAdisyon = "Adisyon Yazıldı.";
        });
        context.showSuccessNotification(
          "Başarılı!",
          'Adisyon başarıyla yazıldı.',
        );
      }
    } catch (error) {
      if (!mounted) return false;
      // CuperAlert.show(
      //   context: context,
      //   destructive: true,
      //   title: 'Hata',
      //   content: 'Adisyon Yazma Hatası!\n$error',
      // );

      context.showErrorNotification("Hata!", 'Adisyon Yazma Hatası!\n$error');
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
          .deleteAdisyon(id, tableId);

      if (ref.read(adisyonNotifierProvider).isSuccess == true) {
        if (!mounted) return false;
        // Config.showsnack(
        //   context,
        //   'Silindi',
        //   color: const Color.fromARGB(255, 244, 67, 54),
        // );
        context.showInfoNotification("Silindi!", 'Sipariş başarıyla silindi.');
      } else {
        if (!mounted) return false;
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Silme Hatası!\nMutfak veya Bar a Yazılmış!',
        );
        context.showErrorNotification("Hata!", 'Bir hata oluştu');
      }
    } catch (error) {
      if (!mounted) return false;
      context.showErrorNotification("Hata!", 'Bir hata oluştu$error');
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
        return OrderDescriptionDialog(name: malzemeAdi, detailId: detayId);
      },
    );

    if (shouldUpdate) {
      verigetirgirilenler();
    }

    if (shouldUpdate) {}
  }

  Future<void> openAlertKisiSayisi(
    BuildContext context,
    int masaId,
    String masaAdi,
  ) async {
    final initialCount =
        cartItems.isNotEmpty && (cartItems.first.kisiSayisi ?? 0) > 0
        ? cartItems.first.kisiSayisi!
        : ref.read(adisyonNotifierProvider).personCount;
    ref.read(adisyonNotifierProvider.notifier).setPersonCount(initialCount);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;
        final dialogBackground = Color.lerp(
          colorScheme.surface,
          colorScheme.primary,
          isDark ? 0.12 : 0.05,
        )!;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          backgroundColor: dialogBackground,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: dialogBackground,
              border: Border.all(
                color: colorScheme.outline.withValues(
                  alpha: isDark ? 0.35 : 0.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.people_alt_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kişi Sayısı',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      masaAdi,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withValues(
                                alpha: isDark ? 0.28 : 0.55,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: isDark ? 0.3 : 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Bu ekranda kişi sayısı sadece arttırılabilir.
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 74,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: isDark ? 0.22 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.primary,
                                          ),
                                          child: Text('$personCount'),
                                        ),
                                        Text(
                                          'Kişi',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (personCount < 10) {
                                      adisyonNotifier.addPersonCount();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: personCount < 10
                                          ? colorScheme.primary
                                          : colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: personCount < 10
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.4,
                                            ),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Sadece arttırılabilir  Max: 10',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      adisyonNotifier.setPersonCount(
                                        initialCount,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('İptal'),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: FilledButton.icon(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                            adisyonNotifierProvider.notifier,
                                          )
                                          .getAdisyonList(masaId);
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                      await verigetirgirilenler();
                                    },
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('Güncelle'),
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
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
