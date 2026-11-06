import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../data/datasources/hydration_local_data_source.dart';
import '../../data/repositories/hydration_repository_impl.dart';
import '../../domain/entities/hydration_settings.dart';
import '../../domain/entities/hydration_snapshot.dart';
import '../../domain/repositories/hydration_repository.dart';
import '../../domain/usecases/hydration_usecases.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
});

final hydrationLocalDataSourceProvider = Provider<HydrationLocalDataSource>((
  ref,
) {
  return HydrationLocalDataSource(ref.watch(databaseProvider));
});

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  return HydrationRepositoryImpl(ref.watch(hydrationLocalDataSourceProvider));
});

final loadHydrationProvider = Provider<LoadHydrationUseCase>((ref) {
  return LoadHydrationUseCase(ref.watch(hydrationRepositoryProvider));
});

final addDrinkProvider = Provider<AddDrinkUseCase>((ref) {
  return AddDrinkUseCase(ref.watch(hydrationRepositoryProvider));
});

final undoDrinkProvider = Provider<UndoDrinkUseCase>((ref) {
  return UndoDrinkUseCase(ref.watch(hydrationRepositoryProvider));
});

final saveHydrationSettingsProvider = Provider<SaveHydrationSettingsUseCase>((
  ref,
) {
  return SaveHydrationSettingsUseCase(ref.watch(hydrationRepositoryProvider));
});

final hydrationControllerProvider =
    AsyncNotifierProvider<HydrationController, HydrationViewState>(
      HydrationController.new,
    );

class HydrationViewState {
  const HydrationViewState({
    required this.snapshot,
    required this.permissionStatus,
    required this.pendingReminderCount,
    required this.selectedAmountMl,
    this.nextReminder,
    this.isSaving = false,
    this.notice,
  });

  final HydrationSnapshot snapshot;
  final NotificationPermissionStatus permissionStatus;
  final int pendingReminderCount;
  final int selectedAmountMl;
  final DateTime? nextReminder;
  final bool isSaving;
  final String? notice;

  HydrationViewState copyWith({
    HydrationSnapshot? snapshot,
    NotificationPermissionStatus? permissionStatus,
    int? pendingReminderCount,
    int? selectedAmountMl,
    DateTime? nextReminder,
    bool clearNextReminder = false,
    bool? isSaving,
    String? notice,
    bool clearNotice = false,
  }) {
    return HydrationViewState(
      snapshot: snapshot ?? this.snapshot,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      pendingReminderCount: pendingReminderCount ?? this.pendingReminderCount,
      selectedAmountMl: selectedAmountMl ?? this.selectedAmountMl,
      nextReminder: clearNextReminder
          ? null
          : nextReminder ?? this.nextReminder,
      isSaving: isSaving ?? this.isSaving,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }
}

class HydrationController extends AsyncNotifier<HydrationViewState> {
  NotificationService get _notifications =>
      ref.read(notificationServiceProvider);

  @override
  Future<HydrationViewState> build() async {
    var snapshot = await ref.read(loadHydrationProvider)();
    await _notifications.refreshTimezone();
    if (snapshot.settings.timezone != _notifications.timezoneName) {
      final updated = snapshot.settings.copyWith(
        timezone: _notifications.timezoneName,
      );
      await ref.read(saveHydrationSettingsProvider)(updated);
      snapshot = await ref.read(loadHydrationProvider)();
    }

    final permission = await _notifications.permissionStatus();
    if (snapshot.settings.remindersEnabled &&
        permission == NotificationPermissionStatus.granted) {
      await _notifications.reschedule(
        settings: snapshot.settings,
        lastDrinkAt: snapshot.lastEntry?.consumedAt,
        todayTotalMl: snapshot.todayTotalMl,
      );
    }

    return _viewState(snapshot, permission: permission);
  }

  Future<void> refresh({bool reconcileSchedule = true}) async {
    final current = state.value;
    if (current == null) return;
    await _runMutation(() async {}, reconcileSchedule: reconcileSchedule);
  }

