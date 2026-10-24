import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/onboarding/application/onboarding_service.dart';
import 'package:pet_health/features/onboarding/domain/onboarding_draft.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  // 2026-10-26 是周一：金毛默认每周一、三、五、日梳毛，今天要梳。
  final monday = DateTime(2026, 10, 26, 9);
  late AppHarness app;
  late String petId;

  setUp(() => app = AppHarness(now: monday));
  tearDown(() => app.close());

  Future<void> start(WidgetTester tester) async {
    await app.seed(tester, () async {
      await PreferencesRepository(app.db).setLanguage(AppLanguage.zh);
      final pets = PetsRepository(app.db, clock: () => monday);
      final pet =
          await OnboardingService(
            app.db,
            pets,
            PlansRepository(app.db, clock: () => monday),
          ).finish(
            OnboardingDraft(
              name: 'Lucky',
              breedCode: 'golden_retriever',
              homeDate: DateTime(2025, 6, 14),
              mealAmount: 2,
              mealUnit: PortionUnit.scoop,
              mealsPerDay: 2,
              bowlMl: 750,
            ),
          );
      petId = pet.id;
    });
    await app.pump(tester);
  }

  Future<List<dynamic>> entries(WidgetTester tester) async => (await app.seed(
    tester,
    () => EntriesRepository(app.db).findForPet(petId),
  ))!;

  testWidgets('问候、在一起的天数、一键记录按钮和今天要做的事', (tester) async {
    await start(tester);

    expect(find.text('Lucky 今天好呀'), findsOneWidget);
    expect(find.text('在一起的第 500 天'), findsOneWidget);
    for (final label in ['饮食', '饮水', '排泄', '梳毛']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.text('0 / 2 餐'), findsOneWidget);
    expect(find.text('今天要做'), findsOneWidget);
    expect(find.text('今天安排了梳毛。'), findsOneWidget);
    expect(find.text('梳毛 · 每周一、三、五、日'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('点一下记录，提示条可以撤销', (tester) async {
    await start(tester);

    await tester.tap(find.text('饮食'));
    await app.settle(tester);
    expect(find.text('已记下'), findsOneWidget);
    expect(find.textContaining('饮食 · 2 勺 · 吃完了'), findsOneWidget);
    expect(find.text('1 / 2 餐'), findsOneWidget);
    expect(await entries(tester), hasLength(1));

    await tester.tap(find.text('撤销'));
    await app.settle(tester);
    expect(find.text('已记下'), findsNothing);
    expect(find.text('0 / 2 餐'), findsOneWidget);
    expect(await entries(tester), isEmpty);

    await app.unmount(tester);
  });

  testWidgets('提示条几秒后自动收起', (tester) async {
    await start(tester);
    await tester.tap(find.text('饮水'));
    await app.settle(tester);
    expect(find.text('已记下'), findsOneWidget);
    expect(find.text('加水 1 次'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('已记下'), findsNothing);

    await app.unmount(tester);
  });

  testWidgets('点"补充"展开面板，改成偏软后保存', (tester) async {
    await start(tester);

    await tester.tap(find.text('排泄'));
    await app.settle(tester);
    expect(find.textContaining('便便 · 正常'), findsOneWidget);

    await tester.tap(find.text('补充'));
    await tester.pumpAndSettle();
    expect(find.text('补充细节'), findsOneWidget);
    expect(find.text('有血或黏液'), findsOneWidget);

    await tester.tap(find.text('偏软'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('完成'));
    await app.settle(tester);
    expect(find.text('补充细节'), findsNothing);

    final saved = await entries(tester);
    expect(
      saved.single.details,
      const PottyDetails(kind: PottyKind.poop, stool: StoolStatus.soft),
    );

    await app.unmount(tester);
  });

  testWidgets('计划卡片：记一次后卡片消失；晚点提醒也会收起', (tester) async {
    await start(tester);
    expect(find.text('今天安排了梳毛。'), findsOneWidget);

    await tester.tap(find.text('记一次'));
    await app.settle(tester);
    expect(find.text('今天安排了梳毛。'), findsNothing);
    expect(find.text('今天没有要做的事。'), findsOneWidget);
    final saved = await entries(tester);
    expect(saved.single.type, EntryType.brushing);
    expect(saved.single.planId, isNotNull);

    await app.unmount(tester);
  });

  testWidgets('晚点提醒', (tester) async {
    await start(tester);
    await tester.tap(find.text('晚点提醒'));
    await app.settle(tester);
    expect(find.text('今天安排了梳毛。'), findsNothing);
    expect(await entries(tester), isEmpty);

    await app.unmount(tester);
  });

  testWidgets('长按打开新建面板，改成尿尿后保存', (tester) async {
    await start(tester);

    await tester.longPress(find.text('排泄'));
    await tester.pumpAndSettle();
    expect(find.text('保存'), findsOneWidget);
    await tester.tap(find.text('尿尿'));
    await tester.pumpAndSettle();
    expect(find.text('颜色异常'), findsOneWidget);
    await tester.tap(find.text('保存'));
    await app.settle(tester);

    final saved = await entries(tester);
    expect(
      saved.single.details,
      const PottyDetails(kind: PottyKind.pee, urine: UrineStatus.normal),
    );

    await app.unmount(tester);
  });

  testWidgets('英文界面', (tester) async {
    await start(tester);
    await app.seed(
      tester,
      () => PreferencesRepository(app.db).setLanguage(AppLanguage.en),
    );
    await app.settle(tester);
    expect(find.text('Hi, Lucky!'), findsOneWidget);
    expect(find.text('Day 500 together'), findsOneWidget);
    expect(find.text('0 of 2'), findsOneWidget);
    expect(find.text("Brushing is on today's list."), findsOneWidget);

    await app.unmount(tester);
  });
}
