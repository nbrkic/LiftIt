import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liftit/app.dart';

void main() {
  testWidgets('renders Home tab with Start Workout button', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LiftItApp()));
    await tester.pumpAndSettle();

    expect(find.text('LiftIt'), findsOneWidget);
    expect(find.text('Start Freestyle Workout'), findsOneWidget);
  });
}
