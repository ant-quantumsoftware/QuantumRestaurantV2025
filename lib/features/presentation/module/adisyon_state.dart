import '../../data/models/dataGet/card_item_model.dart';
import '../../data/models/dataGet/food_item_model.dart';

class AdisyonState {
  final List<CardItemModel>? adisyonList;
  final List<FoodItemModel>? favoriteItems;
  final int personCount;

  final bool? isSuccess;
  final bool? isLoading;

  AdisyonState({
    this.adisyonList,
    this.favoriteItems,
    this.personCount = 1,
    this.isSuccess,
    this.isLoading,
  });

  //copyWith
  AdisyonState copyWith({
    List<CardItemModel>? adisyonList,
    List<FoodItemModel>? favoriteItems,
    int? personCount,
    bool? isSuccess,
    bool? isLoading,
  }) {
    return AdisyonState(
      adisyonList: adisyonList ?? this.adisyonList,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      personCount: personCount ?? this.personCount,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
