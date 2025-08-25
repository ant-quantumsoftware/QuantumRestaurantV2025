import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

import '../locale/locales.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({super.key});

  @override
  OrderPlacedState createState() => OrderPlacedState();
}

// SİPARİŞ TAMAMLAMA ALERT EKRANI

class OrderPlacedState extends State<OrderPlaced> {
  @override
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return FadedSlideAnimation(
      beginOffset: const Offset(0, 0.3),
      endOffset: const Offset(0, 0),
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    locale.weMustSay!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    locale.youveGreatChoiceOfTaste!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 24,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.4,
                child: const Image(
                  image: AssetImage("assets/order confirmed.png"),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Text(
                    locale.orderConfirmedWith!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 26),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'QUANTUM'),
                        TextSpan(
                          text: ' RESTAURANT',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Text(
                    locale.yourOrderWillBeAtYourTable!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                    ),
                  ),
                  Text(
                    locale.anytimeSoon!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
