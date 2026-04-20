import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/usecase/result.dart';
import '../../domain/entity/fast_description_entity.dart';
import '../../domain/usecase/fast_description/clear_fast_descriptions_usecase.dart';
import '../../domain/usecase/fast_description/delete_fast_description_usecase.dart';
import '../../domain/usecase/fast_description/get_fast_description_usecase.dart';
import '../../domain/usecase/fast_description/get_fast_descriptions_for_product_usecase.dart';
import '../../domain/usecase/fast_description/save_fast_description_usecase.dart';
import 'fast_description_state.dart';

final fastDescriptionNotifierProvider =
    StateNotifierProvider<FastDescriptionNotifier, FastDescriptionState>((ref) {
      return FastDescriptionNotifier(
        ref.read(getFastDescriptionsForProductUsecaseProvider),
        ref.read(getFastDescriptionUsecaseProvider),
        ref.read(saveFastDescriptionUsecaseProvider),
        ref.read(deleteFastDescriptionUsecaseProvider),
        ref.read(clearFastDescriptionsUsecaseProvider),
      );
    });

class FastDescriptionNotifier extends StateNotifier<FastDescriptionState> {
  final GetFastDescriptionsForProductUsecase _getForProductUsecase;
  final GetFastDescriptionUsecase _getOneUsecase;
  final SaveFastDescriptionUsecase _saveUsecase;
  final DeleteFastDescriptionUsecase _deleteUsecase;
  final ClearFastDescriptionsUsecase _clearUsecase;

  FastDescriptionNotifier(
    this._getForProductUsecase,
    this._getOneUsecase,
    this._saveUsecase,
    this._deleteUsecase,
    this._clearUsecase,
  ) : super(const FastDescriptionState());

  Future<void> getDescriptionsForProduct(
    int? productId, {
    String? localeCode,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      isSuccess: false,
    );

    final result = await _getForProductUsecase.call(
      GetFastDescriptionsForProductUsecaseParams(
        productId: productId,
        localeCode: localeCode,
      ),
    );

    result.when(
      success: (data) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          descriptions: data,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: () => error.message,
        );
      },
    );
  }

  Future<void> getDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      isSuccess: false,
    );

    final result = await _getOneUsecase.call(
      FastDescriptionUsecaseParams(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      ),
    );

    result.when(
      success: (data) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          selectedDescription: () => data,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: () => error.message,
        );
      },
    );
  }

  Future<void> saveDescription(FastDescriptionEntity entity) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      isSuccess: false,
    );

    final result = await _saveUsecase.call(entity);

    result.when(
      success: (_) async {
        await getDescriptionsForProduct(
          entity.productId,
          localeCode: entity.localeCode,
        );
        state = state.copyWith(
          isSuccess: true,
          selectedDescription: () => entity,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: () => error.message,
        );
      },
    );
  }

  Future<void> deleteDescription({
    int? id,
    int? productId,
    int? ingredientId,
    String? localeCode,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      isSuccess: false,
    );

    final result = await _deleteUsecase.call(
      DeleteFastDescriptionUsecaseParams(
        id: id,
        productId: productId,
        ingredientId: ingredientId,
        localeCode: localeCode,
      ),
    );

    result.when(
      success: (_) async {
        await getDescriptionsForProduct(productId, localeCode: localeCode);
        state = state.copyWith(
          isSuccess: true,
          selectedDescription: () => null,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: () => error.message,
        );
      },
    );
  }

  Future<void> clearDescriptions() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      isSuccess: false,
    );

    final result = await _clearUsecase.call();

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          descriptions: const [],
          selectedDescription: () => null,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: () => error.message,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }

  void clearSelectedDescription() {
    state = state.copyWith(selectedDescription: () => null);
  }

  void resetState() {
    state = const FastDescriptionState();
  }
}
