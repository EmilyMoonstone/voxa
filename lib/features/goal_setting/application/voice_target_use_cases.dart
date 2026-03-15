import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../sync/application/sync_controller.dart';
import '../domain/voice_target.dart';
import '../domain/voice_target_repository.dart';

final currentTargetProvider = StreamProvider<VoiceTarget?>(
  (ref) => ref.watch(voiceTargetRepositoryProvider).watchCurrentTarget(),
);

final activeTargetProvider = Provider<VoiceTarget?>(
  (ref) => ref.watch(currentTargetProvider).asData?.value,
);

final saveVoiceTargetUseCaseProvider = Provider<SaveVoiceTargetUseCase>(
  (ref) => SaveVoiceTargetUseCase(
    repository: ref.watch(voiceTargetRepositoryProvider),
    scheduleSync: ref.read(syncControllerProvider.notifier).scheduleSync,
  ),
);

class SaveVoiceTargetUseCase {
  const SaveVoiceTargetUseCase({
    required VoiceTargetRepository repository,
    required void Function() scheduleSync,
  }) : _repository = repository,
       _scheduleSync = scheduleSync;

  final VoiceTargetRepository _repository;
  final void Function() _scheduleSync;

  Future<void> execute(VoiceTarget target) async {
    await _repository.saveTarget(target);
    _scheduleSync();
  }
}
