import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('主畫面顯示 Rental Manager', (tester) async {
    await pumpApp(tester);

    expect(find.text('Rental Manager'), findsOneWidget);
  });

  testWidgets('內建文字是繁體中文', (tester) async {
    await pumpApp(tester);

    final localizations = MaterialLocalizations.of(
      tester.element(find.byType(Scaffold)),
    );
    expect(localizations.okButtonLabel, '確定');
    expect(localizations.backButtonTooltip, '返回');
  });
}
