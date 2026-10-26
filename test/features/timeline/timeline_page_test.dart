import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/pet.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../../helpers/app_harness.dart';

void main() {
  final monday = DateTime(2026, 10, 26, 9);
  late AppHarness app;

  setUp(() => app = AppHarness(now: monday));
  tearDown(() => app.close());

  /// 建一只狗，写入 [drafts] 返回的记录，打开时间线。
  Future<void> start(
    WidgetTester tester,
    List<EntryDraft> Function(String petId) drafts,
  ) async {
    await app.seed(tester, () async {
      await PreferencesRepository(app.db).setLanguage(AppLanguage.zh);
      final pet = await PetsRepository(
        app.db,
        clock: () => monday,
      ).create(const PetDraft(name: 'Lucky'));
      final entries = EntriesRepository(app.db, clock: () => monday);
      for (final draft in drafts(pet.id)) {
        await entries.create(draft);
      }
    });
    await app.pump(tester);
    await tester.tap(find.text('时间线'));
    await app.settle(tester);
  }

  testWidgets('按天分组；筛选到健康，点开体重删掉', (tester) async {
    await start(
      tester,
      (petId) => [
        EntryDraft(
          petId: petId,
          type: EntryType.meal,
          occurredAt: DateTime(2026, 10, 26, 8),
          details: const MealDetails(appetite: Appetite.finished),
        ),
        EntryDraft(
          petId: petId,
          type: EntryType.potty,
          occurredAt: DateTime(2026, 10, 25, 19),
          details: const PottyDetails(
            kind: PottyKind.poop,
            stool: StoolStatus.normal,
          ),
        ),
        EntryDraft(
          petId: petId,
          type: EntryType.weight,
          occurredAt: DateTime(2026, 10, 20, 10),
          amount: 6.5,
          note: '体检前称的',
        ),
      ],
    );

    expect(find.text('Lucky 的时间线'), findsOneWidget);
    expect(find.text('今天'), findsWidgets);
    expect(find.text('昨天'), findsOneWidget);
    expect(find.text('10月20日周二'), findsOneWidget);
    expect(find.text('饮食 · 吃完了'), findsOneWidget);
    expect(find.text('便便 · 正常'), findsOneWidget);
    expect(find.text('体检前称的'), findsOneWidget);

    await tester.tap(find.text('健康'));
    await app.settle(tester);
    expect(find.text('饮食 · 吃完了'), findsNothing);
    expect(find.text('体重 · 6.5 kg'), findsOneWidget);

    await tester.tap(find.text('体重 · 6.5 kg'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除这条记录'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await app.settle(tester);
    expect(find.text('这一类还没有记录。'), findsOneWidget);

    await tester.tap(find.text('全部'));
    await app.settle(tester);
    expect(find.text('饮食 · 吃完了'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('记录很多时，滑到底部再读更早的', (tester) async {
    // 每 2 小时一条，共 130 条，最早的在 10 月 15 日。
    await start(
      tester,
      (petId) => [
        for (var i = 0; i < 130; i++)
          EntryDraft(
            petId: petId,
            type: EntryType.water,
            occurredAt: DateTime(2026, 10, 26, 8 - 2 * i),
          ),
      ],
    );
    expect(find.text('10月15日周四'), findsNothing);

    await app.scrollTo(tester, find.text('10月15日周四'));
    expect(find.text('10月15日周四'), findsOneWidget);

    await app.unmount(tester);
  });
}
