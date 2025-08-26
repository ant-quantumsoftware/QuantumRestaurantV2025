import '../../../features/data/models/dataGet/card_item_model.dart';
import '../../../features/data/models/dataGet/food_item_model.dart';

class AdisyonState {
  final List<CardItemModel>? adisyonList;
  final List<FoodItemModel>? favoriteItems;

  final bool? isSuccess;
  final bool? isLoading;

  AdisyonState({
    this.adisyonList,
    this.favoriteItems,
    this.isSuccess,
    this.isLoading,
  });

  //copyWith
  AdisyonState copyWith({
    List<CardItemModel>? adisyonList,
    List<FoodItemModel>? favoriteItems,
    bool? isSuccess,
    bool? isLoading,
  }) {
    return AdisyonState(
      adisyonList: adisyonList ?? this.adisyonList,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
