import '../entities/hydration_settings.dart';
import '../entities/hydration_snapshot.dart';
import '../repositories/hydration_repository.dart';

class LoadHydrationUseCase {
  const LoadHydrationUseCase(this._repository);
  final HydrationRepository _repository;

  Future<HydrationSnapshot> call() => _repository.loadSnapshot();
}

class AddDrinkUseCase {
  const AddDrinkUseCase(this._repository);
  final HydrationRepository _repository;

  Future<void> call(int amountMl) => _repository.addDrink(amountMl);
}

class UndoDrinkUseCase {
  const UndoDrinkUseCase(this._repository);
  final HydrationRepository _repository;

  Future<void> call() => _repository.undoMostRecentDrink();
}

class SaveHydrationSettingsUseCase {
  const SaveHydrationSettingsUseCase(this._repository);
  final HydrationRepository _repository;

  Future<void> call(HydrationSettings settings) =>
      _repository.saveSettings(settings);
}
