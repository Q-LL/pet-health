import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/pet.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

import '../helpers/app_harness.dart';

void main() {
  late AppHarness app;

  setUp(() => app = AppHarness());
  tearDown(() => app.close());

  Future<void> setLanguage(WidgetTester tester, AppLanguage language) => app
      .seed(tester, () => PreferencesRepository(app.db).setLanguage(language));

  Future<void> addPet(WidgetTester tester, String name) => app.seed(
    tester,
    () => PetsRepository(app.db).create(PetDraft(name: name)),
  );

  testWidgets('中文界面：底栏四个页面加中间的记录按钮，可以切换', (tester) async {
    await addPet(tester, '团子');
    await setLanguage(tester, AppLanguage.zh);
    await app.pump(tester);

    for (final label in ['今天', '时间线', '计划', '团子']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.bySemanticsLabel('记录'), findsOneWidget);

    await tester.tap(find.text('计划'));
    await tester.pumpAndSettle();
    expect(find.text('团子 的计划'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('英文界面，底栏显示狗狗的名字', (tester) async {
    await addPet(tester, 'Lucky');
    await setLanguage(tester, AppLanguage.en);
    await app.pump(tester);

    for (final label in ['Today', 'Timeline', 'Plans', 'Lucky']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('My dog'), findsNothing);
    expect(find.bySemanticsLabel('Log something'), findsOneWidget);

    await app.unmount(tester);
  });

  testWidgets('切换语言后界面立即更新', (tester) async {
    await addPet(tester, 'Lucky');
    await setLanguage(tester, AppLanguage.en);
    await app.pump(tester);
    expect(find.text('Today'), findsWidgets);

    await setLanguage(tester, AppLanguage.zh);
    await app.settle(tester);
    expect(find.text('今天'), findsWidgets);
    expect(find.text('Today'), findsNothing);

    await app.unmount(tester);
  });
}
