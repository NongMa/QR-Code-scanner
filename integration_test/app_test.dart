import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quick_scanner/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('navigate to scanner, toggle torch, and navigate to history',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to the scanner screen.
      await tester.tap(find.byIcon(Icons.qr_code_scanner));
      await tester.pumpAndSettle();

      // Verify that the scanner screen is open.
      expect(find.text('Scan QR Code'), findsOneWidget);

      // Tap the flashlight button to turn it on.
      await tester.tap(find.byIcon(Icons.flash_off));
      await tester.pumpAndSettle();

      // Verify that the flashlight is on.
      expect(find.byIcon(Icons.flash_on), findsOneWidget);

      // Tap the flashlight button to turn it off.
      await tester.tap(find.byIcon(Icons.flash_on));
      await tester.pumpAndSettle();

      // Verify that the flashlight is off.
      expect(find.byIcon(Icons.flash_off), findsOneWidget);

      // Go back to the main screen.
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Navigate to the history screen.
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Verify that the history screen is open.
      expect(find.text('Scan History'), findsOneWidget);
    });
  });
}
