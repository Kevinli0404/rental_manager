import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';

void main() {
  testWidgets('主畫面顯示 Rental Manager', (tester) async {
    await tester.pumpWidget(const RentalManagerApp());

    expect(find.text('Rental Manager'), findsOneWidget);
  });
}
