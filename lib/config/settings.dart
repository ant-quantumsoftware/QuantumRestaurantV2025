import '../features/data/models/dataGet/food_categori_model.dart';
import '../features/data/models/dataGet/food_item_model.dart';

class Settings {
  //One instance, needs factory

  //

  static String token = 'qua';
  static String garsonadi = 'qua';
  static int garsonid = 0;
  static String apiadres = 'api.quantumyazilim.com';

  static List<FoodItemModel> foodItemsTum = []; // Tüm Ürünler

  static List<FoodCategoriModel> foodCategoriItems = []; // Tüm Kategoriler

  static String getToken() {
    return token;
  }

  static void setToken(String deger) {
    token = deger;
  }

  static String getGarsonAdi() {
    return garsonadi;
  }

  static void setGarsonAdi(String deger) {
    garsonadi = deger;
  }

  static int getGarsonId() {
    return garsonid;
  }

  static void setGarsonId(int deger) {
    garsonid = deger;
  }

  static String getApiAdres() {
    return apiadres;
  }

  static void setApiAdres(String deger) {
    apiadres = deger;
  }

  static List<FoodItemModel> getFoodItemAll() {
    return foodItemsTum;
  }

  static void setFoodItemAll(List<FoodItemModel> deger) {
    foodItemsTum = deger;
  }

  static List<FoodCategoriModel> getFoodCategoriItems() {
    return foodCategoriItems;
  }

  static void setFoodCategoriItems(List<FoodCategoriModel> deger) {
    foodCategoriItems = deger;
  }
}
