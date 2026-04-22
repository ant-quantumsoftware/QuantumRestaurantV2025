import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/data/models/dataGet/food_item_model.dart';
import 'features/data/models/fast_description_model.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Veritabanı Ayarla
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemModelAdapter());
  Hive.registerAdapter(FastDescriptionModelAdapter());

  runApp(
    ProviderScope(
      child: Phoenix(child: SafeArea(top: false, child: const MyApp())),
    ),
  );
}
