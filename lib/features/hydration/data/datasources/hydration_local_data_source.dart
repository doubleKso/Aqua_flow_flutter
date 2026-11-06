import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/hydration_entry.dart' as domain;
import '../../domain/entities/hydration_settings.dart';

class HydrationLocalDataSource {
  const HydrationLocalDataSource(this._database);

  final AppDatabase _database;

  Future<HydrationSettings> getSettings() async {
    final row = await (_database.select(
      _database.hydrationPreferences,
    )..where((table) => table.id.equals(1))).getSingle();

    return HydrationSettings(
      dailyGoalMl: row.dailyGoalMl,
      defaultDrinkMl: row.defaultDrinkMl,
      reminderIntervalMinutes: row.reminderIntervalMinutes,
      startMinute: row.startMinute,
      endMinute: row.endMinute,
      remindersEnabled: row.remindersEnabled,
      skipWeekends: row.skipWeekends,
      soundEnabled: row.soundEnabled,
      themePreference: AppThemePreference.values.firstWhere(
        (value) => value.name == row.themePreference,
        orElse: () => AppThemePreference.system,
      ),
      timezone: row.timezone,
    );
  }

  Future<void> saveSettings(HydrationSettings settings) {
    return _database
        .into(_database.hydrationPreferences)
        .insertOnConflictUpdate(
          HydrationPreferencesCompanion.insert(
            id: const Value(1),
            dailyGoalMl: Value(settings.dailyGoalMl),
            defaultDrinkMl: Value(settings.defaultDrinkMl),
            reminderIntervalMinutes: Value(settings.reminderIntervalMinutes),
            startMinute: Value(settings.startMinute),
            endMinute: Value(settings.endMinute),
            remindersEnabled: Value(settings.remindersEnabled),
            skipWeekends: Value(settings.skipWeekends),
            soundEnabled: Value(settings.soundEnabled),
            themePreference: Value(settings.themePreference.name),
            timezone: Value(settings.timezone),
          ),
        );
  }

  Future<int> addDrink(int amountMl, DateTime consumedAt) {
    return _database
        .into(_database.drinkEntries)
        .insert(
          DrinkEntriesCompanion.insert(
            amountMl: amountMl,
            consumedAt: consumedAt,
          ),
        );
  }

  Future<void> deleteMostRecentDrink() async {
    final latest =
        await (_database.select(_database.drinkEntries)
              ..orderBy([
                (row) => OrderingTerm.desc(row.consumedAt),
                (row) => OrderingTerm.desc(row.id),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (latest == null) return;
    await (_database.delete(
      _database.drinkEntries,
    )..where((row) => row.id.equals(latest.id))).go();
  }

  Future<List<domain.HydrationEntry>> entriesBetween(
    DateTime start,
    DateTime end,
  ) async {
    final rows =
        await (_database.select(_database.drinkEntries)
              ..where((row) => row.consumedAt.isBetweenValues(start, end))
              ..orderBy([
                (row) => OrderingTerm.desc(row.consumedAt),
                (row) => OrderingTerm.desc(row.id),
              ]))
            .get();
    return rows.map(_mapEntry).toList(growable: false);
  }

  Future<List<domain.HydrationEntry>> recentEntries({int limit = 80}) async {
    final rows =
        await (_database.select(_database.drinkEntries)
              ..orderBy([
                (row) => OrderingTerm.desc(row.consumedAt),
                (row) => OrderingTerm.desc(row.id),
              ])
              ..limit(limit))
            .get();
    return rows.map(_mapEntry).toList(growable: false);
  }

  domain.HydrationEntry _mapEntry(DrinkEntry row) {
    return domain.HydrationEntry(
      id: row.id,
      amountMl: row.amountMl,
      consumedAt: row.consumedAt,
    );
  }
}
