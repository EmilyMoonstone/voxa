import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/goal_setting/domain/voice_target_repository.dart';
import 'package:voxa/features/record/domain/practice_session.dart';
import 'package:voxa/features/record/domain/practice_session_repository.dart';
import 'package:voxa/features/settings/domain/app_preferences_repository.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';
import 'package:voxa/features/sync/domain/google_account_service.dart';
import 'package:voxa/features/sync/domain/sync_metadata_repository.dart';
import 'package:voxa/features/sync/domain/sync_models.dart';
import 'package:voxa/features/sync/domain/sync_service.dart';

class FakeVoiceTargetRepository implements VoiceTargetRepository {
  FakeVoiceTargetRepository([this._currentTarget]) {
    _controller = StreamController<VoiceTarget?>.broadcast(
      onListen: () => _controller.add(_currentTarget),
    );
  }

  VoiceTarget? _currentTarget;
  late final StreamController<VoiceTarget?> _controller;

  VoiceTarget? get currentTarget => _currentTarget;

  @override
  Future<void> clear() async {
    _currentTarget = null;
    _controller.add(null);
  }

  @override
  Future<VoiceTarget?> getCurrentTarget() async => _currentTarget;

  @override
  Future<void> saveTarget(VoiceTarget target) async {
    _currentTarget = target;
    _controller.add(target);
  }

  @override
  Stream<VoiceTarget?> watchCurrentTarget() => _controller.stream;
}

class FakePracticeSessionRepository implements PracticeSessionRepository {
  FakePracticeSessionRepository([List<PracticeSession>? initialSessions])
    : _sessions = [...?initialSessions] {
    _controller = StreamController<List<PracticeSession>>.broadcast(
      onListen: () => _controller.add(_sortedSessions()),
    );
  }

  final List<PracticeSession> _sessions;
  late final StreamController<List<PracticeSession>> _controller;

  @override
  Future<void> clear() async {
    _sessions.clear();
    _controller.add(const []);
  }

  @override
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((session) => session.id == id);
    _controller.add(_sortedSessions());
  }

  @override
  Future<PracticeSession?> getSessionById(String id) async {
    return _sessions.where((session) => session.id == id).firstOrNull;
  }

  @override
  Future<List<PracticeSession>> getSessions() async => _sortedSessions();

  @override
  Future<void> saveSession(PracticeSession session) async {
    _sessions.removeWhere((existing) => existing.id == session.id);
    _sessions.add(session);
    _controller.add(_sortedSessions());
  }

  @override
  Stream<List<PracticeSession>> watchSessions() => _controller.stream;

  List<PracticeSession> _sortedSessions() {
    final copy = [..._sessions];
    copy.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return copy;
  }
}

class FakeAppPreferencesRepository implements AppPreferencesRepository {
  FakeAppPreferencesRepository([AppSettings? initialSettings])
    : savedSettings = initialSettings ?? AppSettings.defaults;

  AppSettings savedSettings;

  @override
  Future<void> clear() async {
    savedSettings = AppSettings.defaults;
  }

  @override
  AppSettings load() => savedSettings;

  @override
  Future<void> save(AppSettings settings) async {
    savedSettings = settings;
  }
}

class FakeSyncMetadataRepository implements SyncMetadataRepository {
  FakeSyncMetadataRepository({
    this.status = SyncStatus.disconnected,
    List<DeletedEntityTombstone>? tombstones,
  }) : _tombstones = [...?tombstones];

  SyncStatus status;
  final List<DeletedEntityTombstone> _tombstones;

  @override
  List<DeletedEntityTombstone> loadTombstones() =>
      List.unmodifiable(_tombstones);

  @override
  SyncStatus loadStatus() => status;

  @override
  Future<void> saveStatus(SyncStatus status) async {
    this.status = status;
  }

  @override
  Future<void> saveTombstones(List<DeletedEntityTombstone> tombstones) async {
    _tombstones
      ..clear()
      ..addAll(tombstones);
  }

  @override
  Future<void> upsertTombstone(DeletedEntityTombstone tombstone) async {
    final index = _tombstones.indexWhere(
      (entry) =>
          entry.entityType == tombstone.entityType &&
          entry.entityId == tombstone.entityId,
    );
    if (index >= 0) {
      _tombstones[index] = tombstone;
    } else {
      _tombstones.add(tombstone);
    }
  }
}

class FakeGoogleAccountService implements GoogleAccountService {
  FakeGoogleAccountService({
    this.account,
    this.client,
    this.supported = true,
  });

  GoogleAccountIdentity? account;
  http.Client? client;
  bool supported;

  @override
  GoogleAccountIdentity? get currentAccount => account;

  @override
  bool get isSupported => supported;

  @override
  Future<http.Client?> createAuthenticatedClient() async => client;

  @override
  Future<GoogleAccountIdentity?> restoreSignIn() async => account;

  @override
  Future<GoogleAccountIdentity?> signIn() async => account;

  @override
  Future<void> signOut() async {
    account = null;
  }
}

class FakeSyncService implements SyncService {
  FakeSyncService({this.result});

  SyncExecutionResult? result;

  @override
  Future<SyncExecutionResult> synchronize({
    required GoogleAccountIdentity account,
    required http.Client client,
    String? remoteFileId,
  }) async {
    return result ??
        SyncExecutionResult(
          completedAt: DateTime.now().toUtc(),
          fileId: remoteFileId ?? 'remote-file',
          revision: '1',
        );
  }
}
