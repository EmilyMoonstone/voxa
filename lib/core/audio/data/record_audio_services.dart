import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audio_decoder/audio_decoder.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';

import 'heuristic_resonance_analyzer.dart';
import '../../../features/goal_setting/domain/voice_target.dart';
import '../../../features/practice/application/live_pitch_signal_processor.dart';
import '../../../features/practice/domain/pitch_sample.dart';
import '../../../features/practice/domain/pitch_training_mode.dart';
import '../../../features/practice/domain/resonance_feedback.dart';
import '../../../features/record/domain/practice_session.dart';
import '../domain/audio_contracts.dart';

class PermissionHandlerAudioPermissionService
    implements AudioPermissionService {
  @override
  Future<AudioPermissionStatus> checkStatus() async {
    final status = await permission.Permission.microphone.status;
    return _mapPermission(status);
  }

  @override
  Future<AudioPermissionStatus> requestPermission() async {
    final status = await permission.Permission.microphone.request();
    return _mapPermission(status);
  }

  @override
  Future<void> openAppSettings() async {
    await permission.openAppSettings();
  }

  AudioPermissionStatus _mapPermission(permission.PermissionStatus status) {
    if (status.isPermanentlyDenied || status.isRestricted) {
      return AudioPermissionStatus.permanentlyDenied;
    }
    if (status.isGranted || status.isLimited) {
      return AudioPermissionStatus.granted;
    }
    return AudioPermissionStatus.denied;
  }
}

class RecordLivePitchEngine implements LivePitchEngine {
  RecordLivePitchEngine()
    : _recorder = AudioRecorder(),
      _processor = _PcmPitchProcessor(
        config: const PitchTrackingConfig.live(),
        resonanceAnalyzerFactory: HeuristicResonanceAnalyzer.new,
      );

  final AudioRecorder _recorder;
  final _PcmPitchProcessor _processor;

  StreamSubscription<Uint8List>? _subscription;
  StreamController<PitchSample>? _controller;

  @override
  Future<Stream<PitchSample>> start({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) async {
    await stop();
    _processor.reset(
      target: target,
      toleranceHz: toleranceHz,
      trainingMode: trainingMode,
      smoothingWindowMs: smoothingWindowMs,
    );

    _controller = StreamController<PitchSample>.broadcast();
    final bytesStream = await _recorder.startStream(_recordConfig);
    _subscription = bytesStream.listen((chunk) async {
      try {
        final samples = await _processor.processBytes(chunk);
        if (samples.isNotEmpty) {
          _controller?.add(samples.last);
        }
      } catch (error, stackTrace) {
        _controller?.addError(error, stackTrace);
      }
    });
    return _controller!.stream;
  }

  @override
  Future<void> pause() => _recorder.pause();

  @override
  Future<void> resume() => _recorder.resume();

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _controller?.close();
    _controller = null;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }
}

class RecordRecordingEngine implements RecordingEngine {
  RecordRecordingEngine()
    : _recorder = AudioRecorder(),
      _processor = _PcmPitchProcessor(
        config: const PitchTrackingConfig.live(),
        resonanceAnalyzerFactory: HeuristicResonanceAnalyzer.new,
      );

  final AudioRecorder _recorder;
  final _PcmPitchProcessor _processor;

  final BytesBuilder _bytesBuilder = BytesBuilder(copy: false);
  StreamSubscription<Uint8List>? _subscription;
  StreamController<RecordingChunk>? _controller;

