import 'package:flutter_test/flutter_test.dart';

import 'package:shuffle_beat/main.dart';
import 'package:shuffle_beat/services/audio_source_service.dart';

void main() {
  testWidgets('Shuffle Beat home screen loads', (WidgetTester tester) async {
    final audioSource = AudioSourceService();
    await tester.pumpWidget(ShuffleBeatApp(audioSource: audioSource));
    await tester.pumpAndSettle();

    expect(find.textContaining('PART'), findsOneWidget);
  });
}
