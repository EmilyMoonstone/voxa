import 'package:drift/drift.dart';

import '../../../core/data/local/app_database.dart';
import '../domain/voice_target.dart';
import '../domain/voice_target_repository.dart';

class DriftVoiceTargetRepository implements VoiceTargetRepository {
  DriftVoiceTargetRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<VoiceTarget?> watchCurrentTarget() {
    final query = _database.select(_database.voiceTargetEntries)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])
      ..limit(1);

    return query.watchSingleOrNull().map((row) => row?.toDomain());
  }

  @override
  Future<VoiceTarget?> getCurrentTarget() async {
    final query = _database.select(_database.voiceTargetEntries)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)])
      ..limit(1);

    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<void> saveTarget(VoiceTarget target) async {
    await _database
        .into(_database.voiceTargetEntries)
        .insertOnConflictUpdate(target.toCompanion());
  }

  @override
  Future<void> clear() async {
    await _database.delete(_database.voiceTargetEntries).go();
  }
}
