import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../sync/application/sync_controller.dart';
import '../../sync/domain/sync_metadata_repository.dart';
import '../../sync/domain/sync_models.dart';
import '../../record/domain/practice_session.dart';
import '../../record/domain/practice_session_repository.dart';

final practiceSessionsProvider = StreamProvider<List<PracticeSession>>(
  (ref) => ref.watch(practiceSessionRepositoryProvider).watchSessions(),
);

final sessionDetailProvider = FutureProvider.family<PracticeSession?, String>((
  ref,
  sessionId,
) {
  return ref.watch(practiceSessionRepositoryProvider).getSessionById(sessionId);
});

final deleteSessionUseCaseProvider = Provider<DeleteSessionUseCase>(
  (ref) => DeleteSessionUseCase(
    repository: ref.watch(practiceSessionRepositoryProvider),
    syncMetadataRepository: ref.watch(syncMetadataRepositoryProvider),
    scheduleSync: ref.read(syncControllerProvider.notifier).scheduleSync,
  ),
);

class DeleteSessionUseCase {
  const DeleteSessionUseCase({
    required PracticeSessionRepository repository,
    required SyncMetadataRepository syncMetadataRepository,
    required void Function() scheduleSync,
  }) : _repository = repository,
       _syncMetadataRepository = syncMetadataRepository,
       _scheduleSync = scheduleSync;

  final PracticeSessionRepository _repository;
  final SyncMetadataRepository _syncMetadataRepository;
  final void Function() _scheduleSync;

  Future<void> execute(PracticeSession session) async {
    final path = session.audioFilePath;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await _syncMetadataRepository.upsertTombstone(
      DeletedEntityTombstone(
        entityType: SyncEntityType.session,
        entityId: session.id,
        deletedAt: DateTime.now().toUtc(),
      ),
    );
    await _repository.deleteSession(session.id);
    _scheduleSync();
  }
}
