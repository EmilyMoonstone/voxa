import 'dart:io';

import '../../goal_setting/domain/voice_target_repository.dart';
import '../../record/domain/practice_session_repository.dart';
import '../../sync/domain/sync_metadata_repository.dart';
import '../../sync/domain/sync_models.dart';
import '../domain/app_preferences_repository.dart';

class ResetLocalDataUseCase {
  const ResetLocalDataUseCase({
    required PracticeSessionRepository practiceSessionRepository,
    required VoiceTargetRepository voiceTargetRepository,
    required AppPreferencesRepository appPreferencesRepository,
    required SyncMetadataRepository syncMetadataRepository,
    required void Function() scheduleSync,
  }) : _practiceSessionRepository = practiceSessionRepository,
       _voiceTargetRepository = voiceTargetRepository,
       _appPreferencesRepository = appPreferencesRepository,
       _syncMetadataRepository = syncMetadataRepository,
       _scheduleSync = scheduleSync;

  final PracticeSessionRepository _practiceSessionRepository;
  final VoiceTargetRepository _voiceTargetRepository;
  final AppPreferencesRepository _appPreferencesRepository;
  final SyncMetadataRepository _syncMetadataRepository;
  final void Function() _scheduleSync;

  Future<void> execute() async {
    final sessions = await _practiceSessionRepository.getSessions();
    final target = await _voiceTargetRepository.getCurrentTarget();
    final deletedAt = DateTime.now().toUtc();
    for (final session in sessions) {
      final path = session.audioFilePath;
      if (path == null) {
        continue;
      }
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      await _syncMetadataRepository.upsertTombstone(
        DeletedEntityTombstone(
          entityType: SyncEntityType.session,
          entityId: session.id,
          deletedAt: deletedAt,
        ),
      );
    }

    if (target != null) {
      await _syncMetadataRepository.upsertTombstone(
        DeletedEntityTombstone(
          entityType: SyncEntityType.target,
          entityId: target.id,
          deletedAt: deletedAt,
        ),
      );
    }

    await _practiceSessionRepository.clear();
    await _voiceTargetRepository.clear();
    await _appPreferencesRepository.clear();
    _scheduleSync();
  }
}
