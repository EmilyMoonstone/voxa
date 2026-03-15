import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../history/application/session_providers.dart';
import '../domain/sync_models.dart';

final syncControllerProvider = NotifierProvider<SyncController, SyncStatus>(
  SyncController.new,
);

class SyncController extends Notifier<SyncStatus> {
  Timer? _debounce;

  @override
  SyncStatus build() {
    final googleAccountService = ref.watch(googleAccountServiceProvider);
    final stored = ref.watch(syncMetadataRepositoryProvider).loadStatus();
    final initial = stored.copyWith(
      isAvailable: googleAccountService.isSupported,
    );
    if (initial.isConnected && googleAccountService.isSupported) {
      Future.microtask(_restoreAndSyncOnLaunch);
    }
    ref.onDispose(() => _debounce?.cancel());
    return initial;
  }

  Future<void> connectGoogleAccount() async {
    final googleAccountService = ref.read(googleAccountServiceProvider);
    if (!googleAccountService.isSupported) {
      state = state.copyWith(
        isAvailable: false,
        lastError: 'Google sync is only available on Android and iOS.',
      );
      return;
    }
    GoogleAccountIdentity? account;
    try {
      account = await googleAccountService.signIn();
    } catch (error) {
      state = state.copyWith(lastError: _friendlyGoogleError(error));
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      return;
    }
    if (account == null) {
      state = state.copyWith(lastError: 'Google sign-in was cancelled.');
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      return;
    }
    state = state.copyWith(
      isConnected: true,
      isAvailable: true,
      accountEmail: account.email,
      accountId: account.id,
      clearLastError: true,
    );
    await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
    await syncNow();
  }

  Future<void> disconnectGoogleAccount() async {
    await ref.read(googleAccountServiceProvider).signOut();
    state = state.copyWith(
      isConnected: false,
      clearAccountEmail: true,
      clearAccountId: true,
      clearLastError: true,
      clearRemoteFileId: true,
      clearRemoteRevision: true,
    );
    await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
  }

  void scheduleSync() {
    if (!state.isConnected || state.isSyncing) {
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      unawaited(syncNow());
    });
  }

  Future<void> syncNow() async {
    if (!state.isConnected || state.isSyncing) {
      return;
    }
    final googleAccountService = ref.read(googleAccountServiceProvider);
    final account =
        googleAccountService.currentAccount ??
        await googleAccountService.restoreSignIn();
    if (account == null) {
      state = state.copyWith(
        isConnected: false,
        lastError: 'Google sign-in expired. Connect the account again.',
      );
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      return;
    }
    final client = await googleAccountService.createAuthenticatedClient();
    if (client == null) {
      state = state.copyWith(lastError: 'Google Drive authorization failed.');
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      return;
    }

    state = state.copyWith(
      isSyncing: true,
      accountEmail: account.email,
      accountId: account.id,
      clearLastError: true,
    );
    await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
    try {
      final result = await ref
          .read(syncServiceProvider)
          .synchronize(
            account: account,
            client: client,
            remoteFileId: state.remoteFileId,
          );
      state = state.copyWith(
        isSyncing: false,
        lastSyncedAt: result.completedAt,
        remoteFileId: result.fileId,
        remoteRevision: result.revision,
        clearLastError: true,
      );
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      ref.invalidate(appSettingsControllerProvider);
      ref.invalidate(currentTargetProvider);
      ref.invalidate(practiceSessionsProvider);
      ref.invalidate(sessionDetailProvider);
    } catch (error) {
      state = state.copyWith(
        isSyncing: false,
        lastError: _friendlyGoogleError(error),
      );
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
    } finally {
      client.close();
    }
  }

  Future<void> _restoreAndSyncOnLaunch() async {
    final googleAccountService = ref.read(googleAccountServiceProvider);
    final account = await googleAccountService.restoreSignIn();
    if (account == null) {
      state = state.copyWith(
        isConnected: false,
        clearRemoteFileId: true,
        clearRemoteRevision: true,
      );
      await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
      return;
    }
    state = state.copyWith(
      isConnected: true,
      accountEmail: account.email,
      accountId: account.id,
      clearLastError: true,
    );
    await ref.read(syncMetadataRepositoryProvider).saveStatus(state);
    await syncNow();
  }

  String _friendlyGoogleError(Object error) {
    final message = error.toString();
    if (message.contains('ApiException: 10') ||
        message.contains('DEVELOPER_ERROR')) {
      return 'Google sign-in is misconfigured for Android. Check the Google Cloud OAuth Android client for package de.bruckcode.voxa and make sure the SHA-1/SHA-256 fingerprint matches this build.';
    }
    if (message.contains('sign_in_failed')) {
      return 'Google sign-in failed. Verify the Android OAuth client, package name, and signing fingerprint.';
    }
    return message;
  }
}
