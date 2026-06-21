import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';

void main() {
  testWidgets('shows the four primary destinations', (tester) async {
    await tester.pumpWidget(const PetHealthApp());
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('宠物'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('今日提醒'), findsOneWidget);
  });
}
