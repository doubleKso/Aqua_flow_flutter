// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DrinkEntriesTable extends DrinkEntries
    with TableInfo<$DrinkEntriesTable, DrinkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrinkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumedAtMeta = const VerificationMeta(
    'consumedAt',
  );
  @override
  late final GeneratedColumn<DateTime> consumedAt = GeneratedColumn<DateTime>(
    'consumed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amountMl, consumedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drink_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrinkEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('consumed_at')) {
      context.handle(
        _consumedAtMeta,
        consumedAt.isAcceptableOrUnknown(data['consumed_at']!, _consumedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_consumedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrinkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrinkEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      )!,
      consumedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consumed_at'],
      )!,
    );
  }

  @override
  $DrinkEntriesTable createAlias(String alias) {
    return $DrinkEntriesTable(attachedDatabase, alias);
  }
}

class DrinkEntry extends DataClass implements Insertable<DrinkEntry> {
  final int id;
  final int amountMl;
  final DateTime consumedAt;
  const DrinkEntry({
    required this.id,
    required this.amountMl,
    required this.consumedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_ml'] = Variable<int>(amountMl);
    map['consumed_at'] = Variable<DateTime>(consumedAt);
    return map;
  }

  DrinkEntriesCompanion toCompanion(bool nullToAbsent) {
    return DrinkEntriesCompanion(
      id: Value(id),
      amountMl: Value(amountMl),
      consumedAt: Value(consumedAt),
    );
  }

  factory DrinkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrinkEntry(
      id: serializer.fromJson<int>(json['id']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      consumedAt: serializer.fromJson<DateTime>(json['consumedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountMl': serializer.toJson<int>(amountMl),
      'consumedAt': serializer.toJson<DateTime>(consumedAt),
    };
  }

  DrinkEntry copyWith({int? id, int? amountMl, DateTime? consumedAt}) =>
      DrinkEntry(
        id: id ?? this.id,
        amountMl: amountMl ?? this.amountMl,
        consumedAt: consumedAt ?? this.consumedAt,
      );
  DrinkEntry copyWithCompanion(DrinkEntriesCompanion data) {
    return DrinkEntry(
      id: data.id.present ? data.id.value : this.id,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      consumedAt: data.consumedAt.present
          ? data.consumedAt.value
          : this.consumedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrinkEntry(')
          ..write('id: $id, ')
          ..write('amountMl: $amountMl, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amountMl, consumedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrinkEntry &&
          other.id == this.id &&
          other.amountMl == this.amountMl &&
          other.consumedAt == this.consumedAt);
}

class DrinkEntriesCompanion extends UpdateCompanion<DrinkEntry> {
  final Value<int> id;
  final Value<int> amountMl;
  final Value<DateTime> consumedAt;
  const DrinkEntriesCompanion({
    this.id = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.consumedAt = const Value.absent(),
  });
  DrinkEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int amountMl,
    required DateTime consumedAt,
  }) : amountMl = Value(amountMl),
       consumedAt = Value(consumedAt);
  static Insertable<DrinkEntry> custom({
    Expression<int>? id,
    Expression<int>? amountMl,
    Expression<DateTime>? consumedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMl != null) 'amount_ml': amountMl,
      if (consumedAt != null) 'consumed_at': consumedAt,
    });
  }

  DrinkEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? amountMl,
    Value<DateTime>? consumedAt,
  }) {
    return DrinkEntriesCompanion(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (consumedAt.present) {
      map['consumed_at'] = Variable<DateTime>(consumedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrinkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('amountMl: $amountMl, ')
          ..write('consumedAt: $consumedAt')
          ..write(')'))
        .toString();
  }
}

class $HydrationPreferencesTable extends HydrationPreferences
    with TableInfo<$HydrationPreferencesTable, HydrationPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HydrationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dailyGoalMlMeta = const VerificationMeta(
    'dailyGoalMl',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMl = GeneratedColumn<int>(
    'daily_goal_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _defaultDrinkMlMeta = const VerificationMeta(
    'defaultDrinkMl',
  );
  @override
  late final GeneratedColumn<int> defaultDrinkMl = GeneratedColumn<int>(
    'default_drink_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(250),
  );
  static const VerificationMeta _reminderIntervalMinutesMeta =
      const VerificationMeta('reminderIntervalMinutes');
  @override
  late final GeneratedColumn<int> reminderIntervalMinutes =
      GeneratedColumn<int>(
        'reminder_interval_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(60),
      );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(420),
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1320),
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _skipWeekendsMeta = const VerificationMeta(
    'skipWeekends',
  );
  @override
  late final GeneratedColumn<bool> skipWeekends = GeneratedColumn<bool>(
    'skip_weekends',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skip_weekends" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Asia/Yangon'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyGoalMl,
    defaultDrinkMl,
    reminderIntervalMinutes,
    startMinute,
    endMinute,
    remindersEnabled,
    skipWeekends,
    soundEnabled,
    themePreference,
    timezone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hydration_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<HydrationPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_goal_ml')) {
      context.handle(
        _dailyGoalMlMeta,
        dailyGoalMl.isAcceptableOrUnknown(
          data['daily_goal_ml']!,
          _dailyGoalMlMeta,
        ),
      );
    }
    if (data.containsKey('default_drink_ml')) {
      context.handle(
        _defaultDrinkMlMeta,
        defaultDrinkMl.isAcceptableOrUnknown(
          data['default_drink_ml']!,
          _defaultDrinkMlMeta,
        ),
      );
    }
    if (data.containsKey('reminder_interval_minutes')) {
      context.handle(
        _reminderIntervalMinutesMeta,
        reminderIntervalMinutes.isAcceptableOrUnknown(
          data['reminder_interval_minutes']!,
          _reminderIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('skip_weekends')) {
      context.handle(
        _skipWeekendsMeta,
        skipWeekends.isAcceptableOrUnknown(
          data['skip_weekends']!,
          _skipWeekendsMeta,
        ),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HydrationPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HydrationPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyGoalMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_ml'],
      )!,
      defaultDrinkMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_drink_ml'],
      )!,
      reminderIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_interval_minutes'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      skipWeekends: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skip_weekends'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
    );
  }

  @override
  $HydrationPreferencesTable createAlias(String alias) {
    return $HydrationPreferencesTable(attachedDatabase, alias);
  }
}

class HydrationPreference extends DataClass
    implements Insertable<HydrationPreference> {
  final int id;
  final int dailyGoalMl;
  final int defaultDrinkMl;
  final int reminderIntervalMinutes;
  final int startMinute;
  final int endMinute;
  final bool remindersEnabled;
  final bool skipWeekends;
  final bool soundEnabled;
  final String themePreference;
  final String timezone;
  const HydrationPreference({
    required this.id,
    required this.dailyGoalMl,
    required this.defaultDrinkMl,
    required this.reminderIntervalMinutes,
    required this.startMinute,
    required this.endMinute,
    required this.remindersEnabled,
    required this.skipWeekends,
    required this.soundEnabled,
    required this.themePreference,
    required this.timezone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_goal_ml'] = Variable<int>(dailyGoalMl);
    map['default_drink_ml'] = Variable<int>(defaultDrinkMl);
    map['reminder_interval_minutes'] = Variable<int>(reminderIntervalMinutes);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['skip_weekends'] = Variable<bool>(skipWeekends);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['theme_preference'] = Variable<String>(themePreference);
    map['timezone'] = Variable<String>(timezone);
    return map;
  }

  HydrationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return HydrationPreferencesCompanion(
      id: Value(id),
      dailyGoalMl: Value(dailyGoalMl),
      defaultDrinkMl: Value(defaultDrinkMl),
      reminderIntervalMinutes: Value(reminderIntervalMinutes),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      remindersEnabled: Value(remindersEnabled),
      skipWeekends: Value(skipWeekends),
      soundEnabled: Value(soundEnabled),
      themePreference: Value(themePreference),
      timezone: Value(timezone),
    );
  }

  factory HydrationPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HydrationPreference(
      id: serializer.fromJson<int>(json['id']),
      dailyGoalMl: serializer.fromJson<int>(json['dailyGoalMl']),
      defaultDrinkMl: serializer.fromJson<int>(json['defaultDrinkMl']),
      reminderIntervalMinutes: serializer.fromJson<int>(
        json['reminderIntervalMinutes'],
      ),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      skipWeekends: serializer.fromJson<bool>(json['skipWeekends']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      timezone: serializer.fromJson<String>(json['timezone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyGoalMl': serializer.toJson<int>(dailyGoalMl),
      'defaultDrinkMl': serializer.toJson<int>(defaultDrinkMl),
      'reminderIntervalMinutes': serializer.toJson<int>(
        reminderIntervalMinutes,
      ),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'skipWeekends': serializer.toJson<bool>(skipWeekends),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'themePreference': serializer.toJson<String>(themePreference),
      'timezone': serializer.toJson<String>(timezone),
    };
  }

  HydrationPreference copyWith({
    int? id,
    int? dailyGoalMl,
    int? defaultDrinkMl,
    int? reminderIntervalMinutes,
    int? startMinute,
    int? endMinute,
    bool? remindersEnabled,
    bool? skipWeekends,
    bool? soundEnabled,
    String? themePreference,
    String? timezone,
  }) => HydrationPreference(
    id: id ?? this.id,
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
  HydrationPreference copyWithCompanion(HydrationPreferencesCompanion data) {
    return HydrationPreference(
      id: data.id.present ? data.id.value : this.id,
      dailyGoalMl: data.dailyGoalMl.present
          ? data.dailyGoalMl.value
          : this.dailyGoalMl,
      defaultDrinkMl: data.defaultDrinkMl.present
          ? data.defaultDrinkMl.value
          : this.defaultDrinkMl,
      reminderIntervalMinutes: data.reminderIntervalMinutes.present
          ? data.reminderIntervalMinutes.value
          : this.reminderIntervalMinutes,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      skipWeekends: data.skipWeekends.present
          ? data.skipWeekends.value
          : this.skipWeekends,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HydrationPreference(')
          ..write('id: $id, ')
          ..write('dailyGoalMl: $dailyGoalMl, ')
          ..write('defaultDrinkMl: $defaultDrinkMl, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('skipWeekends: $skipWeekends, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('themePreference: $themePreference, ')
          ..write('timezone: $timezone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyGoalMl,
    defaultDrinkMl,
    reminderIntervalMinutes,
    startMinute,
    endMinute,
    remindersEnabled,
    skipWeekends,
    soundEnabled,
    themePreference,
    timezone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HydrationPreference &&
          other.id == this.id &&
          other.dailyGoalMl == this.dailyGoalMl &&
          other.defaultDrinkMl == this.defaultDrinkMl &&
          other.reminderIntervalMinutes == this.reminderIntervalMinutes &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.remindersEnabled == this.remindersEnabled &&
          other.skipWeekends == this.skipWeekends &&
          other.soundEnabled == this.soundEnabled &&
          other.themePreference == this.themePreference &&
          other.timezone == this.timezone);
}

class HydrationPreferencesCompanion
    extends UpdateCompanion<HydrationPreference> {
  final Value<int> id;
  final Value<int> dailyGoalMl;
  final Value<int> defaultDrinkMl;
  final Value<int> reminderIntervalMinutes;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<bool> remindersEnabled;
  final Value<bool> skipWeekends;
  final Value<bool> soundEnabled;
  final Value<String> themePreference;
  final Value<String> timezone;
  const HydrationPreferencesCompanion({
    this.id = const Value.absent(),
    this.dailyGoalMl = const Value.absent(),
    this.defaultDrinkMl = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.skipWeekends = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.timezone = const Value.absent(),
  });
  HydrationPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.dailyGoalMl = const Value.absent(),
    this.defaultDrinkMl = const Value.absent(),
    this.reminderIntervalMinutes = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.skipWeekends = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.timezone = const Value.absent(),
  });
  static Insertable<HydrationPreference> custom({
    Expression<int>? id,
    Expression<int>? dailyGoalMl,
    Expression<int>? defaultDrinkMl,
    Expression<int>? reminderIntervalMinutes,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<bool>? remindersEnabled,
    Expression<bool>? skipWeekends,
    Expression<bool>? soundEnabled,
    Expression<String>? themePreference,
    Expression<String>? timezone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyGoalMl != null) 'daily_goal_ml': dailyGoalMl,
      if (defaultDrinkMl != null) 'default_drink_ml': defaultDrinkMl,
      if (reminderIntervalMinutes != null)
        'reminder_interval_minutes': reminderIntervalMinutes,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (skipWeekends != null) 'skip_weekends': skipWeekends,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (themePreference != null) 'theme_preference': themePreference,
      if (timezone != null) 'timezone': timezone,
    });
  }

  HydrationPreferencesCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyGoalMl,
    Value<int>? defaultDrinkMl,
    Value<int>? reminderIntervalMinutes,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<bool>? remindersEnabled,
    Value<bool>? skipWeekends,
    Value<bool>? soundEnabled,
    Value<String>? themePreference,
    Value<String>? timezone,
  }) {
    return HydrationPreferencesCompanion(
      id: id ?? this.id,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyGoalMl.present) {
      map['daily_goal_ml'] = Variable<int>(dailyGoalMl.value);
    }
    if (defaultDrinkMl.present) {
      map['default_drink_ml'] = Variable<int>(defaultDrinkMl.value);
    }
    if (reminderIntervalMinutes.present) {
      map['reminder_interval_minutes'] = Variable<int>(
        reminderIntervalMinutes.value,
      );
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (skipWeekends.present) {
      map['skip_weekends'] = Variable<bool>(skipWeekends.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('dailyGoalMl: $dailyGoalMl, ')
          ..write('defaultDrinkMl: $defaultDrinkMl, ')
          ..write('reminderIntervalMinutes: $reminderIntervalMinutes, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('skipWeekends: $skipWeekends, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('themePreference: $themePreference, ')
          ..write('timezone: $timezone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DrinkEntriesTable drinkEntries = $DrinkEntriesTable(this);
  late final $HydrationPreferencesTable hydrationPreferences =
      $HydrationPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    drinkEntries,
    hydrationPreferences,
  ];
}

typedef $$DrinkEntriesTableCreateCompanionBuilder =
    DrinkEntriesCompanion Function({
      Value<int> id,
      required int amountMl,
      required DateTime consumedAt,
    });
typedef $$DrinkEntriesTableUpdateCompanionBuilder =
    DrinkEntriesCompanion Function({
      Value<int> id,
      Value<int> amountMl,
      Value<DateTime> consumedAt,
    });

class $$DrinkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DrinkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrinkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrinkEntriesTable> {
  $$DrinkEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => column,
  );
}

class $$DrinkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrinkEntriesTable,
          DrinkEntry,
          $$DrinkEntriesTableFilterComposer,
          $$DrinkEntriesTableOrderingComposer,
          $$DrinkEntriesTableAnnotationComposer,
          $$DrinkEntriesTableCreateCompanionBuilder,
          $$DrinkEntriesTableUpdateCompanionBuilder,
          (
            DrinkEntry,
            BaseReferences<_$AppDatabase, $DrinkEntriesTable, DrinkEntry>,
          ),
          DrinkEntry,
          PrefetchHooks Function()
        > {
  $$DrinkEntriesTableTableManager(_$AppDatabase db, $DrinkEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrinkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrinkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrinkEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountMl = const Value.absent(),
                Value<DateTime> consumedAt = const Value.absent(),
              }) => DrinkEntriesCompanion(
                id: id,
                amountMl: amountMl,
                consumedAt: consumedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountMl,
                required DateTime consumedAt,
              }) => DrinkEntriesCompanion.insert(
                id: id,
                amountMl: amountMl,
                consumedAt: consumedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DrinkEntriesTable, DrinkEntry>(table),
                  BaseReferences<_$AppDatabase, $DrinkEntriesTable, DrinkEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DrinkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrinkEntriesTable,
      DrinkEntry,
      $$DrinkEntriesTableFilterComposer,
      $$DrinkEntriesTableOrderingComposer,
      $$DrinkEntriesTableAnnotationComposer,
      $$DrinkEntriesTableCreateCompanionBuilder,
      $$DrinkEntriesTableUpdateCompanionBuilder,
      (
        DrinkEntry,
        BaseReferences<_$AppDatabase, $DrinkEntriesTable, DrinkEntry>,
      ),
      DrinkEntry,
      PrefetchHooks Function()
    >;
typedef $$HydrationPreferencesTableCreateCompanionBuilder =
    HydrationPreferencesCompanion Function({
      Value<int> id,
      Value<int> dailyGoalMl,
      Value<int> defaultDrinkMl,
      Value<int> reminderIntervalMinutes,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<bool> remindersEnabled,
      Value<bool> skipWeekends,
      Value<bool> soundEnabled,
      Value<String> themePreference,
      Value<String> timezone,
    });
typedef $$HydrationPreferencesTableUpdateCompanionBuilder =
    HydrationPreferencesCompanion Function({
      Value<int> id,
      Value<int> dailyGoalMl,
      Value<int> defaultDrinkMl,
      Value<int> reminderIntervalMinutes,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<bool> remindersEnabled,
      Value<bool> skipWeekends,
      Value<bool> soundEnabled,
      Value<String> themePreference,
      Value<String> timezone,
    });

class $$HydrationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $HydrationPreferencesTable> {
  $$HydrationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultDrinkMl => $composableBuilder(
    column: $table.defaultDrinkMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipWeekends => $composableBuilder(
    column: $table.skipWeekends,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HydrationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $HydrationPreferencesTable> {
  $$HydrationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultDrinkMl => $composableBuilder(
    column: $table.defaultDrinkMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipWeekends => $composableBuilder(
    column: $table.skipWeekends,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HydrationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HydrationPreferencesTable> {
  $$HydrationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyGoalMl => $composableBuilder(
    column: $table.dailyGoalMl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultDrinkMl => $composableBuilder(
    column: $table.defaultDrinkMl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderIntervalMinutes => $composableBuilder(
    column: $table.reminderIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipWeekends => $composableBuilder(
    column: $table.skipWeekends,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);
}

class $$HydrationPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HydrationPreferencesTable,
          HydrationPreference,
          $$HydrationPreferencesTableFilterComposer,
          $$HydrationPreferencesTableOrderingComposer,
          $$HydrationPreferencesTableAnnotationComposer,
          $$HydrationPreferencesTableCreateCompanionBuilder,
          $$HydrationPreferencesTableUpdateCompanionBuilder,
          (
            HydrationPreference,
            BaseReferences<
              _$AppDatabase,
              $HydrationPreferencesTable,
              HydrationPreference
            >,
          ),
          HydrationPreference,
          PrefetchHooks Function()
        > {
  $$HydrationPreferencesTableTableManager(
    _$AppDatabase db,
    $HydrationPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HydrationPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HydrationPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HydrationPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoalMl = const Value.absent(),
                Value<int> defaultDrinkMl = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> skipWeekends = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<String> timezone = const Value.absent(),
              }) => HydrationPreferencesCompanion(
                id: id,
                dailyGoalMl: dailyGoalMl,
                defaultDrinkMl: defaultDrinkMl,
                reminderIntervalMinutes: reminderIntervalMinutes,
                startMinute: startMinute,
                endMinute: endMinute,
                remindersEnabled: remindersEnabled,
                skipWeekends: skipWeekends,
                soundEnabled: soundEnabled,
                themePreference: themePreference,
                timezone: timezone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoalMl = const Value.absent(),
                Value<int> defaultDrinkMl = const Value.absent(),
                Value<int> reminderIntervalMinutes = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> skipWeekends = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<String> timezone = const Value.absent(),
              }) => HydrationPreferencesCompanion.insert(
                id: id,
                dailyGoalMl: dailyGoalMl,
                defaultDrinkMl: defaultDrinkMl,
                reminderIntervalMinutes: reminderIntervalMinutes,
                startMinute: startMinute,
                endMinute: endMinute,
                remindersEnabled: remindersEnabled,
                skipWeekends: skipWeekends,
                soundEnabled: soundEnabled,
                themePreference: themePreference,
                timezone: timezone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HydrationPreferencesTable, HydrationPreference>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $HydrationPreferencesTable,
                    HydrationPreference
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HydrationPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HydrationPreferencesTable,
      HydrationPreference,
      $$HydrationPreferencesTableFilterComposer,
      $$HydrationPreferencesTableOrderingComposer,
      $$HydrationPreferencesTableAnnotationComposer,
      $$HydrationPreferencesTableCreateCompanionBuilder,
      $$HydrationPreferencesTableUpdateCompanionBuilder,
      (
        HydrationPreference,
        BaseReferences<
          _$AppDatabase,
          $HydrationPreferencesTable,
          HydrationPreference
        >,
      ),
      HydrationPreference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DrinkEntriesTableTableManager get drinkEntries =>
      $$DrinkEntriesTableTableManager(_db, _db.drinkEntries);
  $$HydrationPreferencesTableTableManager get hydrationPreferences =>
      $$HydrationPreferencesTableTableManager(_db, _db.hydrationPreferences);
}
