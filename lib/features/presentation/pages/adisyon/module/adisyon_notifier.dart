import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantum_restaurant/core/usecase/result.dart';

  import '../../../../data/models/dataGet/card_item_model.dart';
import '../../../../data/models/dataGet/food_item_model.dart';
import '../../../../data/models/dataPost/adisyon_model.dart';
import '../../../../domain/usecase/bill/add_favorite_item_usecase.dart';
import '../../../../domain/usecase/bill/get_favorite_items_usecase.dart';
import '../../../../domain/usecase/bill/remove_favorite_item_usecase.dart';
import 'adisyon_state.dart';  

final adisyonNotifierProvider =
    StateNotifierProvider<AdisyonNotifier, AdisyonState>((ref) {
      return AdisyonNotifier(
        ref.read(getFavoriteItemsUsecaseProvider),
        ref.read(addFavoriteItemUsecaseProvider),
        ref.read(removeFavoriteItemUsecaseProvider),
      );
    });

class AdisyonNotifier extends StateNotifier<AdisyonState> {
  final GetFavoriteItemsUsecase _getFavoriteItemsUsecase;
  final AddFavoriteItemUsecase _addFavoriteItemUsecase;
  final RemoveFavoriteItemUsecase _removeFavoriteItemUsecase;
  AdisyonNotifier(
    this._getFavoriteItemsUsecase,
    this._addFavoriteItemUsecase,
    this._removeFavoriteItemUsecase,
  ) : super(AdisyonState());

  Future<void> getAdisyonList(int masaId) async {
    state = state.copyWith(isLoading: true);
    final adisyonList = await getCardItemGetirId(masaId);
    state = state.copyWith(isLoading: false, adisyonList: adisyonList);
  }

  Future<void> deleteAdisyon(int id, int masaId) async {
    state = state.copyWith(isLoading: true);
    final success = await deleteSiparisAdisyon(id);
    if (success) {
      await getAdisyonList(masaId);
    }
    state = state.copyWith(isLoading: false, isSuccess: success);
  }

  Future<bool> saveOrder(AdisyonModel model) async {
    state = state.copyWith(isLoading: true);

    final success = await sendSiparisAdisyon(model);
    if (success && model.masaid != null) {
      // Sipariş başarıyla kaydedildiyse listeyi yeniden çek
      await getAdisyonList(model.masaid!);
    }
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> updateOrder(AdisyonModel model) async {
    state = state.copyWith(isLoading: true);

    // Güncelleme için de aynı fonksiyonu kullan (API hem ekleme hem güncelleme yapıyor olabilir)
    final success = await sendSiparisAdisyon(model);
    if (success && model.masaid != null) {
      // Güncelleme başarılıysa listeyi yeniden çek
      await getAdisyonList(model.masaid!);
    }
    state = state.copyWith(isLoading: false);
    return success;
  }

  void clearState() {
    state = AdisyonState();
  }

  Future<void> refreshAdisyonList(int masaId) async {
    await getAdisyonList(masaId);
  }

  double get total =>
      state.adisyonList?.fold(
        0,
        (sum, item) => (sum ?? 0) + (item.genel ?? 0),
      ) ??
      0;

  Future<void> getFavoriteItems() async {
    final result = await _getFavoriteItemsUsecase.call(null);
    state = state.copyWith(favoriteItems: result.data);
  }

  Future<void> addFavoriteItem(FoodItemModel item) async {
    final result = await _addFavoriteItemUsecase.call(item);
    if (result.isSuccess) {
      await getFavoriteItems();
    }
  }

  Future<void> removeFavoriteItem(FoodItemModel item) async {
    final result = await _removeFavoriteItemUsecase.call(item);
    if (result.isSuccess) {
      await getFavoriteItems();
    }
  }
}
