import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

import '../components/custom_circular_button.dart';
import '../../../core/locale/locales.dart';
import '../../../core/theme/colors.dart';
import '../../data/models/food_item_info.dart';

class ItemInfoPage extends StatefulWidget {
  final String? name;

  const ItemInfoPage(this.name, {super.key});

  @override
  ItemInfoPageState createState() => ItemInfoPageState();
}

// SEPETTE MALZEMENİN DETAYINI GÖSTEREN SAYFA

class ItemInfoPageState extends State<ItemInfoPage> {
  bool isLoading = false;

  bool isSearch = false;

  List<FoodItemInfo> foodItems = [
    FoodItemInfo('assets/food items/food1.png', 'Veg Sandwich', true, '5.00'),
    FoodItemInfo('assets/food items/food2.png', 'Shrips Rice', true, '3.00'),
    FoodItemInfo('assets/food items/food3.png', 'Cheese Bread', true, '4.00'),
    FoodItemInfo('assets/food items/food4.png', 'Veg Cheeswich', true, '3.50'),
    FoodItemInfo(
      'assets/food items/food5.png',
      'Margherita Pizza',
      true,
      '4.50',
    ),
    FoodItemInfo('assets/food items/food6.png', 'Veg Manchau', true, '2.50'),
    FoodItemInfo('assets/food items/food7.png', 'Spring Noodle', true, '3.00'),
    FoodItemInfo('assets/food items/food8.png', 'Veg Mix Pizza', true, '5.00'),
  ];

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: FadedScaleAnimation(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'SUZLON'),
                  TextSpan(
                    text: ' RESTRO',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIconColor: const Color(0x917a7b82),
                  prefixIcon: const Icon(Icons.search),
                  hintText: locale.searchItem,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0x917a7b82),
                  ),
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            buildItemsInCartButton(context),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : FadedSlideAnimation(
                beginOffset: const Offset(0, 0.3),
                endOffset: const Offset(0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: 70,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 24,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${locale.description!}\n\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  letterSpacing: 1.5,
                                                  color: const Color(
                                                    0xff6f6f6f,
                                                  ),
                                                ),
                                          ),
                                          TextSpan(
                                            text:
                                                'Lorem ipsum dolor sit amet, consecutar adi piscing elit, sed do eiusmod incidudant ut djd labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FadedScaleAnimation(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.4,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // image: DecorationImage(
                                        //     // image: AssetImage(widget.img!),
                                        //     fit: BoxFit.cover,
                                        //     colorFilter: ColorFilter.mode(
                                        //         Colors.black.withOpacity(0.4),
                                        //         BlendMode.darken))
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Spacer(),
                                          Center(
                                            child: Image.asset(
                                              'assets/yt.png',
                                              scale: 4,
                                            ),
                                          ),
                                          const Spacer(),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${locale.knowHowWeCookIt!}\n',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: '3 ${locale.minVideo!}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: const Color(
                                                          0x91ffffff,
                                                        ),
                                                        fontSize: 15,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildCustomContainer(
                                          context,
                                          'assets/ItemCategory/ic_Serving.png',
                                          locale.servings!,
                                          '2 ${locale.people!}',
                                        ),
                                        const Spacer(),
                                        buildCustomContainer(
                                          context,
                                          'assets/ItemCategory/ic_cooktime.png',
                                          locale.cookTime!,
                                          '12 ${locale.mins!}',
                                        ),
                                        const Spacer(),
                                        buildCustomContainer(
                                          context,
                                          'assets/ItemCategory/ic_energy.png',
                                          locale.energy!,
                                          '227 ${locale.cal!}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 25,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${locale.ingredients!}\n\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  letterSpacing: 1.5,
                                                  color: const Color(
                                                    0xff6f6f6f,
                                                  ),
                                                ),
                                          ),
                                          TextSpan(
                                            text: locale.foodItems,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  letterSpacing: 0.4,
                                                  height: 1.6,
                                                  wordSpacing: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          child: Text(
                                            locale.relatedItemsYouMayLike!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1.5,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        SizedBox(
                                          height: 230,
                                          child: ListView.separated(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              bottom: 20,
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: 6,
                                            separatorBuilder:
                                                ((context, index) {
                                                  return const SizedBox(
                                                    width: 20,
                                                  );
                                                }),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 22,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Navigator.push(
                                                          //     context, MaterialPageRoute(builder: (context)=>ItemInfoPage(foodItems[index].image,foodItems[index].name)));
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            FadedScaleAnimation(
                                                              child: Opacity(
                                                                opacity: 0.6,
                                                                child: Container(
                                                                  width: 300,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius.vertical(
                                                                      top:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                      bottom:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                                    image: DecorationImage(
                                                                      image: AssetImage(
                                                                        foodItems[index]
                                                                            .image,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            PositionedDirectional(
                                                              start: 12,
                                                              top: 12,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    foodItems[index]
                                                                        .name,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Text(
                                                                    '\$${foodItems[index].price}',
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        true,
                                                                  ),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Stack(
                              children: [
                                FadedScaleAnimation(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      // image: DecorationImage(
                                      //   image: AssetImage(widget.img!),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.surface,
                                        AppColors.transparentColor,
                                      ],
                                      stops: const [0.0, 0.5],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        locale.fastFood!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              height: 1.8,
                                              fontSize: 15,
                                              color: const Color(0x91ffffff),
                                            ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$12.00',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    locale.addOptions!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5,
                                          fontSize: 12,
                                          color: const Color(0xff6f6f6f),
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  buildAddOption(
                                    context,
                                    'Extra Cheese',
                                    '\$5.00',
                                  ),
                                  buildAddOption(
                                    context,
                                    'Extra Honey',
                                    '\$3.00',
                                  ),
                                  buildAddOption(
                                    context,
                                    'Extra Mayonnaise',
                                    '\$4.00',
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  locale.addToCart!,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
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
      ),
    );
  }

  Widget buildAddOption(BuildContext context, String title, String price) {
    bool? val = title == 'Extra Cheese' ? true : false;
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7,
            child: Checkbox(
              activeColor: AppColors.newOrderColor,
              checkColor: Theme.of(context).colorScheme.surface,
              fillColor: WidgetStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              value: val,
              onChanged: (bool? value) {
                setState(() {
                  val = value;
                });
              },
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(price),
        ],
      ),
    );
  }

  Widget buildCustomContainer(
    BuildContext context,
    String icon,
    String title,
    String subtitle,
  ) {
    return Expanded(
      flex: 7,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height * 0.25,
        // width: MediaQuery.of(context).size.width * 0.13,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 5,
              child: Image.asset(
                icon,
                // scale: 3,
              ),
            ),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xff6f6f6f),
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  CustomButton buildItemsInCartButton(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return CustomButton(
      onTap: () {
        // _scaffoldKey.currentState.openEndDrawer();
      },
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      title: Text(
        '${locale.itemsInCart!} (3)',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      bgColor: AppColors.buttonColor,
    );
  }
}
