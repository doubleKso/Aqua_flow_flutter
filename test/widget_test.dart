import 'package:drink_water_daily_remainder/app/app.dart';
import 'package:drink_water_daily_remainder/core/notifications/notification_service.dart';
import 'package:drink_water_daily_remainder/features/hydration/domain/entities/hydration_snapshot.dart';
import 'package:drink_water_daily_remainder/features/hydration/domain/entities/hydration_settings.dart';
import 'package:drink_water_daily_remainder/features/hydration/presentation/controllers/hydration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHydrationController extends HydrationController {
  @override
  Future<HydrationViewState> build() async {
    final now = DateTime.now();
    final firstDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 27));
    return HydrationViewState(
      snapshot: HydrationSnapshot(
        settings: const HydrationSettings(),
        todayEntries: const [],
        recentEntries: const [],
        dailyTotals: List.generate(
          28,
          (index) => DailyHydrationTotal(
            date: firstDay.add(Duration(days: index)),
            totalMl: 0,
          ),
        ),
        streak: 0,
      ),
      permissionStatus: NotificationPermissionStatus.unavailable,
      pendingReminderCount: 0,
      selectedAmountMl: 250,
    );
  }
}

void main() {
  testWidgets('renders the hydration dashboard and primary action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hydrationControllerProvider.overrideWith(
            _FakeHydrationController.new,
          ),
        ],
        child: const AquaFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add 250 ml'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -550));
    await tester.pumpAndSettle();
    expect(find.text('Today’s sips'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.byIcon(Icons.water_drop_rounded), findsWidgets);
  });

  testWidgets('switches to the insights tab', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hydrationControllerProvider.overrideWith(
            _FakeHydrationController.new,
          ),
        ],
        child: const AquaFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();

    expect(find.text('Small sips add up to a steady rhythm.'), findsOneWidget);
    expect(find.text('WEEKLY FLOW'), findsOneWidget);
  });
}
