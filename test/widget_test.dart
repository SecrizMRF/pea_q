import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pea_q/app/app.dart';
import 'package:pea_q/providers/leaderboard_provider.dart';
import 'package:pea_q/providers/quiz_provider.dart';
import 'package:pea_q/providers/theme_provider.dart';

void main() {
  testWidgets('PeaQook app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => QuizProvider()),
          ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ],
        child: const PixelQuizApp(),
      ),
    );

    expect(find.text('PeaQook'), findsOneWidget);

    // Fast-forward splash timer to avoid pending timer error
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();
  });
}
