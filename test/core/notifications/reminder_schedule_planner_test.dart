import 'package:drink_water_daily_remainder/core/notifications/reminder_schedule_planner.dart';
import 'package:drink_water_daily_remainder/features/hydration/domain/entities/hydration_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const planner = ReminderSchedulePlanner();
  const enabled = HydrationSettings(remindersEnabled: true);

  test('drink reset anchors the next reminder to the latest drink', () {
    final reminders = planner.build(
      settings: enabled,
      now: DateTime(2026, 11, 6, 9, 15),
      lastDrinkAt: DateTime(2026, 11, 6, 9),
      todayTotalMl: 250,
      limit: 3,
    );

    expect(reminders, [
      DateTime(2026, 11, 6, 10),
      DateTime(2026, 11, 6, 11),
      DateTime(2026, 11, 6, 12),
    ]);
  });

  test('schedule moves to the next morning after the daily window', () {
    final reminders = planner.build(
      settings: enabled,
      now: DateTime(2026, 11, 6, 21, 30),
      lastDrinkAt: DateTime(2026, 11, 6, 21, 30),
      todayTotalMl: 1000,
      limit: 2,
    );

    expect(reminders.first, DateTime(2026, 11, 7, 7));
    expect(reminders.last, DateTime(2026, 11, 7, 8));
  });

  test('reaching the daily goal skips the rest of today', () {
    final reminders = planner.build(
      settings: enabled,
      now: DateTime(2026, 11, 6, 10),
      lastDrinkAt: DateTime(2026, 11, 6, 9, 45),
      todayTotalMl: 2000,
      limit: 1,
    );

    expect(reminders.single, DateTime(2026, 11, 7, 7));
  });

  test('weekend pause advances to Monday', () {
    final reminders = planner.build(
      settings: enabled.copyWith(skipWeekends: true),
      now: DateTime(2026, 11, 6, 21, 30), // Friday
      lastDrinkAt: DateTime(2026, 11, 6, 21, 30),
      todayTotalMl: 500,
      limit: 1,
    );

    expect(reminders.single, DateTime(2026, 11, 9, 7));
  });

  test('uses 48 slots and never exceeds the iOS allocation', () {
    final reminders = planner.build(
      settings: enabled,
      now: DateTime(2026, 11, 6, 8),
      lastDrinkAt: null,
      todayTotalMl: 0,
    );

    expect(reminders, hasLength(48));
    expect(reminders.toSet(), hasLength(48));
  });

  test('disabled reminders produce an empty plan', () {
    final reminders = planner.build(
      settings: const HydrationSettings(),
      now: DateTime(2026, 11, 6, 8),
      lastDrinkAt: null,
      todayTotalMl: 0,
    );

    expect(reminders, isEmpty);
  });
}
