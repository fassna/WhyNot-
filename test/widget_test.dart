import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:why_not_useless_olympics/main.dart';
import 'package:why_not_useless_olympics/providers/olympics_provider.dart';

void main() {
  testWidgets('Useless Olympics smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => OlympicsProvider(),
        child: const WhyNotUselessOlympicsApp(),
      ),
    );

    expect(find.textContaining('whyNot!'), findsOneWidget);
  });
}
