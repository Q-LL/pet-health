import 'package:flutter/material.dart';
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

  testWidgets('opens a care suggestion and enables it explicitly', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PetHealthApp()));
    await tester.pumpAndSettle();

    final carePlans = find.text('护理计划');
    await tester.ensureVisible(carePlans);
    await tester.pumpAndSettle();
    await tester.tap(carePlans);
    await tester.pumpAndSettle();

    expect(find.text('护理中心'), findsAtLeastNWidgets(1));
    expect(find.text('所有建议默认关闭'), findsOneWidget);

    final oralCard = find.ancestor(
      of: find.text('口腔日常护理'),
      matching: find.byType(Card),
    );
    final enableButton = find.descendant(
      of: oralCard,
      matching: find.text('选择开启'),
    );
    await tester.ensureVisible(enableButton);
    await tester.pumpAndSettle();
    await tester.tap(enableButton);
    await tester.pumpAndSettle();
    expect(find.text('确认开启'), findsOneWidget);

    await tester.tap(find.text('确认开启'));
    await tester.pumpAndSettle();
    expect(find.text('已开启 1'), findsOneWidget);
  });
}
