import '../../../core/notifications/domain/local_notification.dart';
import '../../../core/notifications/domain/local_notifications_service.dart';
import '../domain/training_exercise_mode.dart';
import '../domain/training_plan.dart';
import '../domain/training_plan_repository.dart';
import '../domain/training_scheduler_service.dart';

class DefaultTrainingSchedulerService implements TrainingSchedulerService {
  DefaultTrainingSchedulerService({
    required LocalNotificationsService localNotificationsService,
    required TrainingPlanRepository trainingPlanRepository,
  }) : _localNotificationsService = localNotificationsService,
       _trainingPlanRepository = trainingPlanRepository;

  final LocalNotificationsService _localNotificationsService;
  final TrainingPlanRepository _trainingPlanRepository;

  static const _daysToSchedule = 21;

  @override
  Future<void> syncPlan(
    TrainingPlan plan, {
    bool requestPermissions = false,
  }) async {
    if (requestPermissions) {
      final granted = await _localNotificationsService.requestPermissions();
      if (!granted) {
        return;
      }
      await _localNotificationsService.requestExactAlarmsPermission();
    } else {
      final enabled = await _localNotificationsService
          .areNotificationsEnabled();
      if (!enabled) {
        return;
      }
    }

    final scheduledIds = _trainingPlanRepository.loadScheduledNotificationIds();
    for (final id in scheduledIds) {
      await _localNotificationsService.cancel(id);
    }

    final now = DateTime.now();
    final scheduled = <int>[];
    for (var dayOffset = 0; dayOffset < _daysToSchedule; dayOffset++) {
      final day = DateTime(now.year, now.month, now.day + dayOffset);
      final dayPlan = plan.resolveFor(day);
      for (
        var slotIndex = 0;
        slotIndex < dayPlan.reminderTimes.length;
        slotIndex++
      ) {
        final time = dayPlan.reminderTimes[slotIndex];
        final scheduledAt = DateTime(
          day.year,
          day.month,
          day.day,
          time.hour,
          time.minute,
        );
        if (!scheduledAt.isAfter(now)) {
          continue;
        }

        final id = scheduledAt.millisecondsSinceEpoch ~/ 60000 + slotIndex;
        scheduled.add(id);
        await _localNotificationsService.schedule(
          notification: LocalNotification(
            id: id,
            title: 'Voxa practice',
            body: _notificationBody(dayPlan),
            payload: 'practice',
          ),
          scheduledAt: scheduledAt,
        );
      }
    }

    await _trainingPlanRepository.saveScheduledNotificationIds(scheduled);
  }

  String _notificationBody(TrainingDayPlan plan) {
    final duration = '${plan.durationMinutes} min';
    if (plan.exerciseMode == TrainingExerciseMode.general) {
      return 'Time for your training session. Planned duration: $duration.';
    }
    return 'Time for $duration of ${plan.exerciseMode.storageValue.replaceAll('_', ' ')}.';
  }
}
