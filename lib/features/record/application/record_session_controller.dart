import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/app_providers.dart';
import '../../../core/audio/domain/audio_contracts.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../practice/application/live_practice_controller.dart';
import '../../practice/domain/pitch_sample.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../settings/application/app_locale.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../sync/application/sync_controller.dart';
import '../domain/practice_session.dart';
import '../domain/practice_text.dart';

class RecordSessionReview {
  const RecordSessionReview({
    required this.capture,
    required this.analysis,
    required this.startedAt,
    required this.endedAt,
    required this.targetLabel,
    required this.practiceTextId,
    required this.trackingMode,
  });

  final RecordedAudioCapture capture;
  final SessionAnalysis analysis;
  final DateTime startedAt;
  final DateTime endedAt;
  final String targetLabel;
  final String? practiceTextId;
  final PitchTrainingMode trackingMode;
}

class RecordSessionState {
  const RecordSessionState({
    this.status = PracticeSessionStatus.idle,
    this.currentSample,
    this.selectedPracticeTextId,
    this.averagePitchHz,
    this.targetLabel,
    this.timeAtTargetPercent = 0,
    this.review,
    this.message,
  });

  final PracticeSessionStatus status;
  final PitchSample? currentSample;
  final String? selectedPracticeTextId;
  final double? averagePitchHz;
  final String? targetLabel;
  final double timeAtTargetPercent;
  final RecordSessionReview? review;
  final String? message;

  RecordSessionState copyWith({
    PracticeSessionStatus? status,
    PitchSample? currentSample,
    String? selectedPracticeTextId,
    double? averagePitchHz,
    String? targetLabel,
    double? timeAtTargetPercent,
    RecordSessionReview? review,
    bool clearReview = false,
    String? message,
  }) {
    return RecordSessionState(
      status: status ?? this.status,
      currentSample: currentSample ?? this.currentSample,
      selectedPracticeTextId:
          selectedPracticeTextId ?? this.selectedPracticeTextId,
      averagePitchHz: averagePitchHz ?? this.averagePitchHz,
      targetLabel: targetLabel ?? this.targetLabel,
      timeAtTargetPercent: timeAtTargetPercent ?? this.timeAtTargetPercent,
      review: clearReview ? null : (review ?? this.review),
      message: message,
    );
  }
}

final localizedPracticeTextsProvider = Provider<List<PracticeText>>((ref) {
  final localeCode = ref.watch(
    appSettingsControllerProvider.select((settings) => settings.localeCode),
  );
  return ref
      .watch(practiceTextRepositoryProvider)
      .listForLocale(resolveEffectiveLocaleCode(localeCode));
});

final recordSessionControllerProvider =
    NotifierProvider.autoDispose<RecordSessionController, RecordSessionState>(
      RecordSessionController.new,
    );

class RecordSessionController extends Notifier<RecordSessionState> {
  static const _uiUpdateIntervalMs = 50;

  StreamSubscription<RecordingChunk>? _subscription;
  final List<PitchSample> _samples = <PitchSample>[];
  DateTime? _startedAt;
  int _lastUiUpdateTimestampMs = 0;

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
    final target = ref.read(activeTargetProvider);
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
    _startedAt = DateTime.now().toUtc();
    _lastUiUpdateTimestampMs = 0;
    final settings = ref.read(appSettingsControllerProvider);
    final stream = await ref
        .read(recordingEngineProvider)
        .start(
          target: target,
          toleranceHz: settings.targetToleranceHz,
          trainingMode: settings.lastPitchTrainingMode,
          smoothingWindowMs: settings.smoothingWindowMs,
        );
    _subscription = stream.listen(
      _handleChunk,
      onError: (error, stackTrace) {
        state = state.copyWith(
          status: PracticeSessionStatus.error,
          message: error.toString(),
        );
      },
    );
    state = state.copyWith(
      status: PracticeSessionStatus.running,
      averagePitchHz: null,
      targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
      timeAtTargetPercent: 0,
      clearReview: true,
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

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    final target = ref.read(activeTargetProvider);
    if (target == null) {
      state = state.copyWith(
        status: PracticeSessionStatus.error,
        message: 'No target saved.',
      );
      return;
    }

    final startedAt = _startedAt ?? DateTime.now().toUtc();
    final outputDir = await getApplicationDocumentsDirectory();
    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();
    final outputPath =
        '${outputDir.path}${Platform.pathSeparator}recordings${Platform.pathSeparator}$sessionId.wav';
    final capture = await ref
        .read(recordingEngineProvider)
        .stop(outputPath: outputPath);
    if (capture == null) {
      state = state.copyWith(
        status: PracticeSessionStatus.error,
        message: 'Recording could not be saved.',
      );
      return;
    }

    final settings = ref.read(appSettingsControllerProvider);
    final analysis = await ref
        .read(analysisServiceProvider)
        .analyzeRecordedAudio(
          pcmBytes: capture.pcmBytes,
          sampleRate: capture.sampleRate,
          channelCount: capture.channelCount,
          target: target,
          toleranceHz: settings.targetToleranceHz,
          trainingMode: settings.lastPitchTrainingMode,
          smoothingWindowMs: settings.smoothingWindowMs,
        );
    final endedAt = DateTime.now().toUtc();

    state = state.copyWith(
      status: PracticeSessionStatus.reviewReady,
      averagePitchHz: analysis.averagePitchHz,
      targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
      timeAtTargetPercent: analysis.totalTrackedTimeMs == 0
          ? 0
          : (analysis.timeAtTargetMs / analysis.totalTrackedTimeMs) * 100,
      currentSample: null,
      review: RecordSessionReview(
        capture: capture,
        analysis: analysis,
        startedAt: startedAt,
        endedAt: endedAt,
        targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
        practiceTextId:
            settings.lastPitchTrainingMode == PitchTrainingMode.speech
            ? state.selectedPracticeTextId
            : null,
        trackingMode: settings.lastPitchTrainingMode,
      ),
    );
    _samples.clear();
  }

