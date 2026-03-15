import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/core/widgets/pitch_gauge.dart';
import 'package:voxa/features/practice/domain/pitch_sample.dart';

void main() {
  testWidgets('renders low, at-target, high, and unvoiced gauge states', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(600, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Future<void> pumpGauge({
      required double? frequencyHz,
      required PitchStateCategory state,
      required String caption,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PitchGauge(
              frequencyHz: frequencyHz,
              stateCategory: state,
              caption: caption,
            ),
          ),
        ),
      );
    }

    await pumpGauge(
      frequencyHz: 130,
      state: PitchStateCategory.low,
      caption: 'Try a little higher',
    );
    expect(find.text('130 Hz'), findsOneWidget);
    expect(find.text('Try a little higher'), findsOneWidget);

    await pumpGauge(
      frequencyHz: 160,
      state: PitchStateCategory.atTarget,
      caption: 'You are on target',
    );
    expect(find.text('160 Hz'), findsOneWidget);
    expect(find.text('You are on target'), findsOneWidget);

    await pumpGauge(
      frequencyHz: 190,
      state: PitchStateCategory.high,
      caption: 'Try a little lower',
    );
    expect(find.text('190 Hz'), findsOneWidget);
    expect(find.text('Try a little lower'), findsOneWidget);

    await pumpGauge(
      frequencyHz: null,
      state: PitchStateCategory.unvoiced,
      caption: 'Keep speaking naturally',
    );
    expect(find.text('--'), findsOneWidget);
    expect(find.text('Keep speaking naturally'), findsOneWidget);
  });
}
