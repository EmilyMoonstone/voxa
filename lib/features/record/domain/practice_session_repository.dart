import 'practice_session.dart';

abstract interface class PracticeSessionRepository {
  Stream<List<PracticeSession>> watchSessions();
  Future<List<PracticeSession>> getSessions();
  Future<PracticeSession?> getSessionById(String id);
  Future<void> saveSession(PracticeSession session);
  Future<void> deleteSession(String id);
  Future<void> clear();
}
