import 'training_plan.dart';

abstract interface class TrainingPlanRepository {
  TrainingPlan load();

  Future<void> save(TrainingPlan plan);

  List<int> loadScheduledNotificationIds();

  Future<void> saveScheduledNotificationIds(List<int> ids);
}
