import 'sync_models.dart';

abstract interface class SyncMetadataRepository {
  SyncStatus loadStatus();
  Future<void> saveStatus(SyncStatus status);

  List<DeletedEntityTombstone> loadTombstones();
  Future<void> saveTombstones(List<DeletedEntityTombstone> tombstones);
  Future<void> upsertTombstone(DeletedEntityTombstone tombstone);
}
