import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class DrinkEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountMl => integer()();
  DateTimeColumn get consumedAt => dateTime()();
}

class HydrationPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get dailyGoalMl => integer().withDefault(const Constant(2000))();
  IntColumn get defaultDrinkMl => integer().withDefault(const Constant(250))();
  IntColumn get reminderIntervalMinutes =>
      integer().withDefault(const Constant(60))();
  IntColumn get startMinute => integer().withDefault(const Constant(420))();
  IntColumn get endMinute => integer().withDefault(const Constant(1320))();
  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get skipWeekends => boolean().withDefault(const Constant(false))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get themePreference =>
      text().withDefault(const Constant('system'))();
  TextColumn get timezone =>
      text().withDefault(const Constant('Asia/Yangon'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [DrinkEntries, HydrationPreferences])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() {
    return AppDatabase(
      driftDatabase(
        name: 'aqua_flow',
        native: const DriftNativeOptions(shareAcrossIsolates: true),
      ),
    );
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (_) async {
      await into(hydrationPreferences).insert(
        const HydrationPreferencesCompanion(id: Value(1)),
        mode: InsertMode.insertOrIgnore,
      );
    },
  );
}
