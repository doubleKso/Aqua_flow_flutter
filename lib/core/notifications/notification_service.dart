import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/hydration/domain/entities/hydration_settings.dart';
import 'reminder_schedule_planner.dart';

enum NotificationPermissionStatus { granted, denied, unavailable }

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw StateError('NotificationService must be initialized before runApp.');
});

class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this._planner = const ReminderSchedulePlanner(),
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const int _firstReminderId = 2000;
  static const int _testNotificationId = 9000;

  final FlutterLocalNotificationsPlugin _plugin;
  final ReminderSchedulePlanner _planner;

  String _timezoneName = 'Local time';
  bool _initialized = false;

  String get timezoneName => _timezoneName;

  Future<void> initialize() async {
    if (_initialized) return;

    timezone_data.initializeTimeZones();
    await _setDeviceTimezone();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const macOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: android,
        iOS: iOS,
        macOS: macOS,
      ),
    );
    _initialized = true;
  }

  Future<void> refreshTimezone() => _setDeviceTimezone();

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          true;
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return true;
  }

  Future<NotificationPermissionStatus> permissionStatus() async {
    if (kIsWeb) return NotificationPermissionStatus.unavailable;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      return status?.isEnabled == true
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.denied;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      final enabled = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      return enabled == false
          ? NotificationPermissionStatus.denied
          : NotificationPermissionStatus.granted;
    }
    return NotificationPermissionStatus.unavailable;
  }

  Future<List<DateTime>> reschedule({
    required HydrationSettings settings,
    required DateTime? lastDrinkAt,
    required int todayTotalMl,
  }) async {
    await initialize();
    await refreshTimezone();
    await cancelReminderSchedule();

    final plan = _planner.build(
      settings: settings,
      now: DateTime.now(),
      lastDrinkAt: lastDrinkAt,
      todayTotalMl: todayTotalMl,
    );
    if (!settings.remindersEnabled) return plan;

    for (var index = 0; index < plan.length; index++) {
      final date = plan[index];
      await _plugin.zonedSchedule(
        id: _firstReminderId + index,
        title: _titles[index % _titles.length],
        body: _bodies[index % _bodies.length],
        scheduledDate: tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
        ),
        notificationDetails: _details(settings.soundEnabled),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'hydration-reminder',
      );
    }
    return plan;
  }

  Future<void> cancelReminderSchedule() async {
    await Future.wait(
      List.generate(
        ReminderSchedulePlanner.maximumScheduledReminders,
        (index) => _plugin.cancel(id: _firstReminderId + index),
      ),
    );
  }

  Future<int> pendingReminderCount() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.where((item) {
      return item.id >= _firstReminderId &&
          item.id <
              _firstReminderId +
                  ReminderSchedulePlanner.maximumScheduledReminders;
    }).length;
  }

  DateTime? nextReminder({
    required HydrationSettings settings,
    required DateTime? lastDrinkAt,
    required int todayTotalMl,
  }) {
    final plan = _planner.build(
      settings: settings,
      now: DateTime.now(),
      lastDrinkAt: lastDrinkAt,
      todayTotalMl: todayTotalMl,
      limit: 1,
    );
    return plan.isEmpty ? null : plan.first;
  }

  Future<void> showTestNotification({bool playSound = true}) {
    return _plugin.show(
      id: _testNotificationId,
      title: 'Aqua Flow is ready',
      body: 'Your on-device hydration reminders are working.',
      notificationDetails: _details(playSound),
      payload: 'test-notification',
    );
  }

  NotificationDetails _details(bool playSound) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        playSound ? 'hydration_reminders_v1' : 'hydration_reminders_silent_v1',
        playSound ? 'Hydration reminders' : 'Silent hydration reminders',
        channelDescription: 'Gentle reminders to drink water',
        importance: Importance.high,
        priority: Priority.high,
        playSound: playSound,
        enableVibration: playSound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: playSound,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: playSound,
      ),
    );
  }

  Future<void> _setDeviceTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      _timezoneName = info.identifier;
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      _timezoneName = 'UTC';
      tz.setLocalLocation(tz.UTC);
    }
  }

  static const _titles = [
    'A little water break 💧',
    'Sip, reset, feel better',
    'Your body asked for water',
    'Keep your flow going',
  ];

  static const _bodies = [
    'A small glass now is an easy win for today.',
    'Pause for a moment and take a refreshing sip.',
    'Hydration helps your energy, focus, and mood.',
    'Open Aqua Flow when you drink—your next reminder will reset.',
  ];
}
