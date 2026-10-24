import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/onboarding/application/onboarding_service.dart';
import 'package:pet_health/features/onboarding/domain/onboarding_draft.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  // 周一：金毛默认每周一、三、五、日梳毛，今天要梳；耳朵检查在周六。
  final monday = DateTime(2026, 10, 26, 9);
  late AppHarness app;
  late String petId;

  setUp(() => app = AppHarness(now: monday));
  tearDown(() => app.close());

  Future<void> openPlans(WidgetTester tester) async {
    await app.seed(tester, () async {
      await PreferencesRepository(app.db).setLanguage(AppLanguage.zh);
      final pet =
          await OnboardingService(
            app.db,
            PetsRepository(app.db, clock: () => monday),
            PlansRepository(app.db, clock: () => monday),
          ).finish(
            const OnboardingDraft(
              name: 'Lucky',
              breedCode: 'golden_retriever',
              parasites: {
                ParasiteCoverage.heartworm: ParasiteChoice(
                  ParasiteMode.scheduled,
                  EveryNMonths(1),
                ),
              },
            ),
          );
      petId = pet.id;
    });
    await app.pump(tester);
    await tester.tap(find.text('计划'));
    await app.settle(tester);
  }

  Finder row(String name) =>
      find.ancestor(of: find.text(name), matching: find.byType(InkWell)).first;

  Future<List<dynamic>> plans(WidgetTester tester) async => (await app.seed(
    tester,
    () => PlansRepository(app.db, clock: () => monday).statusesFor(petId),
  ))!;

  testWidgets('按今天、快到了、还没开始分组', (tester) async {
    await openPlans(tester);

    expect(find.text('Lucky 的计划'), findsOneWidget);
    expect(find.text('快到了'), findsOneWidget);
    expect(find.text('还没开始'), findsOneWidget);
    expect(find.text('每周一、三、五、日'), findsOneWidget);
    // 耳朵检查周六到期。
    expect(find.text('10月31日'), findsOneWidget);
    expect(find.text('每月 · 记一次就开始算'), findsOneWidget);
    expect(find.text('心丝虫预防'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('还没开始的计划记一次后，转到快到了', (tester) async {
    await openPlans(tester);

    final bath = row('洗澡');
    await tester.tap(find.descendant(of: bath, matching: find.text('记一次')));
    await app.settle(tester);
    expect(find.textContaining('已记下 · 洗澡'), findsOneWidget);
    // 金毛每 6 周洗一次澡。
    expect(find.text('12月7日'), findsOneWidget);
    expect(find.textContaining('上次 10月26日'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('修改排期：从每周几改成隔几天', (tester) async {
    await openPlans(tester);

    await tester.tap(row('梳毛'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('隔几天'));
    await tester.pumpAndSettle();
    expect(find.text('7 天'), findsOneWidget);
    await tester.tap(find.byTooltip('增加'));
    await tester.pumpAndSettle();
    expect(find.text('每 8 天'), findsOneWidget);
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    final saved = await plans(tester);
    final brushing = saved.singleWhere(
      (s) => s.plan.entryType == EntryType.brushing,
    );
    expect(brushing.plan.schedule, const EveryNDays(8));

    await app.unmount(tester);
  });

  testWidgets('暂停后放到已暂停分组', (tester) async {
    await openPlans(tester);

    await tester.tap(row('耳朵检查'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('暂停这个计划'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    expect(find.text('已暂停'), findsOneWidget);
    expect(find.text('10月31日'), findsNothing);

    await app.unmount(tester);
  });

  testWidgets('删除要确认，确认后计划消失', (tester) async {
    await openPlans(tester);

    await tester.tap(row('体重'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除计划'));
    await tester.pumpAndSettle();
    expect(find.text('删除「体重」？之前的记录会保留。'), findsOneWidget);
    await tester.tap(find.text('删除'));
    await app.settle(tester);

    expect(find.text('体重'), findsNothing);
    final saved = await plans(tester);
    expect(saved.where((s) => s.plan.entryType == EntryType.weight), isEmpty);

    await app.unmount(tester);
  });

  testWidgets('新建：其他护理里的剪指甲，每 2 周', (tester) async {
    await openPlans(tester);

    await tester.tap(find.text('新建'));
    await tester.pumpAndSettle();
    expect(find.text('新建计划'), findsOneWidget);
    await tester.tap(find.text('其他护理'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('剪指甲'));
    await tester.ensureVisible(find.text('隔几天'));
    await tester.tap(find.text('隔几天'));
    await tester.pumpAndSettle();
    // 新建时面板比较长，需要先滑到下面。
    await tester.ensureVisible(find.byTooltip('增加'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byTooltip('增加'));
    }
    await tester.pumpAndSettle();
    expect(find.text('每 2 周'), findsOneWidget);
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    expect(find.text('剪指甲'), findsOneWidget);
    final saved = await plans(tester);
    final nails = saved.singleWhere((s) => s.plan.entryKind == 'nails');
    expect(nails.plan.schedule, const EveryNDays(14));

    await app.unmount(tester);
  });
}
