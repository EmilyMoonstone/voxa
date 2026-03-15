/*
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/audio/data/record_audio_services.dart';
import '../core/audio/domain/audio_contracts.dart';
import '../core/data/local/app_database.dart';
import '../features/goal_setting/data/drift_voice_target_repository.dart';
import '../features/goal_setting/domain/voice_target.dart';
import '../features/goal_setting/domain/voice_target_repository.dart';
import '../features/practice/domain/pitch_sample.dart';
import '../features/record/data/drift_practice_session_repository.dart';
import '../features/record/data/seeded_practice_text_repository.dart';
import '../features/record/domain/practice_session.dart';
import '../features/record/domain/practice_session_repository.dart';
import '../features/record/domain/practice_text.dart';
import '../features/record/domain/practice_text_repository.dart';
import '../features/settings/data/shared_preferences_app_preferences_repository.dart';
import '../features/settings/domain/app_preferences_repository.dart';
import '../features/settings/domain/app_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences override missing'),
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('AppDatabase override missing'),
);

final initialLocationProvider = Provider<String>((ref) => '/');

final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>(
  (ref) => SharedPreferencesAppPreferencesRepository(
    ref.watch(sharedPreferencesProvider),
  ),
);

final voiceTargetRepositoryProvider = Provider<VoiceTargetRepository>(
  (ref) => DriftVoiceTargetRepository(ref.watch(appDatabaseProvider)),
);

final practiceSessionRepositoryProvider = Provider<PracticeSessionRepository>(
  (ref) => DriftPracticeSessionRepository(ref.watch(appDatabaseProvider)),
);

final practiceTextRepositoryProvider = Provider<PracticeTextRepository>(
  (ref) => SeededPracticeTextRepository(),
);

final audioPermissionServiceProvider = Provider<AudioPermissionService>(
  (ref) => PermissionHandlerAudioPermissionService(),
);

final livePitchEngineProvider = Provider<LivePitchEngine>(
  (ref) => RecordLivePitchEngine(),
);

final recordingEngineProvider = Provider<RecordingEngine>(
  (ref) => RecordRecordingEngine(),
);

final analysisServiceProvider = Provider<AnalysisService>(
  (ref) => const DefaultAnalysisService(),
);

final appSettingsControllerProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );

final currentTargetProvider = StreamProvider<VoiceTarget?>(
  (ref) => ref.watch(voiceTargetRepositoryProvider).watchCurrentTarget(),
);

final practiceSessionsProvider = StreamProvider<List<PracticeSession>>(
  (ref) => ref.watch(practiceSessionRepositoryProvider).watchSessions(),
);

final localizedPracticeTextsProvider = Provider<List<PracticeText>>((ref) {
  final localeCode = ref.watch(
    appSettingsControllerProvider.select((settings) => settings.localeCode),
  );
  return ref.watch(practiceTextRepositoryProvider).listForLocale(localeCode);
});

final livePracticeControllerProvider =
    NotifierProvider.autoDispose<LivePracticeController, LivePracticeState>(
      LivePracticeController.new,
    );

final recordSessionControllerProvider =
    NotifierProvider.autoDispose<RecordSessionController, RecordSessionState>(
      RecordSessionController.new,
    );

final sessionDetailProvider =
    FutureProvider.family<PracticeSession?, String>((ref, sessionId) {
      return ref
          .watch(practiceSessionRepositoryProvider)
          .getSessionById(sessionId);
    });

class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.watch(appPreferencesRepositoryProvider).load();
  }

  Future<void> setLocale(String localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await ref.watch(appPreferencesRepositoryProvider).save(state);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await ref.watch(appPreferencesRepositoryProvider).save(state);
  }

  Future<void> setSmoothingWindow(int smoothingWindowMs) async {
    state = state.copyWith(smoothingWindowMs: smoothingWindowMs);
    await ref.watch(appPreferencesRepositoryProvider).save(state);
  }

  Future<void> setLiveFeedbackDuringRecording(bool value) async {
    state = state.copyWith(showLiveFeedbackDuringRecording: value);
    await ref.watch(appPreferencesRepositoryProvider).save(state);
  }

  Future<void> resetAllLocalData() async {
    final repository = ref.read(practiceSessionRepositoryProvider);
    final sessions = await repository.getSessions();
    for (final session in sessions) {
      final path = session.audioFilePath;
      if (path == null) {
        continue;
      }
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await repository.clear();
    await ref.read(voiceTargetRepositoryProvider).clear();
    await ref.read(appPreferencesRepositoryProvider).clear();
    state = AppSettings.defaults;
  }
}
*/
export 'app_providers.dart';
export 'bootstrap/app_bootstrap.dart';
export 'router/app_routes.dart';
export '../features/goal_setting/application/voice_target_use_cases.dart';
export '../features/history/application/session_providers.dart';
export '../features/practice/application/live_practice_controller.dart';
export '../features/record/application/record_session_controller.dart';
export '../features/settings/application/app_settings_controller.dart';

