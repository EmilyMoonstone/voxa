import 'package:drift/drift.dart';

import '../../../core/data/local/app_database.dart';
import '../domain/practice_session.dart';
import '../domain/practice_session_repository.dart';

class DriftPracticeSessionRepository implements PracticeSessionRepository {
  DriftPracticeSessionRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<PracticeSession>> watchSessions() {
    final query = _database.select(_database.practiceSessionEntries)
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);
    return query.watch().map(
      (rows) => rows.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<List<PracticeSession>> getSessions() async {
    final query = _database.select(_database.practiceSessionEntries)
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.toDomain()).toList(growable: false);
  }

  @override
  Future<PracticeSession?> getSessionById(String id) async {
    final query = _database.select(_database.practiceSessionEntries)
      ..where((table) => table.id.equals(id));
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<void> saveSession(PracticeSession session) async {
    await _database
        .into(_database.practiceSessionEntries)
        .insertOnConflictUpdate(session.toCompanion());
  }

  @override
  Future<void> deleteSession(String id) async {
    await (_database.delete(
      _database.practiceSessionEntries,
    )..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _database.delete(_database.practiceSessionEntries).go();
  }
}
