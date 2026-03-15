import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../sync/application/sync_controller.dart';
import '../domain/training_exercise_mode.dart';
import '../domain/training_plan.dart';

final trainingPlanControllerProvider =
    NotifierProvider<TrainingPlanController, TrainingPlan>(
      TrainingPlanController.new,
    );

final todayTrainingDayPlanProvider = Provider<TrainingDayPlan>((ref) {
  final plan = ref.watch(trainingPlanControllerProvider);
  return plan.resolveFor(DateTime.now());
});

class TrainingPlanController extends Notifier<TrainingPlan> {
  @override
  TrainingPlan build() {
    return ref.watch(trainingPlanRepositoryProvider).load();
  }

  Future<void> setScheduleMode(TrainingScheduleMode mode) async {
    await _save(state.copyWith(scheduleMode: mode));
  }

  Future<void> setEverydayDuration(int durationMinutes) async {
    await _save(
      state.copyWith(
        everydayPlan: state.everydayPlan.copyWith(
          durationMinutes: durationMinutes,
        ),
      ),
    );
  }

  Future<void> setEverydayExerciseMode(TrainingExerciseMode mode) async {
    await _save(
      state.copyWith(
        everydayPlan: state.everydayPlan.copyWith(exerciseMode: mode),
      ),
    );
  }

  Future<void> addEverydayReminder(TrainingReminderTime time) async {
    final reminders = [...state.everydayPlan.reminderTimes, time]
      ..sort((a, b) => _compareTimes(a, b));
    await _save(
      state.copyWith(
        everydayPlan: state.everydayPlan.copyWith(reminderTimes: reminders),
      ),
    );
  }

  Future<void> removeEverydayReminder(TrainingReminderTime time) async {
    final reminders = state.everydayPlan.reminderTimes
        .where((entry) => entry.storageValue() != time.storageValue())
        .toList(growable: false);
    await _save(
      state.copyWith(
        everydayPlan: state.everydayPlan.copyWith(reminderTimes: reminders),
      ),
    );
  }

  Future<void> setWeekdayDuration(
    TrainingWeekday weekday,
    int durationMinutes,
  ) async {
    await _save(
      state.copyWith(
        weekdayPlans: {
          ...state.weekdayPlans,
          weekday: (state.weekdayPlans[weekday] ?? TrainingDayPlan.defaults)
              .copyWith(durationMinutes: durationMinutes),
        },
      ),
    );
  }

  Future<void> setWeekdayExerciseMode(
    TrainingWeekday weekday,
    TrainingExerciseMode mode,
  ) async {
    await _save(
      state.copyWith(
        weekdayPlans: {
          ...state.weekdayPlans,
          weekday: (state.weekdayPlans[weekday] ?? TrainingDayPlan.defaults)
              .copyWith(exerciseMode: mode),
        },
      ),
    );
  }

  Future<void> addWeekdayReminder(
    TrainingWeekday weekday,
    TrainingReminderTime time,
  ) async {
    final existing = state.weekdayPlans[weekday] ?? TrainingDayPlan.defaults;
    final reminders = [...existing.reminderTimes, time]
      ..sort((a, b) => _compareTimes(a, b));
    await _save(
      state.copyWith(
        weekdayPlans: {
          ...state.weekdayPlans,
          weekday: existing.copyWith(reminderTimes: reminders),
        },
      ),
    );
  }

  Future<void> removeWeekdayReminder(
    TrainingWeekday weekday,
    TrainingReminderTime time,
  ) async {
    final existing = state.weekdayPlans[weekday] ?? TrainingDayPlan.defaults;
    final reminders = existing.reminderTimes
        .where((entry) => entry.storageValue() != time.storageValue())
        .toList(growable: false);
    await _save(
      state.copyWith(
        weekdayPlans: {
          ...state.weekdayPlans,
          weekday: existing.copyWith(reminderTimes: reminders),
        },
      ),
    );
  }

  Future<void> _save(TrainingPlan plan) async {
    state = plan.copyWith(updatedAt: DateTime.now().toUtc());
    await ref.read(trainingPlanRepositoryProvider).save(state);
    await ref
        .read(trainingSchedulerServiceProvider)
        .syncPlan(state, requestPermissions: true);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  int _compareTimes(TrainingReminderTime a, TrainingReminderTime b) {
    if (a.hour != b.hour) {
      return a.hour.compareTo(b.hour);
    }
    return a.minute.compareTo(b.minute);
  }
}
