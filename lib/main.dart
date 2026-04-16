import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/data/models/dataGet/food_item_model.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Veritabanı Ayarla
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemModelAdapter());

  runApp(ProviderScope(child: Phoenix(child: const SuzlonOrdering())));
}
