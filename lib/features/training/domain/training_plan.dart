import 'training_exercise_mode.dart';

enum TrainingScheduleMode { sameEveryDay, byWeekday }

enum TrainingWeekday {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  const TrainingWeekday(this.dateTimeWeekday);

  final int dateTimeWeekday;

  static TrainingWeekday fromDateTime(DateTime dateTime) {
    return values.firstWhere(
      (weekday) => weekday.dateTimeWeekday == dateTime.weekday,
      orElse: () => TrainingWeekday.monday,
    );
  }
}

class TrainingReminderTime {
  const TrainingReminderTime({required this.hour, required this.minute});

  final int hour;
  final int minute;

  String storageValue() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  static TrainingReminderTime fromStorage(String value) {
    final parts = value.split(':');
    return TrainingReminderTime(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class TrainingDayPlan {
  const TrainingDayPlan({
    required this.durationMinutes,
    required this.exerciseMode,
    this.reminderTimes = const [],
  });

  final int durationMinutes;
  final TrainingExerciseMode exerciseMode;
  final List<TrainingReminderTime> reminderTimes;

  bool get hasReminders => reminderTimes.isNotEmpty;

  TrainingDayPlan copyWith({
    int? durationMinutes,
    TrainingExerciseMode? exerciseMode,
    List<TrainingReminderTime>? reminderTimes,
  }) {
    return TrainingDayPlan(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exerciseMode: exerciseMode ?? this.exerciseMode,
      reminderTimes: reminderTimes ?? this.reminderTimes,
    );
  }

  static const defaults = TrainingDayPlan(
    durationMinutes: 10,
    exerciseMode: TrainingExerciseMode.general,
  );
}

class TrainingPlan {
  const TrainingPlan({
    required this.scheduleMode,
    required this.everydayPlan,
    required this.weekdayPlans,
    required this.updatedAt,
  });

  final TrainingScheduleMode scheduleMode;
  final TrainingDayPlan everydayPlan;
  final Map<TrainingWeekday, TrainingDayPlan> weekdayPlans;
  final DateTime updatedAt;

  static final defaults = TrainingPlan(
    scheduleMode: TrainingScheduleMode.sameEveryDay,
    everydayPlan: TrainingDayPlan.defaults,
    weekdayPlans: {
      for (final weekday in TrainingWeekday.values)
        weekday: TrainingDayPlan.defaults,
    },
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  TrainingPlan copyWith({
    TrainingScheduleMode? scheduleMode,
    TrainingDayPlan? everydayPlan,
    Map<TrainingWeekday, TrainingDayPlan>? weekdayPlans,
    DateTime? updatedAt,
  }) {
    return TrainingPlan(
      scheduleMode: scheduleMode ?? this.scheduleMode,
      everydayPlan: everydayPlan ?? this.everydayPlan,
      weekdayPlans: weekdayPlans ?? this.weekdayPlans,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  TrainingDayPlan resolveFor(DateTime date) {
    if (scheduleMode == TrainingScheduleMode.sameEveryDay) {
      return everydayPlan;
    }
    return weekdayPlans[TrainingWeekday.fromDateTime(date)] ??
        TrainingDayPlan.defaults;
  }
}
