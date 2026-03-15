import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/data/record_audio_services.dart';
import '../core/audio/domain/audio_contracts.dart';
import '../core/notifications/domain/local_notifications_service.dart';
import '../features/goal_setting/data/drift_voice_target_repository.dart';
import '../features/goal_setting/domain/voice_target_repository.dart';
import '../features/record/data/drift_practice_session_repository.dart';
import '../features/record/data/seeded_practice_text_repository.dart';
import '../features/record/domain/practice_session_repository.dart';
import '../features/record/domain/practice_text_repository.dart';
import '../features/settings/data/shared_preferences_app_preferences_repository.dart';
import '../features/settings/domain/app_preferences_repository.dart';
import '../features/sync/data/default_sync_service.dart';
import '../features/sync/data/google_drive_app_data_cloud_sync_repository.dart';
import '../features/sync/data/google_sign_in_google_account_service.dart';
import '../features/sync/data/json_sync_snapshot_codec.dart';
import '../features/sync/data/shared_preferences_sync_metadata_repository.dart';
import '../features/training/data/default_training_scheduler_service.dart';
import '../features/training/data/shared_preferences_training_plan_repository.dart';
import '../features/sync/domain/cloud_sync_repository.dart';
import '../features/sync/domain/google_account_service.dart';
import '../features/sync/domain/sync_metadata_repository.dart';
import '../features/sync/domain/sync_service.dart';
import '../features/sync/domain/sync_snapshot_codec.dart';
import '../features/training/domain/training_plan_repository.dart';
import '../features/training/domain/training_scheduler_service.dart';
import 'bootstrap/app_bootstrap.dart';

final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>(
  (ref) => SharedPreferencesAppPreferencesRepository(
    ref.watch(sharedPreferencesProvider),
  ),
);

final voiceTargetRepositoryProvider = Provider<VoiceTargetRepository>(
  (ref) => DriftVoiceTargetRepository(ref.watch(appDatabaseProvider)),
);

final practiceSessionRepositoryProvider = Provider<PracticeSessionRepository>(
  (ref) => DriftPracticeSessionRepository(ref.watch(appDatabaseProvider)),
);

final practiceTextRepositoryProvider = Provider<PracticeTextRepository>(
  (ref) => SeededPracticeTextRepository(),
);

final audioPermissionServiceProvider = Provider<AudioPermissionService>(
  (ref) => PermissionHandlerAudioPermissionService(),
);

final livePitchEngineProvider = Provider<LivePitchEngine>(
  (ref) => RecordLivePitchEngine(),
);

final recordingEngineProvider = Provider<RecordingEngine>(
  (ref) => RecordRecordingEngine(),
);

final importedPitchAnalysisServiceProvider =
    Provider<ImportedPitchAnalysisService>(
      (ref) => const DefaultImportedPitchAnalysisService(),
    );

final targetVolumeCalibrationServiceProvider =
    Provider<TargetVolumeCalibrationService>(
      (ref) => const DefaultTargetVolumeCalibrationService(),
    );

final analysisServiceProvider = Provider<AnalysisService>(
  (ref) => const DefaultAnalysisService(),
);

final trainingPlanRepositoryProvider = Provider<TrainingPlanRepository>(
  (ref) => SharedPreferencesTrainingPlanRepository(
    ref.watch(sharedPreferencesProvider),
  ),
);

final trainingSchedulerServiceProvider = Provider<TrainingSchedulerService>(
  (ref) => DefaultTrainingSchedulerService(
    localNotificationsService: ref.watch(localNotificationsProvider),
    trainingPlanRepository: ref.watch(trainingPlanRepositoryProvider),
  ),
);

final localNotificationsProvider = Provider<LocalNotificationsService>(
  (ref) => ref.watch(localNotificationsServiceProvider),
);

final syncMetadataRepositoryProvider = Provider<SyncMetadataRepository>(
  (ref) => SharedPreferencesSyncMetadataRepository(
    ref.watch(sharedPreferencesProvider),
  ),
);

final googleAccountServiceProvider = Provider<GoogleAccountService>(
  (ref) => GoogleSignInGoogleAccountService(),
);

final cloudSyncRepositoryProvider = Provider<CloudSyncRepository>(
  (ref) => GoogleDriveAppDataCloudSyncRepository(),
);

final syncSnapshotCodecProvider = Provider<SyncSnapshotCodec>(
  (ref) => JsonSyncSnapshotCodec(),
);

final syncServiceProvider = Provider<SyncService>(
  (ref) => DefaultSyncService(
    appPreferencesRepository: ref.watch(appPreferencesRepositoryProvider),
    voiceTargetRepository: ref.watch(voiceTargetRepositoryProvider),
    practiceSessionRepository: ref.watch(practiceSessionRepositoryProvider),
    syncMetadataRepository: ref.watch(syncMetadataRepositoryProvider),
    cloudSyncRepository: ref.watch(cloudSyncRepositoryProvider),
    syncSnapshotCodec: ref.watch(syncSnapshotCodecProvider),
  ),
);
