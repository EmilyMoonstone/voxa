import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/record/presentation/record_summary_card.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('renders the saved record summary metrics', (tester) async {
    await pumpLocalizedScope(
      tester,
      child: const RecordSummaryCard(
        averagePitchHz: 168.2,
        targetLabel: '185 Hz ± 10 Hz',
        timeAtTargetPercent: 72,
      ),
    );

    expect(find.text('Average: 168 Hz'), findsOneWidget);
    expect(find.text('Target: 185 Hz ± 10 Hz'), findsOneWidget);
    expect(find.text('At target: 72%'), findsOneWidget);
  });
}
