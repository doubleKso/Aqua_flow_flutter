import 'hydration_entry.dart';
import 'hydration_settings.dart';

class DailyHydrationTotal {
  const DailyHydrationTotal({required this.date, required this.totalMl});

  final DateTime date;
  final int totalMl;
}

class HydrationSnapshot {
  const HydrationSnapshot({
    required this.settings,
    required this.todayEntries,
    required this.recentEntries,
    required this.dailyTotals,
    required this.streak,
  });

  final HydrationSettings settings;
  final List<HydrationEntry> todayEntries;
  final List<HydrationEntry> recentEntries;
  final List<DailyHydrationTotal> dailyTotals;
  final int streak;

  int get todayTotalMl =>
      todayEntries.fold(0, (sum, item) => sum + item.amountMl);

  int get remainingMl =>
      (settings.dailyGoalMl - todayTotalMl).clamp(0, settings.dailyGoalMl);

  double get progress => (todayTotalMl / settings.dailyGoalMl).clamp(0, 1);

  bool get goalReached => todayTotalMl >= settings.dailyGoalMl;

  HydrationEntry? get lastEntry =>
      recentEntries.isEmpty ? null : recentEntries.first;
}