  Future<String?> saveReview() async {
    final review = state.review;
    final target = ref.read(activeTargetProvider);
    final settings = ref.read(appSettingsControllerProvider);
    if (review == null || target == null) {
      return null;
    }

    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();
    final session = PracticeSession(
      id: sessionId,
      startedAt: review.startedAt,
      endedAt: review.endedAt,
      updatedAt: review.endedAt,
      mode: PracticeSessionMode.recording,
      trackingMode: review.trackingMode,
      targetSnapshot: target,
      targetToleranceHz: settings.targetToleranceHz,
      targetVolumeToleranceDb: settings.targetVolumeToleranceDb,
      averagePitchHz: review.analysis.averagePitchHz,
      minPitchHz: review.analysis.minPitchHz,
      maxPitchHz: review.analysis.maxPitchHz,
      timeAtTargetMs: review.analysis.timeAtTargetMs,
      totalTrackedTimeMs: review.analysis.totalTrackedTimeMs,
      audioFilePath: review.capture.filePath,
      chartPoints: review.analysis.chartPoints,
      practiceTextId: review.practiceTextId,
      resonanceState: review.analysis.resonanceAnalysis?.dominantState,
      resonanceBalancedPercent:
          review.analysis.resonanceAnalysis?.balancedTrackedPercent,
      resonanceAverageConfidence:
          review.analysis.resonanceAnalysis?.averageConfidence,
    );
    await ref.read(practiceSessionRepositoryProvider).saveSession(session);
    ref.read(syncControllerProvider.notifier).scheduleSync();
    state = state.copyWith(
      status: PracticeSessionStatus.idle,
      currentSample: null,
      averagePitchHz: null,
      targetLabel: null,
      timeAtTargetPercent: 0,
      clearReview: true,
      message: null,
    );
    return sessionId;
  }

  Future<void> discardReview() async {
    final filePath = state.review?.capture.filePath;
    if (filePath != null) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    state = state.copyWith(
      status: PracticeSessionStatus.idle,
      currentSample: null,
      averagePitchHz: null,
      targetLabel: state.targetLabel,
      timeAtTargetPercent: 0,
      clearReview: true,
      message: null,
    );
  }

  Future<void> restartReview() async {
    await discardReview();
    await start();
  }

  void _handleChunk(RecordingChunk chunk) {
    _samples.add(chunk.sample);
    final shouldRefreshUi =
        chunk.sample.timestampMs - _lastUiUpdateTimestampMs >=
            _uiUpdateIntervalMs ||
        chunk.sample.stateCategory == PitchStateCategory.unvoiced;

    if (!shouldRefreshUi) {
      return;
    }

    final settings = ref.read(appSettingsControllerProvider);
    final target = ref.read(activeTargetProvider);
    if (target == null) {
      return;
    }

    final analysis = ref
        .read(analysisServiceProvider)
        .analyzeTrackedSamples(
          samples: _samples,
          target: target,
          toleranceHz: settings.targetToleranceHz,
          trainingMode: settings.lastPitchTrainingMode,
        );
    final showLiveFeedback = settings.showLiveFeedbackDuringRecording;
    final timeAtTargetPercent = analysis.totalTrackedTimeMs == 0
        ? 0.0
        : (analysis.timeAtTargetMs / analysis.totalTrackedTimeMs) * 100;

    _lastUiUpdateTimestampMs = chunk.sample.timestampMs;
    state = state.copyWith(
      currentSample: showLiveFeedback ? chunk.sample : null,
      averagePitchHz: analysis.averagePitchHz,
      timeAtTargetPercent: timeAtTargetPercent,
      targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
    );
  }
}
