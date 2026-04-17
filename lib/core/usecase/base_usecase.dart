abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

// Params gerektirmeyen durumlar için
abstract class NoParamsUseCase<T> {
  Future<T> call();
}

// Sync operations için
abstract class SyncUseCase<T, Params> {
  T call(Params params);
}