  @override
  Future<Stream<RecordingChunk>> start({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) async {
    await _cleanup(stopRecorder: true);
    _processor.reset(
      target: target,
      toleranceHz: toleranceHz,
      trainingMode: trainingMode,
      smoothingWindowMs: smoothingWindowMs,
    );
    _bytesBuilder.clear();

    _controller = StreamController<RecordingChunk>.broadcast();
    final bytesStream = await _recorder.startStream(_recordConfig);
    _subscription = bytesStream.listen((chunk) async {
      _bytesBuilder.add(chunk);
      try {
        final samples = await _processor.processBytes(chunk);
        if (samples.isNotEmpty) {
          final sample = samples.last;
          _controller?.add(
            RecordingChunk(
              sample: sample,
              bytes: chunk.toList(growable: false),
            ),
          );
        }
      } catch (error, stackTrace) {
        _controller?.addError(error, stackTrace);
      }
    });
    return _controller!.stream;
  }

  @override
  Future<void> pause() => _recorder.pause();

  @override
  Future<void> resume() => _recorder.resume();

  @override
  Future<RecordedAudioCapture?> stop({required String outputPath}) async {
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }

    await _subscription?.cancel();
    _subscription = null;
    final pcmBytes = Uint8List.fromList(_bytesBuilder.takeBytes());
    final file = File(outputPath);
    final wavBytes = _encodeWavePcm16(
      pcmBytes: pcmBytes,
      sampleRate: _recordConfig.sampleRate,
      channelCount: _recordConfig.numChannels,
    );
    await file.create(recursive: true);
    await file.writeAsBytes(wavBytes, flush: true);
    await _controller?.close();
    _controller = null;
    return RecordedAudioCapture(
      filePath: file.path,
      pcmBytes: pcmBytes,
      sampleRate: _recordConfig.sampleRate,
      channelCount: _recordConfig.numChannels,
    );
  }

