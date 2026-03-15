import 'training_plan.dart';

abstract interface class TrainingSchedulerService {
  Future<void> syncPlan(TrainingPlan plan, {bool requestPermissions = false});
}
