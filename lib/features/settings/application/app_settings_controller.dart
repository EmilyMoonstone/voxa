import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../sync/application/sync_controller.dart';
import '../domain/app_settings.dart';
import 'reset_local_data_use_case.dart';

final resetLocalDataUseCaseProvider = Provider<ResetLocalDataUseCase>(
  (ref) => ResetLocalDataUseCase(
    practiceSessionRepository: ref.watch(practiceSessionRepositoryProvider),
    voiceTargetRepository: ref.watch(voiceTargetRepositoryProvider),
    appPreferencesRepository: ref.watch(appPreferencesRepositoryProvider),
    syncMetadataRepository: ref.watch(syncMetadataRepositoryProvider),
    scheduleSync: ref.read(syncControllerProvider.notifier).scheduleSync,
  ),
);

final appSettingsControllerProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );

class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.watch(appPreferencesRepositoryProvider).load();
  }

  Future<void> setLocale(String localeCode) async {
    state = state.copyWith(
      localeCode: localeCode,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(
      themeMode: themeMode,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setSmoothingWindow(int smoothingWindowMs) async {
    state = state.copyWith(
      smoothingWindowMs: smoothingWindowMs,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setTargetTolerance(int targetToleranceHz) async {
    state = state.copyWith(
      targetToleranceHz: targetToleranceHz,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setTargetVolumeTolerance(int targetVolumeToleranceDb) async {
    state = state.copyWith(
      targetVolumeToleranceDb: targetVolumeToleranceDb,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setLastPitchTrainingMode(PitchTrainingMode mode) async {
    state = state.copyWith(
      lastPitchTrainingMode: mode,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> setLiveFeedbackDuringRecording(bool value) async {
    state = state.copyWith(
      showLiveFeedbackDuringRecording: value,
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(appPreferencesRepositoryProvider).save(state);
    ref.read(syncControllerProvider.notifier).scheduleSync();
  }

  Future<void> resetAllLocalData() async {
    await ref.read(resetLocalDataUseCaseProvider).execute();
    state = ref.read(appPreferencesRepositoryProvider).load();
  }
}