  void selectAmount(int amountMl) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(selectedAmountMl: amountMl, clearNotice: true),
    );
  }

  Future<void> addSelectedDrink() async {
    final current = state.value;
    if (current == null) return;
    final reachedBefore = current.snapshot.goalReached;
    await _runMutation(
      () => ref.read(addDrinkProvider)(current.selectedAmountMl),
    );
    final updated = state.value;
    if (updated != null && !reachedBefore && updated.snapshot.goalReached) {
      state = AsyncData(
        updated.copyWith(notice: 'Daily goal reached—beautiful work! 🎉'),
      );
    }
  }

  Future<void> addCustomDrink(int amountMl) async {
    selectAmount(amountMl);
    await addSelectedDrink();
  }

  Future<void> undoMostRecentDrink() {
    return _runMutation(
      () => ref.read(undoDrinkProvider)(),
      notice: 'Last drink removed',
    );
  }

  Future<void> saveSettings(HydrationSettings settings) {
    return _runMutation(
      () => ref.read(saveHydrationSettingsProvider)(settings),
      notice: 'Preferences saved',
    );
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    final current = state.value;
    if (current == null) return;

    if (enabled) {
      final granted = await _notifications.requestPermission();
      if (!granted) {
        final permission = await _notifications.permissionStatus();
        state = AsyncData(
          current.copyWith(
            permissionStatus: permission,
            notice: 'Notification permission is needed to enable reminders.',
          ),
        );
        return;
      }
    }

    await _runMutation(
      () => ref.read(saveHydrationSettingsProvider)(
        current.snapshot.settings.copyWith(remindersEnabled: enabled),
      ),
      notice: enabled ? 'Reminders are ready' : 'Reminders paused',
    );
  }

  Future<void> sendTestNotification() async {
    final current = state.value;
    if (current == null) return;
    var permission = await _notifications.permissionStatus();
    if (permission != NotificationPermissionStatus.granted) {
      final granted = await _notifications.requestPermission();
      if (!granted) {
        state = AsyncData(
          current.copyWith(
            notice: 'Allow notifications in system settings first.',
          ),
        );
        return;
      }
      permission = NotificationPermissionStatus.granted;
    }
    await _notifications.showTestNotification(
      playSound: current.snapshot.settings.soundEnabled,
    );
    state = AsyncData(
      current.copyWith(
        permissionStatus: permission,
        notice: 'Test reminder sent',
      ),
    );
  }

  void clearNotice() {
    final current = state.value;
    if (current != null) state = AsyncData(current.copyWith(clearNotice: true));
  }

  Future<void> _runMutation(
    Future<void> Function() mutation, {
    bool reconcileSchedule = true,
    String? notice,
  }) async {
    final current = state.value;
    if (current == null || current.isSaving) return;
    state = AsyncData(current.copyWith(isSaving: true, clearNotice: true));
    try {
      await mutation();
      final snapshot = await ref.read(loadHydrationProvider)();
      final permission = await _notifications.permissionStatus();
      if (reconcileSchedule) {
        await _notifications.reschedule(
          settings: snapshot.settings,
          lastDrinkAt: snapshot.lastEntry?.consumedAt,
          todayTotalMl: snapshot.todayTotalMl,
        );
      }
      state = AsyncData(
        await _viewState(
          snapshot,
          permission: permission,
          selectedAmountMl: current.selectedAmountMl,
          notice: notice,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<HydrationViewState> _viewState(
    HydrationSnapshot snapshot, {
    required NotificationPermissionStatus permission,
    int? selectedAmountMl,
    String? notice,
  }) async {
    final pending = await _notifications.pendingReminderCount();
    final next = _notifications.nextReminder(
      settings: snapshot.settings,
      lastDrinkAt: snapshot.lastEntry?.consumedAt,
      todayTotalMl: snapshot.todayTotalMl,
    );
    return HydrationViewState(
      snapshot: snapshot,
      permissionStatus: permission,
      pendingReminderCount: pending,
      selectedAmountMl: selectedAmountMl ?? snapshot.settings.defaultDrinkMl,
      nextReminder: next,
      notice: notice,
    );
  }
}
