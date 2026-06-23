import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  Widget testApp() => ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(database)],
    child: const PetHealthApp(),
  );

  Future<void> disposeTestApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('shows the four primary destinations', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('狗狗'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('毛健康'), findsAtLeastNWidgets(1));
    expect(find.text('快速记录'), findsOneWidget);
    expect(find.text('日常护理'), findsOneWidget);
    expect(find.text('一键开始遛狗'), findsOneWidget);
    await disposeTestApp(tester);
  });

  testWidgets('starts an active walk from the care card', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final startWalk = find.text('一键开始遛狗');
    await tester.ensureVisible(startWalk);
    await tester.pumpAndSettle();
    await tester.tap(startWalk);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('正在遛狗'), findsOneWidget);
    expect(find.text('结束遛狗'), findsAtLeastNWidgets(1));
    await disposeTestApp(tester);
  });

  testWidgets('opens a care suggestion and enables it explicitly', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
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
    await disposeTestApp(tester);
  });

  testWidgets('creates the first local pet profile', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('狗狗'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建狗狗档案'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, '名字 *'), '团子');
    await tester.enterText(find.widgetWithText(TextFormField, '类型'), '小型犬');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('团子'), findsOneWidget);
    expect(find.text('当前'), findsOneWidget);
    await disposeTestApp(tester);
  });
}
