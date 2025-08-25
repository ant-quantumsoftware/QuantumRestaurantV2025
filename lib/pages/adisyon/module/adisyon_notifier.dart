import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dataGet/card_item_model.dart';
import '../../../dataPost/adisyon_model.dart';
import '../../../pages/adisyon/module/adisyon_state.dart';

final adisyonNotifierProvider =
    StateNotifierProvider<AdisyonNotifier, AdisyonState>((ref) {
      return AdisyonNotifier();
    });

class AdisyonNotifier extends StateNotifier<AdisyonState> {
  AdisyonNotifier() : super(AdisyonState());

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
}
