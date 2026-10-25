import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/presentation/entry_sheet.dart';
import 'package:pet_health/features/entries/presentation/record_center.dart';
import 'package:pet_health/features/onboarding/application/onboarding_service.dart';
import 'package:pet_health/features/onboarding/domain/onboarding_draft.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  final monday = DateTime(2026, 10, 26, 9);
  late AppHarness app;
  late String petId;

  setUp(() => app = AppHarness(now: monday));
  tearDown(() => app.close());

  Future<void> start(WidgetTester tester) async {
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
            ),
          );
      petId = pet.id;
    });
    await app.pump(tester);
  }

  Future<List<Entry>> entries(WidgetTester tester) async => (await app.seed(
    tester,
    () => EntriesRepository(app.db).findForPet(petId),
  ))!;

  /// 点中间的 + ，在记录中心里选一项。
  Future<void> pick(WidgetTester tester, String label) async {
    await tester.tap(find.bySemanticsLabel('记录'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(RecordCenter),
        matching: find.text(label),
      ),
    );
    await app.settle(tester);
  }

  Finder inSheet(Finder finder) =>
      find.descendant(of: find.byType(EntrySheet), matching: finder);

  testWidgets('记录中心列出所有类型；在计划页记一次体重，提示条也会出现', (tester) async {
    expect(RecordCenter.types.toSet(), EntryType.values.toSet());
    expect(RecordCenter.types, hasLength(EntryType.values.length));

    await start(tester);
    await tester.tap(find.text('计划'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('记录'));
    await tester.pumpAndSettle();
    expect(find.text('记一笔'), findsOneWidget);
    expect(find.text('预防和其他'), findsOneWidget);
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    expect(find.text('记一笔'), findsNothing);

    await pick(tester, '体重');
    await tester.enterText(inSheet(find.byType(TextField)), '6.5');
    await tester.pump();
    await tester.tap(inSheet(find.text('保存')));
    await app.settle(tester);

    expect(find.text('已记下'), findsOneWidget);
    expect(find.textContaining('体重 · 6.5'), findsOneWidget);
    final saved = await entries(tester);
    expect(saved.single.type, EntryType.weight);
    expect(saved.single.amount, 6.5);

    await app.unmount(tester);
  });

  testWidgets('遛狗：可以补记，也可以现在出发；在遛时再选遛狗就结束', (tester) async {
    await start(tester);

    await pick(tester, '遛狗');
    expect(inSheet(find.text('出发时间')), findsOneWidget);
    await tester.enterText(inSheet(find.byType(TextField)), '45');
    await tester.pump();
    await tester.tap(inSheet(find.text('保存')));
    await app.settle(tester);
    final logged = (await entries(tester)).single;
    expect(logged.durationSec, 45 * 60);

    await pick(tester, '遛狗');
    await tester.tap(inSheet(find.text('现在出发，开始计时')));
    await app.settle(tester);
    expect(find.text('开始遛狗了'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('记录'));
    await tester.pumpAndSettle();
    expect(find.text('遛了 0 分钟'), findsWidgets);
    await tester.tap(
      find.descendant(
        of: find.byType(RecordCenter),
        matching: find.text('遛狗'),
      ),
    );
    await app.settle(tester);
    expect(find.text('遛完了'), findsOneWidget);
    expect(find.text('撤销'), findsNothing);

    // 结束后补充细节，原样保存也不出错。
    await tester.tap(find.text('补充'));
    await tester.pumpAndSettle();
    expect(inSheet(find.text('遛了多久')), findsOneWidget);
    await tester.tap(inSheet(find.text('完成')));
    await app.settle(tester);
    expect(find.byType(EntrySheet), findsNothing);
    final walks = await entries(tester);
    expect(walks, hasLength(2));
    expect(walks.every((walk) => walk.endedAt != null), isTrue);

    await app.unmount(tester);
  });
}
