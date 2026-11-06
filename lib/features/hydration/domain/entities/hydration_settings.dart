enum AppThemePreference { system, light, dark }

class HydrationSettings {
  const HydrationSettings({
    this.dailyGoalMl = 2000,
    this.defaultDrinkMl = 250,
    this.reminderIntervalMinutes = 60,
    this.startMinute = 7 * 60,
    this.endMinute = 22 * 60,
    this.remindersEnabled = false,
    this.skipWeekends = false,
    this.soundEnabled = true,
    this.themePreference = AppThemePreference.system,
    this.timezone = 'Asia/Yangon',
  });

  final int dailyGoalMl;
  final int defaultDrinkMl;
  final int reminderIntervalMinutes;
  final int startMinute;
  final int endMinute;
  final bool remindersEnabled;
  final bool skipWeekends;
  final bool soundEnabled;
  final AppThemePreference themePreference;
  final String timezone;

  HydrationSettings copyWith({
    int? dailyGoalMl,
    int? defaultDrinkMl,
    int? reminderIntervalMinutes,
    int? startMinute,
    int? endMinute,
    bool? remindersEnabled,
    bool? skipWeekends,
    bool? soundEnabled,
    AppThemePreference? themePreference,
    String? timezone,
  }) {
    return HydrationSettings(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      defaultDrinkMl: defaultDrinkMl ?? this.defaultDrinkMl,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      skipWeekends: skipWeekends ?? this.skipWeekends,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      themePreference: themePreference ?? this.themePreference,
      timezone: timezone ?? this.timezone,
    );
  }
}
