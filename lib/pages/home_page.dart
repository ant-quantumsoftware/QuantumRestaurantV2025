import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/data/models/dataGet/card_item_model.dart';
import '../features/data/models/dataGet/food_categori_model.dart';
import '../features/data/models/dataGet/food_item_model.dart';
import '../components/custom_circular_button.dart';
import '../locale/locales.dart';
import '../pages/siparis_onaylama.dart';
import '../core/theme/colors.dart';
import '../utils.dart';
import 'dialog_miktar_siparis.dart';
import 'item_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Yeni Metodlar
  bool login = true;
  bool logindetails = true;

  late List<CardItemModel> cartItems = []; // Girilen Siparişler
  late List<FoodItemModel> foodItems = []; // Tüm Ürünler
  late List<FoodItemModel> foodItemsTum = []; // Tüm Ürünler
  late List<FoodItemModel> foodItemsS = []; // Tüm Ürünler Arama Sonucu
  late List<FoodCategoriModel> foodCategoriItems = [];

  @override
  void initState() {
    super.initState();
    veriGetirOncelikli();
  }

  void veriGetirOncelikli() async {
    var foodCategoriItems = await getFoodCategoriAll();
    setState(() {
      foodCategoriItems = foodCategoriItems;

      veriGetir();
    });
  }

  void veriGetir() async {
    var cartItems = await getCardItemGetirId(masaid);
    var fooditems = await getFoodItemCategories(
      foodCategoriItems[currentIndex].kodu!,
    );
    var fooditemsTum = await getFoodItemAll();

    setState(() {
      cartItems = cartItems;
      foodItems = fooditems;
      foodItemsTum = fooditemsTum;
      foodItemsS = fooditems;
      login = false;
      veriGetirMalzeme();
    });
  }

  void veriGetirMalzeme() async {
    var fooditems = await getFoodItemCategories(
      foodCategoriItems[currentIndex].kodu!,
    );

    setState(() {
      foodItems = fooditems;
      foodItemsS = fooditems;
      logindetails = false;
    });
  }

  // Arama Fonksiyonu
  void searchFunc(String value) {
    if (value == "") {
      foodItemsS = foodItems;
    } else {
      foodItemsS = [];

      for (var people in foodItemsTum) {
        if (people.adi!.toLowerCase().trim().contains(value)) {
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
  int _selectedIndex = 0;

  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOrderPlaced = false;

  Future<void> refreshlist() {
    setState(() {
      veriGetir();
    });

    return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
            as Map;

    masaadi = arguments['masaadi'];
    masaid = arguments['masaid'];

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: Stack(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            isOrderPlaced ? locale.orderList! : locale.close!,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const Spacer(),
                        isOrderPlaced
                            ? Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 10.0,
                                ),
                                child: Text(
                                  '${locale.tableNum?.toUpperCase()} 6',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 1.4,
                                      ),
                                ),
                              )
                            : buildItemsInCartButton(context),
                      ],
                    ),

                    // Sipariş Girilen Malzemeler Yeni
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: cartItems.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10,
                              ),
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItemInfoPage(cartItems[index].adi),
                                    ),
                                  );
                                },
                                child: FadedScaleAnimation(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FadedScaleAnimation(
                                      child: Image.asset(
                                        'assets/resimnull.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                cartItems[index].adi!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (cartItems[index].miktar > 1) {
                                                setState(() {
                                                  cartItems[index].miktar--;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: Theme.of(
                                                  context,
                                                ).scaffoldBackgroundColor,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Text(
                                            cartItems[index].miktar.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 15),
                                          ),
                                          const SizedBox(width: 24),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                cartItems[index].miktar =
                                                    cartItems[index].miktar + 1;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Theme.of(
                                                  context,
                                                ).scaffoldBackgroundColor,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Fiyat :${Utils.format.format(cartItems[index].fiyatd)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),
                                  // Özellik 1
                                  (cartItems[index].ozellik1 != null &&
                                          cartItems[index].ozellik1!.isNotEmpty)
                                      ? Row(
                                          children: [
                                            Text(
                                              cartItems[index].ozellik1!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.yellow[800],
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
                                              cartItems[index].ozellik2!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.yellow[800],
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
                                              cartItems[index].ozellik3!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.yellow[800],
                                                  ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            // SizedBox(height: 200,),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                // Sipariş Alt Toplamları
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: const Color(0xff35363B),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          title: Text(
                            locale.totalAmount!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 14),
                          ),
                          trailing: Text(
                            '\$'
                            '74.00',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        CustomButton(
                          onTap: () {
                            setState(() {
                              isOrderPlaced = true;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildAboutDialog(context),
                            );
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          bgColor: Theme.of(context).primaryColor,
                          title: Text(
                            isOrderPlaced
                                ? locale.confirmOrder!
                                : locale.finishOrdering!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(fontSize: 16),
                          ),
                          borderRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        // title: FadedScaleAnimation(
        //   child: RichText(
        //     text: TextSpan(
        //       style: Theme.of(context)
        //           .textTheme
        //           .titleMedium!
        //           .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
        //       children: <TextSpan>[
        //         const TextSpan(
        //           text: 'QUANTUM',
        //           style: TextStyle(fontSize: 8),
        //         ),
        //         TextSpan(
        //             text: ' RESTAURANT',
        //             style: TextStyle(
        //                 color: Theme.of(context).primaryColor, fontSize: 7)),
        //       ],
        //     ),
        //   ),
        // ),
        actions: [
          buildItemsInMasaButton(context),
          Container(
            width: 170,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIconColor: const Color(0x917a7b82),
                prefixIcon: const Icon(Icons.search),
                hintText: locale.searchItem,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0x917a7b82)),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  searchFunc(value);
                });
              },
            ),
          ),

          buildItemsInCartButton(context), // Butonu Ayarla
        ],
      ),
      body: (login)
          ? const Center(child: CupertinoActivityIndicator(radius: 20.0))
          : Container(
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: foodCategoriItems.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              logindetails = true;
                              veriGetirMalzeme();
                              // katregoriye göre malzeme listesini yenile
                            });
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linearToEaseOut,
                            );
                            // _pageController.animateTo(
                            //   index.toDouble(),
                            //   duration: Duration(milliseconds: 300),
                            //   curve: Curves.easeIn,
                            // );
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.green
                                      : Colors.amber[100],
                                  border: Border.all(
                                    color: Colors.grey, // Set border color
                                    width: 3.0,
                                  ), // Set border width
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ), // Set rounded corner radius
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(1, 3),
                                    ),
                                  ], // Make rounded corner of border
                                ),
                                child: Text(
                                  foodCategoriItems[index].adi!,
                                  style: const TextStyle(fontSize: 12),
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
                      color: Theme.of(context).scaffoldBackgroundColor,
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
            ),
      bottomNavigationBar: altbar(context),
    );
  }

  // Sipariş Butonu
  CustomButton buildItemsInCartButton(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return CustomButton(
      onTap: () {
        setState(() {
          drawerCount = 0;
        });
        if (cartItems.isNotEmpty) {
          _scaffoldKey.currentState!.openEndDrawer();
        }
      },
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(
        cartItems.isNotEmpty
            ? '${locale!.itemsInCart!} (${cartItems.length.toString()})' // sipariş kalem sayısı
            : '${locale!.itemsInCart!} (0)',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      bgColor: cartItems.isNotEmpty ? buttonColor : Colors.grey[600],
    );
  }

  CustomButton buildItemsInMasaButton(BuildContext context) {
    return CustomButton(
      onTap: () {
        setState(() {
          drawerCount = 0;
        });

        _scaffoldKey.currentState!.openEndDrawer();
      },
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Text(masaadi, style: Theme.of(context).textTheme.bodyMedium),
      bgColor: Colors.green[600],
    );
  }

  Widget buildPage() {
    if (logindetails) {
      return const Center(child: CupertinoActivityIndicator(radius: 20.0));
    }

    // MALZEME KALEMLERİ
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        top: 10,
        bottom: 10,
        start: 10,
        end: 20,
      ),
      itemCount: foodItemsS.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 5,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor,
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

                    openAlertYeni(
                      foodItemsS[index].adi!,
                      foodItemsS[index].id!,
                      foodItemsS[index].secenek1!,
                      foodItemsS[index].secenek2!,
                      foodItemsS[index].secenek3!,
                      foodItemsS[index].secenek4!,
                      foodItemsS[index].secenek5!,
                      foodItemsS[index].secenek6!,
                    );
                  },
                  child: Stack(
                    children: [
                      FadedScaleAnimation(
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10),
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: 12,
                        top: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  textAlign: TextAlign.right,
                                  'Stok: ${foodItemsS[index].count} ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 11,
                                        color: Colors.blue,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                const SizedBox(height: 2, width: 20),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Fiyat: ${Utils.format.format(foodItemsS[index].fiyatd)} TL',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 11,
                                          color: Colors.blue,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              foodItemsS[index].adi!,
                            ),
                          ],
                        ),
                      ),
                      foodItemsS[index].isSelected
                          ? Opacity(
                              opacity: 0.8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withValues(
                                        alpha: 0.3,
                                      ), // withOpacity(0.3)
                                      transparentColor,
                                    ],
                                    stops: const [0.2, 0.4, 1.0],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      foodItemsS[index].isSelected
                          ? Positioned(
                              left: 16,
                              right: 16,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (foodItemsS[index].count >= 1) {
                                          setState(() {
                                            foodItemsS[index].count--;
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const Spacer(),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: whiteColor,
                                      child: Text(
                                        foodItemsS[index].count.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontSize: 12,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: const SingleChildScrollView(child: OrderPlaced()),
    );
  }

  late Dialog dialog;
  String aktifMiktarstr = "1.00";
  double aktifmiktar = 1;

  void openAlertYeni(
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

  void okclick() {
    Navigator.pop(context);
  }

  String aktifMiktarStrY() {
    return aktifMiktarstr;
  }

  void cancelClick() {
    Navigator.pop(context);
  }

  BottomNavigationBar altbar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Yeni Sipariş'),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_filled),
          label: 'Tüm Siparişler',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        if (cartItems.isNotEmpty) {
          _scaffoldKey.currentState!.openEndDrawer();
        }
      } else {}
    });
  }
}
