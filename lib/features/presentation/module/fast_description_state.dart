import '../../domain/entity/fast_description_entity.dart';

class FastDescriptionState {
  final List<FastDescriptionEntity> descriptions;
  final FastDescriptionEntity? selectedDescription;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const FastDescriptionState({
    this.descriptions = const [],
    this.selectedDescription,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  FastDescriptionState copyWith({
    List<FastDescriptionEntity>? descriptions,
    FastDescriptionEntity? Function()? selectedDescription,
    bool? isLoading,
    bool? isSuccess,
    String? Function()? errorMessage,
  }) {
    return FastDescriptionState(
      descriptions: descriptions ?? this.descriptions,
      selectedDescription: selectedDescription != null
          ? selectedDescription()
          : this.selectedDescription,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
