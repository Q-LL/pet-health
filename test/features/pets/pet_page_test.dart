import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/onboarding/application/onboarding_service.dart';
import 'package:pet_health/features/onboarding/domain/onboarding_draft.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/pets/presentation/pet_edit_page.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  final monday = DateTime(2026, 10, 26, 9);
  late AppHarness app;
  late String petId;

  setUp(() => app = AppHarness(now: monday));
  tearDown(() => app.close());

  Future<void> openPet(WidgetTester tester) async {
    await app.seed(tester, () async {
      await PreferencesRepository(app.db).setLanguage(AppLanguage.zh);
      final pet =
          await OnboardingService(
            app.db,
            PetsRepository(app.db, clock: () => monday),
            PlansRepository(app.db, clock: () => monday),
          ).finish(
            OnboardingDraft(
              name: 'Lucky',
              sex: PetSex.male,
              breedCode: 'golden_retriever',
              birthDate: DateTime(2022, 5, 1),
              birthPrecision: BirthPrecision.month,
              homeDate: DateTime(2025, 6, 14),
              mealAmount: 2,
              mealUnit: PortionUnit.scoop,
              mealsPerDay: 2,
              bowlMl: 750,
              parasites: const {
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
    await tester.tap(find.text('Lucky').last);
    await app.settle(tester);
  }

  Future<List<dynamic>> plans(WidgetTester tester) async => (await app.seed(
    tester,
    () => PlansRepository(app.db, clock: () => monday).statusesFor(petId),
  ))!;

  testWidgets('资料、习惯预设和驱虫方式', (tester) async {
    await openPet(tester);

    expect(find.text('金毛寻回犬 · 大型双层毛'), findsOneWidget);
    expect(find.text('公'), findsOneWidget);
    expect(find.text('4 岁 5 个月'), findsOneWidget);
    expect(find.text('2025-06-14 到家'), findsOneWidget);
    expect(find.text('还没称过'), findsOneWidget);
    expect(find.text('2 勺'), findsOneWidget);
    expect(find.text('750 ml'), findsOneWidget);
    expect(find.text('饮食、饮水、排泄、梳毛'), findsOneWidget);
    expect(find.text('按时用药 · 每月'), findsOneWidget);
    expect(find.text('先不设置'), findsNWidgets(2));

    await app.unmount(tester);
  });

  testWidgets('记一次体重', (tester) async {
    await openPet(tester);

    await tester.tap(find.text('还没称过'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '31.2');
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    expect(find.text('31.2 kg'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('首页显示里加上体重', (tester) async {
    await openPet(tester);

    await app.scrollTo(tester, find.text('饮食、饮水、排泄、梳毛'));
    await tester.tap(find.text('饮食、饮水、排泄、梳毛'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('体重').last);
    await tester.tap(find.text('体重').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    expect(find.text('饮食、饮水、排泄、梳毛、体重'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('体内寄生虫改成定期检查', (tester) async {
    await openPet(tester);

    await app.scrollTo(tester, find.text('按时用药 · 每月'));
    await tester.tap(find.text('按时用药 · 每月'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('定期检查').at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('定期检查').at(1));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    expect(find.text('定期检查 · 每 3 个月'), findsOneWidget);
    final saved = await plans(tester);
    expect(
      saved.where(
        (s) =>
            s.plan.entryType == EntryType.vetTest &&
            s.plan.entryKind == 'fecal',
      ),
      hasLength(1),
    );
    // 心丝虫没改，计划还在。
    expect(saved.where((s) => s.plan.entryKind == 'heartworm'), hasLength(1));

    await app.unmount(tester);
  });

  testWidgets('改品种后可以重新生成默认计划', (tester) async {
    await openPet(tester);

    await tester.tap(find.text('编辑资料'));
    await tester.pumpAndSettle();
    final search = find.widgetWithText(TextField, '搜索品种');
    await app.scrollTo(tester, search, within: find.byType(PetEditPage));
    await tester.enterText(search, '贵宾');
    await tester.pumpAndSettle();
    await app.scrollTo(
      tester,
      find.text('贵宾（泰迪）'),
      within: find.byType(PetEditPage),
    );
    await tester.tap(find.text('贵宾（泰迪）'));
    await tester.pumpAndSettle();
    await app.scrollTo(
      tester,
      find.text('保存'),
      within: find.byType(PetEditPage),
    );
    await tester.tap(find.text('保存'));
    await app.settle(tester);
    expect(find.textContaining('品种变了'), findsOneWidget);
    await tester.tap(find.text('重新生成'));
    await app.settle(tester);

    expect(find.text('贵宾（泰迪） · 卷毛少掉毛'), findsOneWidget);
    final saved = await plans(tester);
    expect(
      saved.where((s) => s.plan.entryType == EntryType.grooming),
      hasLength(1),
    );

    await app.unmount(tester);
  });

  testWidgets('添加第二只狗狗后选中它', (tester) async {
    await openPet(tester);

    await tester.tap(find.text('添加一只狗狗'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('添加一只狗狗').last);
    await app.settle(tester);
    expect(find.text('先认识一下你的狗狗'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Mochi');
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('下一步'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('完成'));
    await app.settle(tester);

    expect(find.text('Mochi 今天好呀'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('设置里切换到英文', (tester) async {
    await openPet(tester);

    await tester.tap(find.byTooltip('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await app.settle(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Unit system'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('删除最后一只狗狗后回到引导页', (tester) async {
    await openPet(tester);

    await tester.tap(find.text('编辑资料'));
    await tester.pumpAndSettle();
    await app.scrollTo(
      tester,
      find.text('删除档案'),
      within: find.byType(PetEditPage),
    );
    await tester.tap(find.text('删除档案'));
    await tester.pumpAndSettle();
    expect(find.textContaining('无法恢复'), findsOneWidget);
    await tester.tap(find.text('删除'));
    await app.settle(tester);

    expect(find.text('先认识一下你的狗狗'), findsOneWidget);

    await app.unmount(tester);
  });
}
