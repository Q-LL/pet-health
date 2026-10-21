import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/design/design.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  late AppHarness app;

  setUp(() => app = AppHarness());
  tearDown(() => app.close());

  testWidgets('没有狗狗时进入引导；只填名字，一路跳过也能完成', (tester) async {
    await app.seed(
      tester,
      () => PreferencesRepository(app.db).setLanguage(AppLanguage.zh),
    );
    await app.pump(tester);

    expect(find.text('先认识一下你的狗狗'), findsOneWidget);
    expect(find.text('1 / 5'), findsOneWidget);

    // 名字必填。
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.text('先填一个名字吧。'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Lucky');
    await tester.tap(find.text('母'));

    await tester.pumpAndSettle();
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.text('Lucky 是什么品种？'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '金毛');
    await tester.pumpAndSettle();
    await tester.tap(find.text('金毛寻回犬'));
    await tester.pumpAndSettle();
    expect(find.textContaining('大型双层毛'), findsOneWidget);
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();

    // 日子和日常习惯都跳过。
    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();
    expect(find.text('日常习惯'), findsOneWidget);
    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();

    expect(find.text('驱虫怎么安排？'), findsOneWidget);
    // 心丝虫选按时用药，默认每月。
    await tester.tap(find.text('按时用药').first);
    await tester.pumpAndSettle();
    expect(find.text('开始预防前，医生通常会先做一次心丝虫检测。'), findsOneWidget);

    await tester.tap(find.text('完成'));
    await app.settle(tester);

    // 建好后到了今天页，底栏显示名字。
    expect(find.text('先认识一下你的狗狗'), findsNothing);
    expect(find.text('Lucky'), findsWidgets);
    expect(find.byType(CapsuleNavBar), findsOneWidget);

    final saved = (await app.seed(
      tester,
      () => PetsRepository(app.db).getAll(),
    ))!;
    expect(saved.single.name, 'Lucky');
    final plans = (await app.seed(
      tester,
      () => PlansRepository(app.db).statusesFor(saved.single.id),
    ))!;
    expect(
      plans.where(
        (s) =>
            s.plan.entryType == EntryType.parasitePrevention &&
            s.plan.entryKind == 'heartworm',
      ),
      hasLength(1),
    );

    await app.unmount(tester);
  });

  testWidgets('英文引导', (tester) async {
    await app.seed(
      tester,
      () => PreferencesRepository(app.db).setLanguage(AppLanguage.en),
    );
    await app.pump(tester);
    expect(find.text("Let's meet your dog"), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Mochi');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('What breed is Mochi?'), findsOneWidget);
    await app.unmount(tester);
  });
}