  Future<void> _cleanup({required bool stopRecorder}) async {
    await _subscription?.cancel();
    _subscription = null;
    await _controller?.close();
    _controller = null;
    if (stopRecorder && await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }
}

class DefaultImportedPitchAnalysisService
    implements ImportedPitchAnalysisService {
  const DefaultImportedPitchAnalysisService();

  static const _decodeTimeout = Duration(seconds: 20);
  static const _analysisTimeout = Duration(seconds: 20);
  static const _maxAnalysisDurationSeconds = 12;
  static const _targetVoicedSamples = 96;

  @override
  Future<ImportedPitchSuggestion> analyzeAudioFile({
    required String filePath,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) async {
    final bytes = await _loadImportableAudioBytes(filePath);
    final result =
        await Isolate.run<Map<String, Object?>>(
          () => _analyzeImportedPitchBytes(
            transferableBytes: TransferableTypedData.fromList([bytes]),
            trainingModeStorageValue: trainingMode.storageValue,
            smoothingWindowMs: smoothingWindowMs,
            maxAnalysisDurationSeconds: _maxAnalysisDurationSeconds,
            targetVoicedSamples: _targetVoicedSamples,
          ),
        ).timeout(
          _analysisTimeout,
          onTimeout: () => throw const FormatException(
            'Analyzing the selected audio file took too long. Try a shorter recording or import a WAV file.',
          ),
        );
    return ImportedPitchSuggestion(
      targetHz: result['targetHz']! as double,
      voicedSampleCount: result['voicedSampleCount']! as int,
    );
  }

  Future<Uint8List> _loadImportableAudioBytes(String filePath) async {
    final sourceBytes = await File(filePath).readAsBytes();
    if (_looksLikeWaveFile(sourceBytes)) {
      return sourceBytes;
    }

    final formatHint = _audioFormatHintFromPath(filePath);
    if (formatHint == null) {
      throw UnsupportedError(_supportedImportFormatsMessage);
    }

    try {
      final tempFile = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'voxa-import-${DateTime.now().microsecondsSinceEpoch}.wav',
      );
      try {
        final outputPath =
            await AudioDecoder.convertToWav(
              filePath,
              tempFile.path,
              sampleRate: 44100,
              channels: 1,
              bitDepth: 16,
            ).timeout(
              _decodeTimeout,
              onTimeout: () => throw const FormatException(
                'Decoding the selected audio file took too long. Try a shorter recording or export it as WAV.',
              ),
            );
        return await File(outputPath).readAsBytes();
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    } on AudioConversionException {
      throw UnsupportedError(_supportedImportFormatsMessage);
    } on TimeoutException {
      rethrow;
    }
  }
}

class DefaultTargetVolumeCalibrationService
    implements TargetVolumeCalibrationService {
  const DefaultTargetVolumeCalibrationService();

  static const _captureDuration = Duration(seconds: 3);

  @override
  Future<double> captureTargetVolumeDbfs({
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) async {
    final recorder = AudioRecorder();
    final processor = _PcmPitchProcessor(
      config: const PitchTrackingConfig.live(),
      resonanceAnalyzerFactory: _NoOpResonanceAnalyzer.new,
    );
    processor.reset(
      target: _analysisTarget,
      toleranceHz: 10,
      trainingMode: trainingMode,
      smoothingWindowMs: smoothingWindowMs,
    );

    final voicedDbfs = <double>[];
    StreamSubscription<Uint8List>? subscription;
    try {
      final stream = await recorder.startStream(_recordConfig);
      subscription = stream.listen((chunk) async {
        final samples = await processor.processBytes(chunk);
        for (final sample in samples) {
          if (sample.isVoiced && sample.rmsDbfs > -70) {
            voicedDbfs.add(sample.rmsDbfs);
          }
        }
      });
      await Future<void>.delayed(_captureDuration);
    } finally {
      await subscription?.cancel();
      if (await recorder.isRecording()) {
        await recorder.stop();
      }
    }

    if (voicedDbfs.length < 4) {
      throw const FormatException(
        'No clear loud speech was captured. Try again and speak clearly for a few seconds.',
      );
    }

    voicedDbfs.sort();
    final topSliceStart =
        ((voicedDbfs.length * 0.6).floor().clamp(
              0,
              math.max(0, voicedDbfs.length - 1),
            )
            as int);
    final loudClearSamples = voicedDbfs.sublist(topSliceStart);
    return LivePitchSignalProcessor.rollingMedian(loudClearSamples);
  }
}

class DefaultAnalysisService implements AnalysisService {
  const DefaultAnalysisService();

  @override
  PitchStateCategory classify({
    required double? frequencyHz,
    required bool isVoiced,
    required VoiceTarget target,
    required int toleranceHz,
  }) {
    if (!isVoiced || frequencyHz == null) {
      return PitchStateCategory.unvoiced;
    }
    if (frequencyHz < target.targetHz - toleranceHz) {
      return PitchStateCategory.low;
    }
    if (frequencyHz > target.targetHz + toleranceHz) {
      return PitchStateCategory.high;
    }
    return PitchStateCategory.atTarget;
  }

  @override
  SessionAnalysis analyzeTrackedSamples({
    required Iterable<PitchSample> samples,
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
  }) {
    final sampleList = samples.toList(growable: false);
    final voicedSamples = sampleList
        .where((sample) => sample.isVoiced && sample.frequencyHz != null)
        .toList(growable: false);

    if (voicedSamples.isEmpty) {
      return SessionAnalysis(
        averagePitchHz: null,
        minPitchHz: null,
        maxPitchHz: null,
        timeAtTargetMs: 0,
        totalTrackedTimeMs: 0,
        chartPoints: _downsample(sampleList),
        resonanceAnalysis: const SessionResonanceAnalysis(
          dominantState: ResonanceState.insufficientSignal,
          balancedTrackedPercent: 0,
          averageConfidence: 0,
        ),
      );
    }

    final values = voicedSamples.map((sample) => sample.frequencyHz!).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final chart = _downsample(sampleList);

    final metrics = trainingMode == PitchTrainingMode.sound
        ? _analyzeSound(sampleList)
        : _analyzeSpeech(
            voicedSamples: voicedSamples,
            target: target,
            toleranceHz: toleranceHz,
          );
    return SessionAnalysis(
      averagePitchHz: average,
      minPitchHz: minValue,
      maxPitchHz: maxValue,
      timeAtTargetMs: metrics.timeAtTargetMs,
      totalTrackedTimeMs: metrics.totalTrackedTimeMs,
      chartPoints: chart,
      resonanceAnalysis: HeuristicResonanceAnalyzer().analyzeTrackedAudio(
        samples: sampleList,
        mode: trainingMode,
      ),
    );
  }

  @override
  Future<SessionAnalysis> analyzeRecordedAudio({
    required Uint8List pcmBytes,
    required int sampleRate,
    required int channelCount,
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) async {
    final processor = _PcmPitchProcessor(
      config: const PitchTrackingConfig.offline(),
      resonanceAnalyzerFactory: HeuristicResonanceAnalyzer.new,
      sampleRate: sampleRate,
      channelCount: channelCount,
    );
    processor.reset(
      target: target,
      toleranceHz: toleranceHz,
      trainingMode: trainingMode,
      smoothingWindowMs: smoothingWindowMs,
    );
    final trackedSamples = await processor.processAllBytes(pcmBytes);
    return analyzeTrackedSamples(
      samples: trackedSamples,
      target: target,
      toleranceHz: toleranceHz,
      trainingMode: trainingMode,
    );
  }

  _TrackingMetrics _analyzeSound(List<PitchSample> sampleList) {
    var totalTrackedTimeMs = 0;
    var timeAtTargetMs = 0;
    for (var index = 0; index < sampleList.length - 1; index++) {
      final current = sampleList[index];
      final next = sampleList[index + 1];
      final delta = math.max(0, next.timestampMs - current.timestampMs);
      if (!current.isVoiced || current.frequencyHz == null) {
        continue;
      }
      totalTrackedTimeMs += delta;
      if (current.stateCategory == PitchStateCategory.atTarget) {
        timeAtTargetMs += delta;
      }
    }
    return _TrackingMetrics(
      timeAtTargetMs: timeAtTargetMs,
      totalTrackedTimeMs: totalTrackedTimeMs,
    );
  }

  _TrackingMetrics _analyzeSpeech({
    required List<PitchSample> voicedSamples,
    required VoiceTarget target,
    required int toleranceHz,
  }) {
    const windowMs = 1200;
    const hopMs = 300;
    const minimumVoicedMaterialMs = 400;

    if (voicedSamples.length < 2) {
      return const _TrackingMetrics(timeAtTargetMs: 0, totalTrackedTimeMs: 0);
    }

    final typicalStepMs = _typicalStepMs(voicedSamples);
    final startMs = voicedSamples.first.timestampMs;
    final endMs = voicedSamples.last.timestampMs;

    var totalTrackedTimeMs = 0;
    var timeAtTargetMs = 0;
    for (
      var windowStart = startMs;
      windowStart <= endMs;
      windowStart += hopMs
    ) {
      final windowEnd = windowStart + windowMs;
      final windowSamples = voicedSamples
          .where(
            (sample) =>
                sample.timestampMs >= windowStart &&
                sample.timestampMs < windowEnd,
          )
          .toList(growable: false);
      if (windowSamples.isEmpty) {
        continue;
      }

      final voicedMaterialMs = windowSamples.length * typicalStepMs;
      if (voicedMaterialMs < minimumVoicedMaterialMs) {
        continue;
      }

      totalTrackedTimeMs += hopMs;
      final medianPitch = LivePitchSignalProcessor.rollingMedian(
        windowSamples
            .map((sample) => sample.frequencyHz!)
            .toList(growable: false),
      );
      if ((medianPitch - target.targetHz).abs() <= toleranceHz) {
        timeAtTargetMs += hopMs;
      }
    }

    return _TrackingMetrics(
      timeAtTargetMs: timeAtTargetMs,
      totalTrackedTimeMs: totalTrackedTimeMs,
    );
  }

  int _typicalStepMs(List<PitchSample> samples) {
    if (samples.length < 2) {
      return 0;
    }
    final deltas = <double>[];
    for (var index = 0; index < samples.length - 1; index++) {
      deltas.add(
        math
            .max(0, samples[index + 1].timestampMs - samples[index].timestampMs)
            .toDouble(),
      );
    }
    return LivePitchSignalProcessor.rollingMedian(deltas).round();
  }

  List<ChartPoint> _downsample(List<PitchSample> samples) {
    const targetPointCount = 72;
    if (samples.isEmpty) {
      return const [];
    }

    final step = math.max(1, (samples.length / targetPointCount).ceil());
    final points = <ChartPoint>[];
    for (var index = 0; index < samples.length; index += step) {
      final upperBound = math.min(samples.length, index + step);
      final bucket = samples.sublist(index, upperBound);
      final voicedBucket = bucket
          .where((sample) => sample.isVoiced && sample.frequencyHz != null)
          .toList(growable: false);
      final middleSample = bucket[bucket.length ~/ 2];
      if (voicedBucket.isEmpty) {
        points.add(
          ChartPoint(timestampMs: middleSample.timestampMs, frequencyHz: null),
        );
        continue;
      }
      final trackedFrequencies = voicedBucket
          .map((sample) => sample.frequencyHz!)
          .toList(growable: false);
      points.add(
        ChartPoint(
          timestampMs: middleSample.timestampMs,
          frequencyHz: LivePitchSignalProcessor.rollingMedian(
            trackedFrequencies,
          ),
        ),
      );
    }
    return points;
  }
}

final _analysisTarget = VoiceTarget(
  id: 'analysis-target',
  targetHz: 180,
  suggestionPreset: TargetPreset.custom,
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
);

Future<Map<String, Object?>> _analyzeImportedPitchBytes({
  required TransferableTypedData transferableBytes,
  required String trainingModeStorageValue,
  required int smoothingWindowMs,
  required int maxAnalysisDurationSeconds,
  required int targetVoicedSamples,
}) async {
  final bytes = transferableBytes.materialize().asUint8List();
  final parsed = _parseWaveFile(bytes);
  final processor = _PcmPitchProcessor(
    config: const PitchTrackingConfig.offline(),
    resonanceAnalyzerFactory: _NoOpResonanceAnalyzer.new,
    sampleRate: parsed.sampleRate,
    channelCount: 1,
  );
  processor.reset(
    target: _analysisTarget,
    toleranceHz: 10,
    trainingMode: PitchTrainingMode.fromStorage(trainingModeStorageValue),
    smoothingWindowMs: smoothingWindowMs,
  );
  final maxBytesToAnalyze = math.min(
    parsed.monoPcm16Bytes.length,
    parsed.sampleRate * 2 * maxAnalysisDurationSeconds,
  );
  const chunkBytes = 16384;
  final voicedFrequencies = <double>[];
  var offset = 0;
  while (offset < maxBytesToAnalyze &&
      voicedFrequencies.length < targetVoicedSamples) {
    final end = math.min(offset + chunkBytes, maxBytesToAnalyze);
    final trackedSamples = await processor.processBytes(
      Uint8List.sublistView(parsed.monoPcm16Bytes, offset, end),
    );
    for (final sample in trackedSamples) {
      if (sample.isVoiced && sample.frequencyHz != null) {
        voicedFrequencies.add(sample.frequencyHz!);
        if (voicedFrequencies.length >= targetVoicedSamples) {
          break;
        }
      }
    }
    offset = end;
  }
  if (voicedFrequencies.isEmpty) {
    throw const FormatException(
      'No usable voiced pitch was found in the file.',
    );
  }
  return <String, Object?>{
    'targetHz': LivePitchSignalProcessor.rollingMedian(voicedFrequencies),
    'voicedSampleCount': voicedFrequencies.length,
  };
}

class _NoOpResonanceAnalyzer implements ResonanceAnalyzer {
  const _NoOpResonanceAnalyzer();

  @override
  ResonanceFeedback analyzeLiveFrame(
    Uint8List pcmBytes, {
    required int sampleRate,
    required PitchTrainingMode mode,
    required bool isVoiced,
    required double? trackedPitchHz,
    required double pitchConfidence,
    required double rmsDbfs,
    required int timestampMs,
  }) {
    return ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: timestampMs,
    );
  }

  @override
  SessionResonanceAnalysis analyzeTrackedAudio({
    required Iterable<PitchSample> samples,
    required PitchTrainingMode mode,
  }) {
    return const SessionResonanceAnalysis(
      dominantState: ResonanceState.insufficientSignal,
      balancedTrackedPercent: 0,
      averageConfidence: 0,
    );
  }
}

class _PcmPitchProcessor {
  _PcmPitchProcessor({
    required this.config,
    required ResonanceAnalyzer Function() resonanceAnalyzerFactory,
    int sampleRate = _defaultSampleRate,
    int channelCount = _defaultChannelCount,
  }) : _detector = PitchDetector(
         audioSampleRate: sampleRate.toDouble(),
         bufferSize: config.windowSize,
       ),
       _sampleRate = sampleRate,
       _windowBytes = config.windowSize * 2,
       _hopBytes = config.hopSize * 2,
       _hopDurationMs = (config.hopSize / sampleRate * 1000).round(),
       _resonanceAnalyzerFactory = resonanceAnalyzerFactory,
       _resonanceAnalyzer = resonanceAnalyzerFactory();

  final PitchTrackingConfig config;
  final PitchDetector _detector;
  final int _sampleRate;
  final int _windowBytes;
  final int _hopBytes;
  final int _hopDurationMs;
  final ResonanceAnalyzer Function() _resonanceAnalyzerFactory;
  late ResonanceAnalyzer _resonanceAnalyzer;

  LivePitchSignalProcessor? _signalProcessor;
  final BytesBuilder _pendingBytes = BytesBuilder(copy: false);
  int _timestampMs = 0;

  void reset({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) {
    _signalProcessor = LivePitchSignalProcessor(
      target: target,
      toleranceHz: toleranceHz,
      trainingMode: trainingMode,
      smoothingWindowMs: smoothingWindowMs,
      config: config,
    );
    _resonanceAnalyzer = _resonanceAnalyzerFactory();
    _pendingBytes.clear();
    _timestampMs = 0;
  }

  Future<List<PitchSample>> processBytes(Uint8List chunk) async {
    _pendingBytes.add(chunk);
    return _consumePendingBytes();
  }

  Future<List<PitchSample>> processAllBytes(Uint8List pcmBytes) async {
    _pendingBytes.add(pcmBytes);
    return _consumePendingBytes();
  }

  Future<List<PitchSample>> _consumePendingBytes() async {
    final pending = _pendingBytes.takeBytes();
    if (pending.length < _windowBytes) {
      _pendingBytes.add(pending);
      return const [];
    }

    final samples = <PitchSample>[];
    var offset = 0;
    while (pending.length - offset >= _windowBytes) {
      final frameBytes = Uint8List.sublistView(
        pending,
        offset,
        offset + _windowBytes,
      );
      _timestampMs += _hopDurationMs;
      final rmsDbfs = _calculateRmsDbfs(frameBytes);
      final pitchResult = await _detector.getPitchFromIntBuffer(frameBytes);
      final pitchSample = _signalProcessor!.process(
        DetectedPitchFrame(
          timestampMs: _timestampMs,
          rawFrequencyHz: pitchResult.pitched
              ? pitchResult.pitch.toDouble()
              : null,
          probability: pitchResult.probability.toDouble(),
          rmsDbfs: rmsDbfs,
          isPitched: pitchResult.pitched,
        ),
      );
      samples.add(
        pitchSample.copyWith(
          resonanceFeedback: _resonanceAnalyzer.analyzeLiveFrame(
            frameBytes,
            sampleRate: _sampleRate,
            mode: _signalProcessor!.trainingMode,
            isVoiced: pitchSample.isVoiced,
            trackedPitchHz: pitchSample.frequencyHz,
            pitchConfidence: pitchSample.confidence,
            rmsDbfs: pitchSample.rmsDbfs,
            timestampMs: pitchSample.timestampMs,
          ),
        ),
      );
      offset += _hopBytes;
    }

    if (offset < pending.length) {
      _pendingBytes.add(Uint8List.sublistView(pending, offset));
    }
    return samples;
  }

  double _calculateRmsDbfs(Uint8List bytes) {
    final data = ByteData.sublistView(bytes);
    var sumSquares = 0.0;
    for (var offset = 0; offset < bytes.length; offset += 2) {
      final value = data.getInt16(offset, Endian.little) / 32768.0;
      sumSquares += value * value;
    }
    final mean = sumSquares / (bytes.length / 2);
    final rms = math.sqrt(mean);
    if (rms <= 1e-9) {
      return -120;
    }
    return 20 * (math.log(rms) / math.ln10);
  }
}

class _TrackingMetrics {
  const _TrackingMetrics({
    required this.timeAtTargetMs,
    required this.totalTrackedTimeMs,
  });

  final int timeAtTargetMs;
  final int totalTrackedTimeMs;
}

const _defaultSampleRate = 44100;
const _defaultChannelCount = 1;

const _recordConfig = RecordConfig(
  encoder: AudioEncoder.pcm16bits,
  sampleRate: _defaultSampleRate,
  numChannels: _defaultChannelCount,
  echoCancel: false,
  autoGain: false,
  noiseSuppress: false,
);

Uint8List _encodeWavePcm16({
  required Uint8List pcmBytes,
  required int sampleRate,
  required int channelCount,
}) {
  final byteRate = sampleRate * channelCount * 2;
  final blockAlign = channelCount * 2;
  final fileSize = 44 + pcmBytes.length;
  final bytes = BytesBuilder(copy: false);
  final header = ByteData(44)
    ..setUint32(0, 0x52494646, Endian.big)
    ..setUint32(4, fileSize - 8, Endian.little)
    ..setUint32(8, 0x57415645, Endian.big)
    ..setUint32(12, 0x666d7420, Endian.big)
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little)
    ..setUint16(22, channelCount, Endian.little)
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, byteRate, Endian.little)
    ..setUint16(32, blockAlign, Endian.little)
    ..setUint16(34, 16, Endian.little)
    ..setUint32(36, 0x64617461, Endian.big)
    ..setUint32(40, pcmBytes.length, Endian.little);
  bytes.add(header.buffer.asUint8List());
  bytes.add(pcmBytes);
  return bytes.toBytes();
}

_ParsedWaveFile _parseWaveFile(Uint8List bytes) {
  if (bytes.length < 12) {
    throw UnsupportedError('Only WAV audio files are supported right now.');
  }

  final data = ByteData.sublistView(bytes);
  final riffTag = String.fromCharCodes(bytes.sublist(0, 4));
  final waveTag = String.fromCharCodes(bytes.sublist(8, 12));
  if (riffTag != 'RIFF' || waveTag != 'WAVE') {
    throw UnsupportedError('Only WAV audio files are supported right now.');
  }
  if (bytes.length < 44) {
    throw const FormatException('The selected file is not a valid WAV file.');
  }

  var offset = 12;
  int? audioFormat;
  int? channelCount;
  int? sampleRate;
  int? bitsPerSample;
  Uint8List? pcmBytes;

  while (offset + 8 <= bytes.length) {
    final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
    final chunkSize = data.getUint32(offset + 4, Endian.little);
    final chunkDataStart = offset + 8;
    final chunkDataEnd = chunkDataStart + chunkSize;
    if (chunkDataEnd > bytes.length) {
      break;
    }

    if (chunkId == 'fmt ') {
      audioFormat = data.getUint16(chunkDataStart, Endian.little);
      channelCount = data.getUint16(chunkDataStart + 2, Endian.little);
      sampleRate = data.getUint32(chunkDataStart + 4, Endian.little);
      bitsPerSample = data.getUint16(chunkDataStart + 14, Endian.little);
    } else if (chunkId == 'data') {
      pcmBytes = Uint8List.sublistView(bytes, chunkDataStart, chunkDataEnd);
    }

    offset = chunkDataEnd + (chunkSize.isOdd ? 1 : 0);
  }

  if (audioFormat != 1 ||
      bitsPerSample != 16 ||
      sampleRate == null ||
      pcmBytes == null) {
    throw UnsupportedError(
      'Only uncompressed 16-bit PCM WAV files are supported right now.',
    );
  }

  final monoPcm = channelCount == 1
      ? pcmBytes
      : _downmixPcm16ToMono(
          pcmBytes: pcmBytes,
          channelCount: channelCount ?? 1,
        );
  return _ParsedWaveFile(sampleRate: sampleRate, monoPcm16Bytes: monoPcm);
}

bool _looksLikeWaveFile(Uint8List bytes) {
  if (bytes.length < 12) {
    return false;
  }
  final riffTag = String.fromCharCodes(bytes.sublist(0, 4));
  final waveTag = String.fromCharCodes(bytes.sublist(8, 12));
  return riffTag == 'RIFF' && waveTag == 'WAVE';
}

String? _audioFormatHintFromPath(String filePath) {
  final normalized = filePath.toLowerCase();
  final dotIndex = normalized.lastIndexOf('.');
  if (dotIndex < 0 || dotIndex == normalized.length - 1) {
    return null;
  }
  final extension = normalized.substring(dotIndex + 1);
  const supported = {
    'wav',
    'm4a',
    'aac',
    'mp3',
    'flac',
    'ogg',
    'opus',
    'mp4',
    'caf',
  };
  return supported.contains(extension) ? extension : null;
}

const _supportedImportFormatsMessage =
    'Supported imports are WAV, M4A, AAC, MP3, FLAC, OGG, OPUS, MP4, and CAF.';

Uint8List _downmixPcm16ToMono({
  required Uint8List pcmBytes,
  required int channelCount,
}) {
  final input = ByteData.sublistView(pcmBytes);
  final frameCount = pcmBytes.length ~/ (channelCount * 2);
  final output = ByteData(frameCount * 2);

  for (var frame = 0; frame < frameCount; frame++) {
    var sum = 0;
    for (var channel = 0; channel < channelCount; channel++) {
      final sampleOffset = (frame * channelCount * 2) + (channel * 2);
      sum += input.getInt16(sampleOffset, Endian.little);
    }
    final averaged = (sum / channelCount).round().clamp(-32768, 32767);
    output.setInt16(frame * 2, averaged, Endian.little);
  }

  return output.buffer.asUint8List();
}

class _ParsedWaveFile {
  const _ParsedWaveFile({
    required this.sampleRate,
    required this.monoPcm16Bytes,
  });

  final int sampleRate;
  final Uint8List monoPcm16Bytes;
}
