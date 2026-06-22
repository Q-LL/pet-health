import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';

void main() {
  testWidgets('shows the four primary destinations', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PetHealthApp()));
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('宠物'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('毛健康'), findsAtLeastNWidgets(1));
    expect(find.text('快速记录'), findsOneWidget);
    expect(find.text('日常护理'), findsOneWidget);
    expect(find.text('一键开始遛狗'), findsOneWidget);
  });

  testWidgets('starts an active walk from the care card', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PetHealthApp()));
    await tester.pumpAndSettle();

    final startWalk = find.text('一键开始遛狗');
    await tester.ensureVisible(startWalk);
    await tester.pumpAndSettle();
    await tester.tap(startWalk);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('正在遛狗'), findsOneWidget);
    expect(find.text('结束遛狗'), findsAtLeastNWidgets(1));
  });
}
