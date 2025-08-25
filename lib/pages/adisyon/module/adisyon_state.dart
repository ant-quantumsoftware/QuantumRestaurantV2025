import '../../../dataGet/card_item_model.dart';

class AdisyonState {
  final List<CardItemModel>? adisyonList;
  final bool? isSuccess;
  final bool? isLoading;

  AdisyonState({this.adisyonList, this.isSuccess, this.isLoading});

  //copyWith
  AdisyonState copyWith({
    List<CardItemModel>? adisyonList,
    bool? isSuccess,
    bool? isLoading,
  }) {
    return AdisyonState(
      adisyonList: adisyonList ?? this.adisyonList,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
