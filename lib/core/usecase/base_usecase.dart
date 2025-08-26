abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Params gerektirmeyen durumlar için
abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}

// Sync operations için
abstract class SyncUseCase<Type, Params> {
  Type call(Params params);
}