/*
enum PracticeSessionStatus {
  idle,
  running,
  paused,
  stopped,
  permissionDenied,
  error,
}

class LivePracticeState {
  const LivePracticeState({
    this.status = PracticeSessionStatus.idle,
    this.currentSample,
    this.timeInRangePercent = 0,
    this.voicedTimeMs = 0,
    this.message,
  });

  final PracticeSessionStatus status;
  final PitchSample? currentSample;
  final double timeInRangePercent;
  final int voicedTimeMs;
  final String? message;

  LivePracticeState copyWith({
    PracticeSessionStatus? status,
    PitchSample? currentSample,
    double? timeInRangePercent,
    int? voicedTimeMs,
    String? message,
  }) {
    return LivePracticeState(
      status: status ?? this.status,
      currentSample: currentSample ?? this.currentSample,
      timeInRangePercent: timeInRangePercent ?? this.timeInRangePercent,
      voicedTimeMs: voicedTimeMs ?? this.voicedTimeMs,
      message: message,
    );
  }
}

class LivePracticeController extends Notifier<LivePracticeState> {
  StreamSubscription<PitchSample>? _subscription;
  final List<PitchSample> _samples = <PitchSample>[];

  @override
  LivePracticeState build() {
    ref.onDispose(() {
      unawaited(_subscription?.cancel());
      unawaited(ref.read(livePitchEngineProvider).stop());
    });
    return const LivePracticeState();
  }

  Future<void> start() async {
    final target = ref.read(currentTargetProvider).asData?.value;
    if (target == null) {
      state = state.copyWith(
        status: PracticeSessionStatus.error,
        message: 'No target saved.',
      );
      return;
    }

    final permissionService = ref.read(audioPermissionServiceProvider);
    var permissionStatus = await permissionService.checkStatus();
    if (permissionStatus != AudioPermissionStatus.granted) {
      permissionStatus = await permissionService.requestPermission();
    }
    if (permissionStatus != AudioPermissionStatus.granted) {
      state = state.copyWith(status: PracticeSessionStatus.permissionDenied);
      return;
    }

    await _subscription?.cancel();
    _samples.clear();
    final stream = await ref.read(livePitchEngineProvider).start(
      target: target,
      smoothingWindowMs: ref.read(
        appSettingsControllerProvider.select(
          (settings) => settings.smoothingWindowMs,
        ),
      ),
    );
    _subscription = stream.listen(_handleSample);
    state = state.copyWith(
      status: PracticeSessionStatus.running,
      currentSample: null,
      timeInRangePercent: 0,
      voicedTimeMs: 0,
      message: null,
    );
  }

  Future<void> pause() async {
    await ref.read(livePitchEngineProvider).pause();
    state = state.copyWith(status: PracticeSessionStatus.paused);
  }

  Future<void> resume() async {
    await ref.read(livePitchEngineProvider).resume();
    state = state.copyWith(status: PracticeSessionStatus.running);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await ref.read(livePitchEngineProvider).stop();
    state = state.copyWith(status: PracticeSessionStatus.stopped);
  }

  Future<void> openSettings() {
    return ref.read(audioPermissionServiceProvider).openAppSettings();
  }

  void _handleSample(PitchSample sample) {
    _samples.add(sample);
    final analysis = ref.read(analysisServiceProvider).analyze(_samples);
    final percent = analysis.totalVoicedTimeMs == 0
        ? 0
        : (analysis.timeInRangeMs / analysis.totalVoicedTimeMs) * 100;
    state = state.copyWith(
      currentSample: sample,
      timeInRangePercent: percent,
      voicedTimeMs: analysis.totalVoicedTimeMs,
    );
  }
}

class RecordSessionState {
  const RecordSessionState({
    this.status = PracticeSessionStatus.idle,
    this.currentSample,
    this.selectedPracticeTextId,
    this.lastSavedSessionId,
    this.averagePitchHz,
    this.rangeText,
    this.timeInRangePercent = 0,
    this.message,
  });

  final PracticeSessionStatus status;
  final PitchSample? currentSample;
  final String? selectedPracticeTextId;
  final String? lastSavedSessionId;
  final double? averagePitchHz;
  final String? rangeText;
  final double timeInRangePercent;
  final String? message;

  RecordSessionState copyWith({
    PracticeSessionStatus? status,
    PitchSample? currentSample,
    String? selectedPracticeTextId,
    String? lastSavedSessionId,
    double? averagePitchHz,
    String? rangeText,
    double? timeInRangePercent,
    String? message,
  }) {
    return RecordSessionState(
      status: status ?? this.status,
      currentSample: currentSample ?? this.currentSample,
      selectedPracticeTextId: selectedPracticeTextId ?? this.selectedPracticeTextId,
      lastSavedSessionId: lastSavedSessionId ?? this.lastSavedSessionId,
      averagePitchHz: averagePitchHz ?? this.averagePitchHz,
      rangeText: rangeText ?? this.rangeText,
      timeInRangePercent: timeInRangePercent ?? this.timeInRangePercent,
      message: message,
    );
  }
}

class RecordSessionController extends Notifier<RecordSessionState> {
  StreamSubscription<RecordingChunk>? _subscription;
  final List<PitchSample> _samples = <PitchSample>[];
  DateTime? _startedAt;

  @override
  RecordSessionState build() {
    ref.onDispose(() {
      unawaited(_subscription?.cancel());
    });
    return const RecordSessionState();
  }

  void selectPracticeText(String? practiceTextId) {
    state = state.copyWith(selectedPracticeTextId: practiceTextId);
  }

  Future<void> start() async {
    final target = ref.read(currentTargetProvider).asData?.value;
    if (target == null) {
      state = state.copyWith(
        status: PracticeSessionStatus.error,
        message: 'No target saved.',
      );
      return;
    }

    final permissionService = ref.read(audioPermissionServiceProvider);
    var permissionStatus = await permissionService.checkStatus();
    if (permissionStatus != AudioPermissionStatus.granted) {
      permissionStatus = await permissionService.requestPermission();
    }
    if (permissionStatus != AudioPermissionStatus.granted) {
      state = state.copyWith(status: PracticeSessionStatus.permissionDenied);
      return;
    }

    await _subscription?.cancel();
    _samples.clear();
    _startedAt = DateTime.now();
    final stream = await ref.read(recordingEngineProvider).start(
      target: target,
      smoothingWindowMs: ref.read(
        appSettingsControllerProvider.select(
          (settings) => settings.smoothingWindowMs,
        ),
      ),
    );
    _subscription = stream.listen((chunk) {
      _samples.add(chunk.sample);
      final showLiveFeedback = ref.read(
        appSettingsControllerProvider.select(
          (settings) => settings.showLiveFeedbackDuringRecording,
        ),
      );
      final analysis = ref.read(analysisServiceProvider).analyze(_samples);
      state = state.copyWith(
        currentSample: showLiveFeedback ? chunk.sample : null,
        timeInRangePercent: analysis.totalVoicedTimeMs == 0
            ? 0
            : (analysis.timeInRangeMs / analysis.totalVoicedTimeMs) * 100,
      );
    });
    state = state.copyWith(
      status: PracticeSessionStatus.running,
      lastSavedSessionId: null,
      averagePitchHz: null,
      rangeText: null,
      message: null,
    );
  }

  Future<void> pause() async {
    await ref.read(recordingEngineProvider).pause();
    state = state.copyWith(status: PracticeSessionStatus.paused);
  }

  Future<void> resume() async {
    await ref.read(recordingEngineProvider).resume();
    state = state.copyWith(status: PracticeSessionStatus.running);
  }

  Future<String?> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    final startedAt = _startedAt ?? DateTime.now();
    final outputDir = await getApplicationDocumentsDirectory();
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();
    final outputPath = '${outputDir.path}${Platform.pathSeparator}recordings${Platform.pathSeparator}$sessionId.wav';
    final savedPath = await ref.read(recordingEngineProvider).stop(
      outputPath: outputPath,
    );

    final target = ref.read(currentTargetProvider).asData!.value!;
    final analysis = ref.read(analysisServiceProvider).analyze(_samples);
    final session = PracticeSession(
      id: sessionId,
      startedAt: startedAt,
      endedAt: DateTime.now(),
      mode: PracticeSessionMode.recording,
      targetRangeSnapshot: target,
      averagePitchHz: analysis.averagePitchHz,
      minPitchHz: analysis.minPitchHz,
      maxPitchHz: analysis.maxPitchHz,
      timeInRangeMs: analysis.timeInRangeMs,
      totalVoicedTimeMs: analysis.totalVoicedTimeMs,
      audioFilePath: savedPath,
      chartPoints: analysis.chartPoints,
      practiceTextId: state.selectedPracticeTextId,
    );

    await ref.read(practiceSessionRepositoryProvider).saveSession(session);

    final rangeText = analysis.minPitchHz == null || analysis.maxPitchHz == null
        ? null
        : '${analysis.minPitchHz!.round()}-${analysis.maxPitchHz!.round()} Hz';
    state = state.copyWith(
      status: PracticeSessionStatus.stopped,
      lastSavedSessionId: sessionId,
      averagePitchHz: analysis.averagePitchHz,
      rangeText: rangeText,
      timeInRangePercent: session.timeInRangePercent,
    );
    _samples.clear();
    return sessionId;
  }
}
*/
