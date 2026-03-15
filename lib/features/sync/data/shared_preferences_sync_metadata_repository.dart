import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/sync_metadata_repository.dart';
import '../domain/sync_models.dart';

class SharedPreferencesSyncMetadataRepository
    implements SyncMetadataRepository {
  SharedPreferencesSyncMetadataRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _accountEmailKey = 'sync.account_email';
  static const _accountIdKey = 'sync.account_id';
  static const _lastSyncedAtKey = 'sync.last_synced_at_ms';
  static const _lastErrorKey = 'sync.last_error';
  static const _remoteFileIdKey = 'sync.remote_file_id';
  static const _remoteRevisionKey = 'sync.remote_revision';
  static const _tombstonesKey = 'sync.deleted_tombstones';

  @override
  SyncStatus loadStatus() {
    final accountId = _preferences.getString(_accountIdKey);
    return SyncStatus(
      isAvailable: true,
      isConnected: accountId != null,
      isSyncing: false,
      accountEmail: _preferences.getString(_accountEmailKey),
      accountId: accountId,
      lastSyncedAt: _preferences.containsKey(_lastSyncedAtKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              _preferences.getInt(_lastSyncedAtKey)!,
            )
          : null,
      lastError: _preferences.getString(_lastErrorKey),
      remoteFileId: _preferences.getString(_remoteFileIdKey),
      remoteRevision: _preferences.getString(_remoteRevisionKey),
    );
  }

  @override
  Future<void> saveStatus(SyncStatus status) async {
    if (!status.isConnected) {
      await _preferences.remove(_accountEmailKey);
      await _preferences.remove(_accountIdKey);
      await _preferences.remove(_remoteFileIdKey);
      await _preferences.remove(_remoteRevisionKey);
    } else {
      if (status.accountEmail != null) {
        await _preferences.setString(_accountEmailKey, status.accountEmail!);
      }
      if (status.accountId != null) {
        await _preferences.setString(_accountIdKey, status.accountId!);
      }
      if (status.remoteFileId != null) {
        await _preferences.setString(_remoteFileIdKey, status.remoteFileId!);
      }
      if (status.remoteRevision != null) {
        await _preferences.setString(
          _remoteRevisionKey,
          status.remoteRevision!,
        );
      }
    }

    if (status.lastSyncedAt != null) {
      await _preferences.setInt(
        _lastSyncedAtKey,
        status.lastSyncedAt!.millisecondsSinceEpoch,
      );
    }
    if (status.lastError != null && status.lastError!.isNotEmpty) {
      await _preferences.setString(_lastErrorKey, status.lastError!);
    } else {
      await _preferences.remove(_lastErrorKey);
    }
  }

  @override
  List<DeletedEntityTombstone> loadTombstones() {
    final raw = _preferences.getString(_tombstonesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (entry) => DeletedEntityTombstone(
            entityType: SyncEntityType.values.byName(
              entry['entityType'] as String,
            ),
            entityId: entry['entityId'] as String,
            deletedAt: DateTime.fromMillisecondsSinceEpoch(
              entry['deletedAt'] as int,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveTombstones(List<DeletedEntityTombstone> tombstones) async {
    await _preferences.setString(
      _tombstonesKey,
      jsonEncode(
        tombstones
            .map(
              (tombstone) => {
                'entityType': tombstone.entityType.name,
                'entityId': tombstone.entityId,
                'deletedAt': tombstone.deletedAt.millisecondsSinceEpoch,
              },
            )
            .toList(growable: false),
      ),
    );
  }

  @override
  Future<void> upsertTombstone(DeletedEntityTombstone tombstone) async {
    final tombstones = loadTombstones().toList(growable: true);
    final index = tombstones.indexWhere(
      (entry) =>
          entry.entityType == tombstone.entityType &&
          entry.entityId == tombstone.entityId,
    );
    if (index >= 0) {
      if (!tombstone.deletedAt.isAfter(tombstones[index].deletedAt)) {
        return;
      }
      tombstones[index] = tombstone;
    } else {
      tombstones.add(tombstone);
    }
    await saveTombstones(tombstones);
  }
}
