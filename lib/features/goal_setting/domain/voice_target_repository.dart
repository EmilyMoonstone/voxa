import 'voice_target.dart';

abstract interface class VoiceTargetRepository {
  Stream<VoiceTarget?> watchCurrentTarget();
  Future<VoiceTarget?> getCurrentTarget();
  Future<void> saveTarget(VoiceTarget target);
  Future<void> clear();
}
