# Aqua Flow

A polished, offline-first Flutter hydration tracker with reliable native local reminders on iOS and Android.

The app replaces the original PWA/server scheduler with device-managed notifications. Flutter owns the schedule, Drift/SQLite stores the truth, and the operating system delivers reminders while the app is backgrounded or terminated.

## Features

- Animated liquid daily-progress dashboard
- Quick 150/250/350/500 ml intake and custom amounts
- Undo last drink and view today's timeline
- Weekly chart, 28-day history, daily average, goal days, and streaks
- Drink-reset reminder logic: logging water restarts the interval
- Native local notifications with device timezone support
- Rolling batch of 48 reminders, preserving headroom under iOS's 64-request limit
- Reminder window, interval, weekend pause, sound, permission status, and test alert
- System, light, and dark themes with an iOS-inspired liquid-glass UI
- Fully local data—no account, backend, internet connection, or tracking

## Architecture

The code follows the clean-architecture direction of the referenced starter:

```text
lib/
├── app/
│   ├── app.dart
│   └── theme/
├── core/
│   ├── database/
│   ├── notifications/
│   └── widgets/
└── features/hydration/
    ├── data/
    │   ├── datasources/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── controllers/
        ├── pages/
        └── widgets/
```

Key packages:

- `flutter_riverpod` for state and dependency wiring
- `drift` + SQLite for local persistence
- `flutter_local_notifications` for native delivery
- `timezone` + `flutter_timezone` for timezone-aware schedules

## Reminder behavior

With a 60-minute interval:

1. Drinking at 09:00 schedules the next reminder for 10:00.
2. If the user does not log water, the following reminders continue at 11:00, 12:00, and so on inside the configured window.
3. Logging water at 10:30 cancels and rebuilds the queue, making 11:30 the next reminder.
4. Reaching the daily goal cancels the rest of today's reminders; the next batch starts on the next eligible day.

The app never relies on `Timer.periodic` for background delivery.

## Run

Flutter is installed locally at `/Users/kkso/Downloads/SDK/flutter/bin/flutter` in the current development environment.

```bash
/Users/kkso/Downloads/SDK/flutter/bin/flutter pub get
/Users/kkso/Downloads/SDK/flutter/bin/dart run build_runner build
/Users/kkso/Downloads/SDK/flutter/bin/flutter run
```

## Quality checks

```bash
/Users/kkso/Downloads/SDK/flutter/bin/flutter analyze
/Users/kkso/Downloads/SDK/flutter/bin/flutter test
/Users/kkso/Downloads/SDK/flutter/bin/flutter build apk --debug
/Users/kkso/Downloads/SDK/flutter/bin/flutter build ios --debug --no-codesign
```

## Physical iPhone verification

Local notification delivery should be validated on a real iPhone:

1. Open Reminders and enable notifications.
2. Tap **Send test** and verify foreground presentation.
3. Temporarily choose a short interval for development testing.
4. Verify delivery with the app in the background, swiped away, and the phone locked.
5. Log a drink and confirm that the displayed next-reminder time resets.
6. Check Focus/Scheduled Summary if iOS accepts notifications but does not visibly present them.

iOS 15 is the minimum deployment target for the installed Xcode toolchain.

The current Xcode 27 beta reports a simulator-framework architecture packaging error even though `lipo` lists both `arm64` and `x86_64`; the physical-device iOS build completes successfully. This is isolated to the beta simulator toolchain.
