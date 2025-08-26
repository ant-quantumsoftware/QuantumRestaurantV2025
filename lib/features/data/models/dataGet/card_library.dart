import 'card_item_model.dart';

class CardLibrary {
  late List<CardItemModel> cartItems = [];

  List<CardItemModel> getMethod() {
    return cartItems;
  }

  bool addMethod(CardItemModel model) {
    cartItems.add(model);
    return true;
  }
}
