import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/core/audio/data/record_audio_services.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';

void main() {
  test('suggests target pitch from wav file', () async {
    final directory = await Directory.systemTemp.createTemp('voxa_import_test');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tone.wav');
    await file.writeAsBytes(_waveForTone(160));

    final service = const DefaultImportedPitchAnalysisService();
    final suggestion = await service.analyzeAudioFile(
      filePath: file.path,
      trainingMode: PitchTrainingMode.sound,
      smoothingWindowMs: 300,
    );

    expect(suggestion.targetHz, closeTo(160, 4));
    expect(suggestion.voicedSampleCount, greaterThan(0));
  });

  test('rejects unsupported file formats', () async {
    final directory = await Directory.systemTemp.createTemp('voxa_import_test');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tone.txt');
    await file.writeAsString('not a wav');

    final service = const DefaultImportedPitchAnalysisService();

    expect(
      () => service.analyzeAudioFile(
        filePath: file.path,
        trainingMode: PitchTrainingMode.speech,
        smoothingWindowMs: 300,
      ),
      throwsA(isA<UnsupportedError>()),
    );
  });
}

Uint8List _waveForTone(double frequencyHz) {
  const sampleRate = 44100;
  const durationMs = 1500;
  final totalSamples = (sampleRate * durationMs / 1000).round();
  final pcm = ByteData(totalSamples * 2);
  for (var index = 0; index < totalSamples; index++) {
    final t = index / sampleRate;
    final sample = (math.sin(2 * math.pi * frequencyHz * t) * 0.7 * 32767)
        .round()
        .clamp(-32768, 32767);
    pcm.setInt16(index * 2, sample, Endian.little);
  }

  final pcmBytes = pcm.buffer.asUint8List();
  final header = ByteData(44)
    ..setUint32(0, 0x52494646, Endian.big)
    ..setUint32(4, 36 + pcmBytes.length, Endian.little)
    ..setUint32(8, 0x57415645, Endian.big)
    ..setUint32(12, 0x666d7420, Endian.big)
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little)
    ..setUint16(22, 1, Endian.little)
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, sampleRate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little)
    ..setUint32(36, 0x64617461, Endian.big)
    ..setUint32(40, pcmBytes.length, Endian.little);

  return Uint8List.fromList([
    ...header.buffer.asUint8List(),
    ...pcmBytes,
  ]);
}
