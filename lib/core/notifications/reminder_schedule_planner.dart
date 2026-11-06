import '../../features/hydration/domain/entities/hydration_settings.dart';

class ReminderSchedulePlanner {
  const ReminderSchedulePlanner();

  static const int maximumScheduledReminders = 48;

  List<DateTime> build({
    required HydrationSettings settings,
    required DateTime now,
    required DateTime? lastDrinkAt,
    required int todayTotalMl,
    int limit = maximumScheduledReminders,
  }) {
    if (!settings.remindersEnabled || limit <= 0) return const [];

    final interval = Duration(minutes: settings.reminderIntervalMinutes);
    var candidate = (lastDrinkAt ?? now).add(interval);
    final today = _startOfDay(now);

    if (_startOfDay(candidate).isBefore(today)) {
      candidate = _atMinute(today, settings.startMinute);
    }

    candidate = _normalize(
      candidate,
      settings: settings,
      now: now,
      todayGoalReached: todayTotalMl >= settings.dailyGoalMl,
    );

    while (!candidate.isAfter(now)) {
      candidate = _normalize(
        candidate.add(interval),
        settings: settings,
        now: now,
        todayGoalReached: todayTotalMl >= settings.dailyGoalMl,
      );
    }

    final reminders = <DateTime>[];
    while (reminders.length < limit) {
      reminders.add(candidate);
      candidate = _normalize(
        candidate.add(interval),
        settings: settings,
        now: now,
        todayGoalReached: todayTotalMl >= settings.dailyGoalMl,
      );
    }
    return reminders;
  }

  DateTime _normalize(
    DateTime candidate, {
    required HydrationSettings settings,
    required DateTime now,
    required bool todayGoalReached,
  }) {
    var value = candidate;
    while (true) {
      final day = _startOfDay(value);

      if (todayGoalReached && _sameDay(day, now)) {
        value = _atMinute(
          day.add(const Duration(days: 1)),
          settings.startMinute,
        );
        continue;
      }

      if (settings.skipWeekends &&
          (value.weekday == DateTime.saturday ||
              value.weekday == DateTime.sunday)) {
        value = _atMinute(
          day.add(const Duration(days: 1)),
          settings.startMinute,
        );
        continue;
      }

      final minute = value.hour * 60 + value.minute;
      if (minute < settings.startMinute) {
        value = _atMinute(day, settings.startMinute);
        continue;
      }
      if (minute > settings.endMinute) {
        value = _atMinute(
          day.add(const Duration(days: 1)),
          settings.startMinute,
        );
        continue;
      }
      return value;
    }
  }

  DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime _atMinute(DateTime day, int minute) {
    return DateTime(day.year, day.month, day.day, minute ~/ 60, minute % 60);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
