import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/bootstrap/app_bootstrap.dart';
import 'app/router/app_routes.dart';
import 'core/data/local/app_database.dart';
import 'core/notifications/data/flutter_local_notifications_service.dart';
import 'features/goal_setting/data/drift_voice_target_repository.dart';
import 'features/settings/data/shared_preferences_app_preferences_repository.dart';
import 'features/training/data/default_training_scheduler_service.dart';
import 'features/training/data/shared_preferences_training_plan_repository.dart';

const _appModelVersionKey = 'app.model_version';
const _currentAppModelVersion = 2;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  await _resetIncompatibleLocalDataIfNeeded(preferences);
  final database = AppDatabase();
  final localNotificationsService = FlutterLocalNotificationsService();
  await localNotificationsService.initialize();
  final appPreferencesRepository = SharedPreferencesAppPreferencesRepository(
    preferences,
  );
  final trainingPlanRepository = SharedPreferencesTrainingPlanRepository(
    preferences,
  );
  final trainingSchedulerService = DefaultTrainingSchedulerService(
    localNotificationsService: localNotificationsService,
    trainingPlanRepository: trainingPlanRepository,
  );
  await trainingSchedulerService.syncPlan(trainingPlanRepository.load());
  final targetRepository = DriftVoiceTargetRepository(database);
  final currentTarget = await targetRepository.getCurrentTarget();
  final initialLocation = currentTarget == null
      ? const OnboardingWelcomeRoute().location
      : const HomeRoute().location;
  final bootstrap = AppBootstrap(
    preferences: preferences,
    database: database,
    localNotificationsService: localNotificationsService,
    initialSettings: appPreferencesRepository.load(),
    initialLocation: initialLocation,
  );

  runApp(
    ProviderScope(
      overrides: [appBootstrapProvider.overrideWithValue(bootstrap)],
      child: const VoxaApp(),
    ),
  );
}

Future<void> _resetIncompatibleLocalDataIfNeeded(
  SharedPreferences preferences,
) async {
  final storedVersion = preferences.getInt(_appModelVersionKey) ?? 0;
  if (storedVersion >= _currentAppModelVersion) {
    return;
  }

  final recordingsDirectory = await getApplicationDocumentsDirectory();
  final recordings = Directory('${recordingsDirectory.path}/recordings');
  if (await recordings.exists()) {
    await recordings.delete(recursive: true);
  }

  await preferences.clear();
  await preferences.setInt(_appModelVersionKey, _currentAppModelVersion);
}
