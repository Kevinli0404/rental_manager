import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_manager/app/app.dart';
import 'package:rental_manager/app/router.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('點交紀錄不存在時顯示找不到', (tester) async {
    final database = await pumpApp(tester);
    final propertyId = await database.propertiesDao.createProperty(
      name: '中山路公寓',
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RentalManagerApp)),
    );
    container
        .read(routerProvider)
        .go(AppRoutes.inspection(propertyId, '不存在的 id'));
    await tester.pumpAndSettle();

    expect(find.text('找不到這個點交紀錄'), findsOneWidget);
  });
}
