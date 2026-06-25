import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';
import 'package:pet_health/app/router.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';
import 'package:pet_health/features/care/data/care_repository.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/reminders/data/reminder_repository.dart';
import 'package:pet_health/features/reminders/domain/reminder_models.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    appRouter.go('/home');
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

  testWidgets('shows the five primary destinations', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('记录'), findsOneWidget);
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
    expect(find.text('已开启 0'), findsOneWidget);

    await tester.tap(find.text('建议 10'));
    await tester.pumpAndSettle();

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

    final enabledSegment = find.text('已开启 1');
    await tester.ensureVisible(enabledSegment);
    await tester.pumpAndSettle();
    await tester.tap(enabledSegment);
    await tester.pumpAndSettle();
    final completeButton = find.text('完成').first;
    await tester.ensureVisible(completeButton);
    await tester.pumpAndSettle();
    await tester.tap(completeButton);
    await tester.pumpAndSettle();
    expect(find.text('新增护理记录'), findsOneWidget);
    final saveCareRecord = find.text('保存护理记录');
    await tester.ensureVisible(saveCareRecord);
    await tester.pumpAndSettle();
    await tester.tap(saveCareRecord);
    await tester.pumpAndSettle();
    expect(find.text('已记录完成'), findsOneWidget);

    final historySegment = find.text('记录').first;
    await tester.ensureVisible(historySegment);
    await tester.pumpAndSettle();
    await tester.tap(historySegment);
    await tester.pumpAndSettle();
    expect(find.textContaining('口腔日常护理 · 已完成'), findsOneWidget);
    await disposeTestApp(tester);
  });

  testWidgets('shows today reminders and completes one', (tester) async {
    final petId = await CareRepository(database).ensureDefaultPet();
    await PetRepository(database).selectPet(petId);
    final now = DateTime.now();
    await ReminderRepository(database).create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '喂益生菌',
        scheduledAt: DateTime(now.year, now.month, now.day, 12),
      ),
    );

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    for (var i = 0; i < 5 && find.text('喂益生菌').evaluate().isEmpty; i++) {
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
    }
    expect(find.text('喂益生菌'), findsOneWidget);
    final completeReminder = find.byTooltip('完成').first;
    await tester.ensureVisible(completeReminder);
    await tester.pumpAndSettle();
    await tester.tap(completeReminder);
    await tester.pumpAndSettle();

    expect(find.text('已完成提醒'), findsOneWidget);
    expect(find.text('喂益生菌'), findsNothing);
    expect(find.text('今天轻轻松松'), findsOneWidget);
    await disposeTestApp(tester);
  });

  testWidgets('creates the first local pet profile', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('狗狗'));
    await tester.pumpAndSettle();
    final createProfile = find.text('创建狗狗档案');
    await tester.ensureVisible(createProfile);
    await tester.pumpAndSettle();
    await tester.tap(createProfile);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, '名字 *'), '团子');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('团子'), findsOneWidget);
    expect(find.text('当前'), findsOneWidget);
    await disposeTestApp(tester);
  });
}
