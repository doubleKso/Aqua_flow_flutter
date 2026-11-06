import '../entities/hydration_settings.dart';
import '../entities/hydration_snapshot.dart';

abstract class HydrationRepository {
  Future<HydrationSnapshot> loadSnapshot();

  Future<void> addDrink(int amountMl, {DateTime? consumedAt});

  Future<void> undoMostRecentDrink();

  Future<void> saveSettings(HydrationSettings settings);
}
