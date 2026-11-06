import '../../domain/entities/hydration_snapshot.dart';
import '../../domain/entities/hydration_settings.dart';
import '../../domain/repositories/hydration_repository.dart';
import '../datasources/hydration_local_data_source.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  const HydrationRepositoryImpl(this._localDataSource);

  final HydrationLocalDataSource _localDataSource;

  @override
  Future<void> addDrink(int amountMl, {DateTime? consumedAt}) async {
    if (amountMl <= 0 || amountMl > 5000) {
      throw ArgumentError.value(
        amountMl,
        'amountMl',
        'Enter a value from 1–5000 ml',
      );
    }
    await _localDataSource.addDrink(amountMl, consumedAt ?? DateTime.now());
  }

  @override
  Future<HydrationSnapshot> loadSnapshot() async {
    final settings = await _localDataSource.getSettings();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final firstDay = today.subtract(const Duration(days: 27));

    final recent = await _localDataSource.recentEntries();
    final rangeEntries = await _localDataSource.entriesBetween(
      firstDay,
      tomorrow,
    );
    final todayEntries = rangeEntries
        .where((entry) => !entry.consumedAt.isBefore(today))
        .toList(growable: false);

    final totalsByDay = <DateTime, int>{};
    for (final entry in rangeEntries) {
      final date = DateTime(
        entry.consumedAt.year,
        entry.consumedAt.month,
        entry.consumedAt.day,
      );
      totalsByDay.update(
        date,
        (total) => total + entry.amountMl,
        ifAbsent: () => entry.amountMl,
      );
    }

    final dailyTotals = List.generate(28, (index) {
      final date = firstDay.add(Duration(days: index));
      return DailyHydrationTotal(date: date, totalMl: totalsByDay[date] ?? 0);
    });

    var streak = 0;
    var cursor = today;
    if ((totalsByDay[today] ?? 0) < settings.dailyGoalMl) {
      cursor = today.subtract(const Duration(days: 1));
    }
    while ((totalsByDay[cursor] ?? 0) >= settings.dailyGoalMl) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return HydrationSnapshot(
      settings: settings,
      todayEntries: todayEntries,
      recentEntries: recent,
      dailyTotals: dailyTotals,
      streak: streak,
    );
  }

  @override
  Future<void> saveSettings(HydrationSettings settings) {
    if (settings.startMinute >= settings.endMinute) {
      throw ArgumentError(
        'The reminder start time must be before the end time.',
      );
    }
    return _localDataSource.saveSettings(settings);
  }

  @override
  Future<void> undoMostRecentDrink() =>
      _localDataSource.deleteMostRecentDrink();
}
