import 'package:drink_water_daily_remainder/core/database/app_database.dart';
import 'package:drink_water_daily_remainder/features/hydration/data/datasources/hydration_local_data_source.dart';
import 'package:drink_water_daily_remainder/features/hydration/data/repositories/hydration_repository_impl.dart';
import 'package:drink_water_daily_remainder/features/hydration/domain/entities/hydration_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late HydrationRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = HydrationRepositoryImpl(HydrationLocalDataSource(database));
  });

  tearDown(() => database.close());

  test('stores, summarizes, and undoes water locally', () async {
    await repository.addDrink(250);
    await repository.addDrink(350);

    var snapshot = await repository.loadSnapshot();
    expect(snapshot.todayTotalMl, 600);
    expect(snapshot.todayEntries, hasLength(2));

    await repository.undoMostRecentDrink();
    snapshot = await repository.loadSnapshot();
    expect(snapshot.todayTotalMl, 250);
    expect(snapshot.todayEntries, hasLength(1));
  });

  test('persists hydration settings', () async {
    const updated = HydrationSettings(
      dailyGoalMl: 2600,
      defaultDrinkMl: 350,
      reminderIntervalMinutes: 45,
      startMinute: 480,
      endMinute: 1260,
      remindersEnabled: true,
      skipWeekends: true,
      themePreference: AppThemePreference.dark,
      timezone: 'Asia/Yangon',
    );

    await repository.saveSettings(updated);
    final snapshot = await repository.loadSnapshot();

    expect(snapshot.settings.dailyGoalMl, 2600);
    expect(snapshot.settings.defaultDrinkMl, 350);
    expect(snapshot.settings.reminderIntervalMinutes, 45);
    expect(snapshot.settings.themePreference, AppThemePreference.dark);
  });
}
