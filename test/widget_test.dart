import 'package:flutter_test/flutter_test.dart';
import 'package:raksa_vault/main.dart';

void main() {
  testWidgets('Raksa Vault smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RaksaVaultApp());
    await tester.pumpAndSettle(); // Wait for animations if any

    // Verify that our app shows the welcome screen text.
    expect(find.text('Welcome to Raksa Vault'), findsOneWidget);
  });
}
