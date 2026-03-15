import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../core/audio/domain/audio_contracts.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../record/domain/practice_session.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../sync/application/sync_controller.dart';
import '../../training/application/training_plan_controller.dart';
import '../../training/domain/training_exercise_mode.dart';
import '../domain/pitch_sample.dart';

enum PracticeSessionStatus {
  idle,
  running,
  paused,
  reviewReady,
  permissionDenied,
  error,
}

class PracticeSessionReview {
  const PracticeSessionReview({
    required this.analysis,
    required this.startedAt,
    required this.endedAt,
    required this.targetLabel,
  });

  final SessionAnalysis analysis;
  final DateTime startedAt;
  final DateTime endedAt;
  final String targetLabel;
}

class LivePracticeState {
  const LivePracticeState({
    this.status = PracticeSessionStatus.idle,
    this.currentSample,
    this.recentSamples = const [],
    this.timeAtTargetPercent = 0,
    this.trackedTimeMs = 0,
    this.averagePitchHz,
    this.selectedExerciseMode = TrainingExerciseMode.general,
    this.plannedDurationMinutes = 10,
    this.remainingSeconds = 600,
    this.review,
    this.message,
  });

  final PracticeSessionStatus status;
  final PitchSample? currentSample;
  final List<PitchSample> recentSamples;
  final double timeAtTargetPercent;
  final int trackedTimeMs;
  final double? averagePitchHz;
  final TrainingExerciseMode selectedExerciseMode;
  final int plannedDurationMinutes;
  final int remainingSeconds;
  final PracticeSessionReview? review;
  final String? message;

  LivePracticeState copyWith({
    PracticeSessionStatus? status,
    PitchSample? currentSample,
    List<PitchSample>? recentSamples,
    double? timeAtTargetPercent,
    int? trackedTimeMs,
    double? averagePitchHz,
    TrainingExerciseMode? selectedExerciseMode,
    int? plannedDurationMinutes,
    int? remainingSeconds,
    PracticeSessionReview? review,
    bool clearReview = false,
    String? message,
  }) {
    return LivePracticeState(
      status: status ?? this.status,
      currentSample: currentSample ?? this.currentSample,
      recentSamples: recentSamples ?? this.recentSamples,
      timeAtTargetPercent: timeAtTargetPercent ?? this.timeAtTargetPercent,
      trackedTimeMs: trackedTimeMs ?? this.trackedTimeMs,
      averagePitchHz: averagePitchHz ?? this.averagePitchHz,
      selectedExerciseMode: selectedExerciseMode ?? this.selectedExerciseMode,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      review: clearReview ? null : (review ?? this.review),
      message: message,
    );
  }
}

final livePracticeControllerProvider =
    NotifierProvider.autoDispose<LivePracticeController, LivePracticeState>(
      LivePracticeController.new,
    );

class LivePracticeController extends Notifier<LivePracticeState> {
  static const _uiUpdateIntervalMs = 50;
  static const _recentSampleWindowMs = 4500;
  static const _pitchHoldMs = 1500;

  StreamSubscription<PitchSample>? _subscription;
  Timer? _countdownTimer;
  final List<PitchSample> _samples = <PitchSample>[];
  int _lastUiUpdateTimestampMs = 0;
  int? _lastVoicedTimestampMs;
  DateTime? _startedAt;

