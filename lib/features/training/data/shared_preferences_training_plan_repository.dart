import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/training_exercise_mode.dart';
import '../domain/training_plan.dart';
import '../domain/training_plan_repository.dart';

class SharedPreferencesTrainingPlanRepository
    implements TrainingPlanRepository {
  SharedPreferencesTrainingPlanRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _planKey = 'training.plan';
  static const _scheduledIdsKey = 'training.scheduled_notification_ids';

  @override
  TrainingPlan load() {
    final raw = _preferences.getString(_planKey);
    if (raw == null || raw.isEmpty) {
      return TrainingPlan.defaults;
    }
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final scheduleMode = switch (json['scheduleMode'] as String?) {
      'byWeekday' => TrainingScheduleMode.byWeekday,
      _ => TrainingScheduleMode.sameEveryDay,
    };
    return TrainingPlan(
      scheduleMode: scheduleMode,
      everydayPlan: _decodeDayPlan(
        json['everydayPlan'] as Map<String, dynamic>? ?? const {},
      ),
      weekdayPlans: {
        for (final weekday in TrainingWeekday.values)
          weekday: _decodeDayPlan(
            (json['weekdayPlans'] as Map<String, dynamic>? ??
                        const {})[weekday.name]
                    as Map<String, dynamic>? ??
                const {},
          ),
      },
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updatedAt'] as int? ?? 0,
      ),
    );
  }

  @override
  Future<void> save(TrainingPlan plan) async {
    await _preferences.setString(
      _planKey,
      jsonEncode({
        'scheduleMode': plan.scheduleMode.name,
        'everydayPlan': _encodeDayPlan(plan.everydayPlan),
        'weekdayPlans': {
          for (final entry in plan.weekdayPlans.entries)
            entry.key.name: _encodeDayPlan(entry.value),
        },
        'updatedAt': plan.updatedAt.millisecondsSinceEpoch,
      }),
    );
  }

  @override
  List<int> loadScheduledNotificationIds() =>
      _preferences.getStringList(_scheduledIdsKey)?.map(int.parse).toList() ??
      const [];

  @override
  Future<void> saveScheduledNotificationIds(List<int> ids) async {
    await _preferences.setStringList(
      _scheduledIdsKey,
      ids.map((id) => id.toString()).toList(growable: false),
    );
  }

  Map<String, dynamic> _encodeDayPlan(TrainingDayPlan plan) {
    return {
      'durationMinutes': plan.durationMinutes,
      'exerciseMode': plan.exerciseMode.storageValue,
      'reminderTimes': plan.reminderTimes
          .map((time) => time.storageValue())
          .toList(growable: false),
    };
  }

  TrainingDayPlan _decodeDayPlan(Map<String, dynamic> json) {
    return TrainingDayPlan(
      durationMinutes:
          json['durationMinutes'] as int? ??
          TrainingDayPlan.defaults.durationMinutes,
      exerciseMode: TrainingExerciseMode.fromStorage(
        json['exerciseMode'] as String? ??
            TrainingDayPlan.defaults.exerciseMode.storageValue,
      ),
      reminderTimes: (json['reminderTimes'] as List<dynamic>? ?? const [])
          .map((entry) => TrainingReminderTime.fromStorage(entry as String))
          .toList(growable: false),
    );
  }
}
