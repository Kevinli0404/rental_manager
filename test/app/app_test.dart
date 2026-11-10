import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('主畫面顯示 Rental Manager', (tester) async {
    await pumpApp(tester);

    expect(find.text('Rental Manager'), findsOneWidget);
  });
}