  @override
  LivePracticeState build() {
    final plan = ref.watch(todayTrainingDayPlanProvider);
    final livePitchEngine = ref.read(livePitchEngineProvider);
    ref.onDispose(() {
      _countdownTimer?.cancel();
      unawaited(_subscription?.cancel());
      unawaited(livePitchEngine.stop());
    });
    return LivePracticeState(
      selectedExerciseMode: plan.exerciseMode,
      plannedDurationMinutes: plan.durationMinutes,
      remainingSeconds: plan.durationMinutes * 60,
    );
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
    _lastUiUpdateTimestampMs = 0;
    _lastVoicedTimestampMs = null;
    _startedAt = DateTime.now().toUtc();
    var settings = ref.read(appSettingsControllerProvider);
    final recommendedMode = state.selectedExerciseMode.recommendedTrackingMode;
    if (recommendedMode != null &&
        settings.lastPitchTrainingMode != recommendedMode) {
      await ref
          .read(appSettingsControllerProvider.notifier)
          .setLastPitchTrainingMode(recommendedMode);
      settings = ref.read(appSettingsControllerProvider);
    }
    _countdownTimer?.cancel();
    final totalSeconds = state.plannedDurationMinutes * 60;
    final stream = await ref
        .read(livePitchEngineProvider)
        .start(
          target: target,
          toleranceHz: settings.targetToleranceHz,
          trainingMode: settings.lastPitchTrainingMode,
          smoothingWindowMs: settings.smoothingWindowMs,
        );
    _subscription = stream.listen(
      _handleSample,
      onError: (error, stackTrace) {
        state = state.copyWith(
          status: PracticeSessionStatus.error,
          message: error.toString(),
        );
      },
    );
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      _handleTimerTick,
    );
    state = state.copyWith(
      status: PracticeSessionStatus.running,
      currentSample: null,
      recentSamples: const [],
      timeAtTargetPercent: 0,
      trackedTimeMs: 0,
      averagePitchHz: null,
      remainingSeconds: totalSeconds,
      clearReview: true,
      message: null,
    );
  }

  Future<void> pause() async {
    await ref.read(livePitchEngineProvider).pause();
    _countdownTimer?.cancel();
    state = state.copyWith(status: PracticeSessionStatus.paused);
  }

  Future<void> resume() async {
    await ref.read(livePitchEngineProvider).resume();
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      _handleTimerTick,
    );
    state = state.copyWith(status: PracticeSessionStatus.running);
  }

  Future<void> stop() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await ref.read(livePitchEngineProvider).stop();

    final target = ref.read(activeTargetProvider);
    final settings = ref.read(appSettingsControllerProvider);
    if (target == null) {
      state = state.copyWith(
        status: PracticeSessionStatus.error,
        message: 'No target saved.',
      );
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
    final review = PracticeSessionReview(
      analysis: analysis,
      startedAt: _startedAt ?? DateTime.now().toUtc(),
      endedAt: DateTime.now().toUtc(),
      targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
    );
    state = state.copyWith(
      status: PracticeSessionStatus.reviewReady,
      currentSample: null,
      recentSamples: _samples.toList(growable: false),
      timeAtTargetPercent: analysis.totalTrackedTimeMs == 0
          ? 0
          : (analysis.timeAtTargetMs / analysis.totalTrackedTimeMs) * 100,
      trackedTimeMs: analysis.totalTrackedTimeMs,
      averagePitchHz: analysis.averagePitchHz,
      review: review,
    );
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
      mode: PracticeSessionMode.practice,
      trackingMode: settings.lastPitchTrainingMode,
      targetSnapshot: target,
      targetToleranceHz: settings.targetToleranceHz,
      targetVolumeToleranceDb: settings.targetVolumeToleranceDb,
      averagePitchHz: review.analysis.averagePitchHz,
      minPitchHz: review.analysis.minPitchHz,
      maxPitchHz: review.analysis.maxPitchHz,
      timeAtTargetMs: review.analysis.timeAtTargetMs,
      totalTrackedTimeMs: review.analysis.totalTrackedTimeMs,
      audioFilePath: null,
      chartPoints: review.analysis.chartPoints,
      practiceTextId: null,
      resonanceState: review.analysis.resonanceAnalysis?.dominantState,
      resonanceBalancedPercent:
          review.analysis.resonanceAnalysis?.balancedTrackedPercent,
      resonanceAverageConfidence:
          review.analysis.resonanceAnalysis?.averageConfidence,
    );
    await ref.read(practiceSessionRepositoryProvider).saveSession(session);
    ref.read(syncControllerProvider.notifier).scheduleSync();
    discardReview();
    return sessionId;
  }

  void discardReview() {
    _samples.clear();
    _startedAt = null;
    state = state.copyWith(
      status: PracticeSessionStatus.idle,
      currentSample: null,
      recentSamples: const [],
      timeAtTargetPercent: 0,
      trackedTimeMs: 0,
      averagePitchHz: null,
      remainingSeconds: state.plannedDurationMinutes * 60,
      clearReview: true,
      message: null,
    );
  }

  Future<void> repeatSession() async {
    discardReview();
    await start();
  }

  void setExerciseMode(TrainingExerciseMode mode) {
    state = state.copyWith(selectedExerciseMode: mode);
  }

  void setPlannedDurationMinutes(int minutes) {
    state = state.copyWith(
      plannedDurationMinutes: minutes,
      remainingSeconds: state.status == PracticeSessionStatus.running
          ? state.remainingSeconds
          : minutes * 60,
    );
  }

  Future<void> openSettings() {
    return ref.read(audioPermissionServiceProvider).openAppSettings();
  }

  void _handleSample(PitchSample sample) {
    _samples.add(sample);
    if (sample.isVoiced && sample.frequencyHz != null) {
      _lastVoicedTimestampMs = sample.timestampMs;
    }
    final shouldRefreshUi =
        sample.timestampMs - _lastUiUpdateTimestampMs >= _uiUpdateIntervalMs ||
        sample.stateCategory == PitchStateCategory.unvoiced;

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
    final timeAtTargetPercent = analysis.totalTrackedTimeMs == 0
        ? 0.0
        : (analysis.timeAtTargetMs / analysis.totalTrackedTimeMs) * 100;

    _lastUiUpdateTimestampMs = sample.timestampMs;
    final anchorTimestamp = _anchoredTimestamp(sample.timestampMs);
    final recentSamples = <PitchSample>[...state.recentSamples, sample]
      ..removeWhere(
        (entry) => anchorTimestamp - entry.timestampMs > _recentSampleWindowMs,
      );
    state = state.copyWith(
      currentSample: sample,
      recentSamples: recentSamples,
      timeAtTargetPercent: timeAtTargetPercent,
      trackedTimeMs: analysis.totalTrackedTimeMs,
      averagePitchHz: analysis.averagePitchHz,
    );
  }

  int _anchoredTimestamp(int currentTimestampMs) {
    final lastVoicedTimestampMs = _lastVoicedTimestampMs;
    if (lastVoicedTimestampMs == null) {
      return currentTimestampMs;
    }
    return math.min(currentTimestampMs, lastVoicedTimestampMs + _pitchHoldMs);
  }

  void _handleTimerTick(Timer timer) {
    if (state.status != PracticeSessionStatus.running) {
      return;
    }
    if (state.remainingSeconds <= 1) {
      state = state.copyWith(remainingSeconds: 0);
      timer.cancel();
      unawaited(stop());
      return;
    }
    state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
  }
}
