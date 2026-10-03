import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/app.dart';
import 'package:pet_health/app/app_shell.dart';
import 'package:pet_health/features/home/presentation/home_sections.dart';
import 'package:pet_health/app/router.dart';
import 'package:pet_health/core/database/app_database.dart';
import 'package:pet_health/core/database/database_provider.dart';
import 'package:pet_health/core/knowledge/knowledge_database.dart';
import 'package:pet_health/core/files/album_asset_service.dart';
import 'package:pet_health/features/memories/data/memory_repository.dart';
import 'package:pet_health/features/care/domain/care_models.dart';
import 'package:pet_health/features/care/presentation/walk_mini_bar.dart';
import 'package:pet_health/features/knowledge/data/knowledge_repository.dart';
import 'package:pet_health/features/care/application/care_controller.dart';
import 'package:pet_health/features/care/data/care_plan_repository.dart';
import 'package:pet_health/features/care/data/care_repository.dart';
import 'package:pet_health/features/care/domain/care_plan_models.dart';
import 'package:pet_health/features/pets/data/pet_repository.dart';
import 'package:pet_health/features/pets/domain/pet_profile.dart';
import 'package:pet_health/features/records/data/health_record_repository.dart';
import 'package:pet_health/features/records/domain/health_record.dart';
import 'package:pet_health/features/reminders/data/reminder_repository.dart';
import 'package:pet_health/features/reminders/domain/reminder_models.dart';

void main() {
  late AppDatabase database;
  late KnowledgeDatabase knowledgeDatabase;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    knowledgeDatabase = KnowledgeDatabase(NativeDatabase.memory());
    appRouter.go('/today');
  });

  tearDown(() async {
    await database.close();
    await knowledgeDatabase.close();
  });

  Widget testApp(WidgetTester tester) {
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        knowledgeDatabaseProvider.overrideWithValue(knowledgeDatabase),
      ],
      child: const PetHealthApp(),
    );
  }

  Future<void> disposeTestApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('shows four tabs around a central record action', (tester) async {
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('今天'), findsAtLeastNWidgets(1));
    expect(find.text('时间线'), findsOneWidget);
    expect(find.text('照护'), findsOneWidget);
    expect(find.text('狗狗'), findsOneWidget);
    expect(find.text('设置'), findsNothing);
    expect(find.byTooltip('新增记录'), findsOneWidget);
    expect(find.text('毛健康'), findsAtLeastNWidgets(1));
    expect(find.text('创建档案'), findsOneWidget);
    expect(find.text('快速记录'), findsNothing);
    expect(find.text('日常护理'), findsNothing);
    await disposeTestApp(tester);
  });

  testWidgets('blocks record creation until a real pet exists', (tester) async {
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('新增记录'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.text('先创建狗狗档案'), findsOneWidget);
    expect(find.text('记录点什么'), findsNothing);
    await tester.tap(find.text('暂不创建'));
    await tester.pumpAndSettle();
    await disposeTestApp(tester);
  });

  testWidgets('opens the record sheet from every tab', (tester) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    for (final tab in ['时间线', '照护', '狗狗']) {
      await tester.tap(
        find.descendant(of: find.byType(AppNavBar), matching: find.text(tab)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('新增记录'));
      await tester.pumpAndSettle();
      expect(find.text('记录点什么'), findsOneWidget, reason: tab);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.text('记录点什么'), findsNothing, reason: tab);
    }
    await disposeTestApp(tester);
  });

  testWidgets('redirects four-tab locations to their new homes', (
    tester,
  ) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    appRouter.go('/home/reminders');
    await tester.pumpAndSettle();
    expect(
      appRouter.routerDelegate.currentConfiguration.uri.toString(),
      '/care?seg=todo',
    );
    expect(find.text('提醒管理'), findsNothing);
    expect(find.text('管理全部提醒'), findsOneWidget);

    appRouter.go('/home/health-dynamics');
    await tester.pumpAndSettle();
    expect(find.text('护理完成率'), findsOneWidget);

    appRouter.go('/calendar/records');
    await tester.pumpAndSettle();
    expect(find.text('历史记录'), findsAtLeastNWidgets(1));
    expect(find.byTooltip('新增记录'), findsNothing);

    appRouter.go('/settings/knowledge');
    await tester.pumpAndSettle();
    expect(find.text('本地知识库'), findsAtLeastNWidgets(1));

    appRouter.go('/pets');
    await tester.pumpAndSettle();
    expect(
      appRouter.routerDelegate.currentConfiguration.uri.toString(),
      '/pet',
    );
    await disposeTestApp(tester);
  });

  testWidgets('shows an honest empty state for memories', (tester) async {
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(of: find.byType(AppNavBar), matching: find.text('时间线')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('爱宠时光'));
    await tester.pumpAndSettle();

    expect(find.text('还没有爱宠时光'), findsOneWidget);
    expect(find.textContaining('iPhone 或 Android'), findsOneWidget);
    expect(find.text('第一次体检'), findsNothing);
    expect(find.text('来到家里'), findsNothing);
    await disposeTestApp(tester);
  });

  testWidgets('keeps the real-profile home layout stable at 375px', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await PetRepository(database).create(const PetDraft(name: '团子'));

    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    expect(find.textContaining('团子'), findsOneWidget);
    expect(find.text('今天'), findsAtLeastNWidgets(1));
    expect(find.text('快速记录'), findsOneWidget);
    expect(find.text('日常护理'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await disposeTestApp(tester);
  });

  testWidgets('starts an active walk from the care card', (tester) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    final startWalk = find.text('一键开始遛狗');
    await tester.ensureVisible(startWalk);
    await tester.pumpAndSettle();
    await tester.tap(startWalk);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('正在遛狗'), findsOneWidget);
    expect(find.text('结束遛狗'), findsAtLeastNWidgets(1));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
      listen: false,
    );
    await container.read(careControllerProvider.notifier).finishWalk();
    await tester.pumpAndSettle();
    await disposeTestApp(tester);
  });

  testWidgets('stops a walk before optional details are confirmed', (
    tester,
  ) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    final startWalk = find.text('一键开始遛狗');
    await tester.ensureVisible(startWalk);
    await tester.pumpAndSettle();
    await tester.tap(startWalk);
    await tester.pumpAndSettle();

    final stopWalk = find.text('结束遛狗').last;
    await tester.ensureVisible(stopWalk);
    await tester.pumpAndSettle();
    await tester.tap(stopWalk);
    await tester.pumpAndSettle();

    expect(find.text('遛狗已结束'), findsOneWidget);
    expect(find.text('稍后填写'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
      listen: false,
    );
    expect(container.read(careControllerProvider).activeWalkStartedAt, isNull);
    expect(container.read(careControllerProvider).lastWalk, isNotNull);

    await tester.tap(find.text('稍后填写'));
    await tester.pumpAndSettle();
    expect(container.read(careControllerProvider).activeWalkStartedAt, isNull);
    await disposeTestApp(tester);
  });

  testWidgets('opens a care suggestion and enables it explicitly', (
    tester,
  ) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    final carePlans = find.text('护理计划');
    await tester.ensureVisible(carePlans);
    await tester.pumpAndSettle();
    await tester.tap(carePlans);
    await tester.pumpAndSettle();

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
    expect(find.text('记录口腔护理'), findsOneWidget);
    final saveCareRecord = find.text('保存护理记录');
    await tester.ensureVisible(saveCareRecord);
    await tester.pumpAndSettle();
    await tester.tap(saveCareRecord);
    await tester.pump(const Duration(seconds: 1));

    final historySegment = find.text('记录').first;
    await tester.ensureVisible(historySegment);
    await tester.pumpAndSettle();
    await tester.tap(historySegment);
    await tester.pumpAndSettle();
    expect(find.textContaining('口腔日常护理 · 已完成'), findsOneWidget);
    await disposeTestApp(tester);
  });

  testWidgets('opens the care coverage detail page from home', (tester) async {
    final petId = await CareRepository(database).ensureDefaultPet();
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await CarePlanRepository(database).create(
      CarePlanDraft(
        petId: petId,
        candidateId: 'oral_home_care',
        careType: 'oral',
        title: '口腔日常护理',
        scheduleRule: scheduleRuleCodec.encode(const DailyRule()),
      ),
    );

    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();

    final coverageBadge = find.textContaining('本周覆盖率');
    await tester.ensureVisible(coverageBadge);
    await tester.pumpAndSettle();
    await tester.tap(coverageBadge);
    await tester.pumpAndSettle();

    expect(find.text('护理完成率'), findsAtLeastNWidgets(1));
    expect(find.textContaining('读取完成率失败'), findsNothing);
    await disposeTestApp(tester);
  });

  testWidgets('shows today reminders and completes one', (tester) async {
    final petId = await CareRepository(database).ensureDefaultPet();
    await PetRepository(database).create(const PetDraft(name: '团子'));
    final now = DateTime.now();
    await ReminderRepository(database).create(
      ReminderDraft(
        petId: petId,
        sourceType: 'manual',
        title: '喂益生菌',
        scheduledAt: DateTime(now.year, now.month, now.day, 12),
      ),
    );

    await tester.pumpWidget(testApp(tester));
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
    await tester.pumpWidget(testApp(tester));
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

    expect(find.text('团子'), findsAtLeastNWidgets(1));
    expect(
      (await tester.runAsync(
        () => PetRepository(database).findPets(),
      ))!.single.name,
      '团子',
    );
    await disposeTestApp(tester);
  });
  for (final width in [320.0, 430.0]) {
    testWidgets('home fits ${width}px with large text and reduced motion', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final pet = await PetRepository(
        database,
      ).create(const PetDraft(name: '很长名字的毛孩子团子'));
      await ReminderRepository(database).create(
        ReminderDraft(
          petId: pet.id,
          sourceType: 'manual',
          title: '一条需要完整阅读的比较长的护理提醒',
          scheduledAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: const MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(1.6),
              disableAnimations: true,
            ),
            child: PetHealthApp(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('爱宠时光'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await disposeTestApp(tester);
    });
  }

  testWidgets('switches pet inside home and refreshes the weight stream', (
    tester,
  ) async {
    final repository = PetRepository(database);
    final first = await repository.create(const PetDraft(name: '团子'));
    final second = await repository.create(const PetDraft(name: '豆豆'));
    await repository.selectPet(first.id);
    await HealthRecordRepository(database).create(
      HealthRecordDraft(
        petId: first.id,
        type: 'weight',
        occurredAt: DateTime.now(),
        title: '体重',
        numericValue: 8.2,
        unit: 'kg',
      ),
    );
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();
    expect(find.text('8.2 kg'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('切换狗狗，当前团子'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('豆豆'));
    await tester.pumpAndSettle();
    expect(find.text('8.2 kg'), findsNothing);
    expect(find.text('还未记录'), findsOneWidget);
    await HealthRecordRepository(database).create(
      HealthRecordDraft(
        petId: second.id,
        type: 'weight',
        occurredAt: DateTime.now(),
        title: '体重',
        numericValue: 5.1,
        unit: 'kg',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('5.1 kg'), findsOneWidget);
    expect(find.byTooltip('新增记录'), findsOneWidget);
    await disposeTestApp(tester);
  });

  testWidgets('opens memories directly from the redesigned home', (
    tester,
  ) async {
    await PetRepository(database).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();
    final memoryLink = find.descendant(
      of: find.byType(HomeMemoryPreview),
      matching: find.text('全部'),
    );
    await tester.ensureVisible(memoryLink);
    await tester.pumpAndSettle();
    await tester.tap(memoryLink);
    await tester.pumpAndSettle();
    expect(find.text('还没有爱宠时光'), findsOneWidget);
    expect(find.byTooltip('新增记录'), findsNothing);
    await disposeTestApp(tester);
  });
  testWidgets(
    'timeline combines dated entries and filters without crossing pets',
    (tester) async {
      final pets = PetRepository(database);
      final pet = await pets.create(const PetDraft(name: '团子'));
      final other = await pets.create(const PetDraft(name: '豆豆'));
      await pets.selectPet(pet.id);
      final now = DateTime.now();
      await HealthRecordRepository(database).create(
        HealthRecordDraft(
          petId: pet.id,
          type: 'food',
          occurredAt: now,
          title: '时间线早餐',
          numericValue: 120,
          unit: 'g',
        ),
      );
      await HealthRecordRepository(database).create(
        HealthRecordDraft(
          petId: other.id,
          type: 'food',
          occurredAt: now,
          title: '别的狗狗早餐',
        ),
      );
      await CareRepository(database).create(
        CareActivityDraft(
          petId: pet.id,
          type: 'bath',
          occurredAt: now,
          place: '家里',
        ),
      );
      await CareRepository(database).create(
        CareActivityDraft(
          petId: pet.id,
          type: 'walk',
          occurredAt: now,
          startedAt: now.subtract(const Duration(minutes: 32)),
          endedAt: now,
        ),
      );
      final memories = MemoryRepository(database, createAlbumAssetService());
      await memories.create(
        petId: pet.id,
        occurredAt: now,
        note: '今天去了海边',
        media: [],
      );
      await memories.create(
        petId: pet.id,
        occurredAt: now.subtract(const Duration(days: 8)),
        note: '八天前的时光',
        media: [],
      );
      await tester.pumpWidget(testApp(tester));
      await tester.pumpAndSettle();
      appRouter.go('/timeline');
      await tester.pumpAndSettle();
      expect(find.text('时间线早餐'), findsOneWidget);
      expect(find.text('洗澡'), findsOneWidget);
      expect(find.text('遛狗 32 分钟'), findsOneWidget);
      expect(find.text('今天去了海边'), findsOneWidget);
      expect(find.text('八天前的时光'), findsNothing);
      expect(find.text('别的狗狗早餐'), findsNothing);
      await tester.tap(find.widgetWithText(ChoiceChip, '时光'));
      await tester.pumpAndSettle();
      expect(
        appRouter
            .routerDelegate
            .currentConfiguration
            .uri
            .queryParameters['type'],
        'memory',
      );
      expect(find.text('今天去了海边'), findsOneWidget);
      expect(find.text('时间线早餐'), findsNothing);
      expect(find.text('洗澡'), findsNothing);
      await tester.ensureVisible(find.text('查看更早的记录'));
      await tester.tap(find.text('查看更早的记录'));
      await tester.pumpAndSettle();
      expect(find.text('八天前的时光'), findsOneWidget);
      appRouter.go('/timeline?type=walk');
      await tester.pumpAndSettle();
      expect(find.text('遛狗 32 分钟'), findsOneWidget);
      expect(find.text('今天去了海边'), findsNothing);
      expect(find.text('洗澡'), findsNothing);
      await tester.tap(find.text('日历'));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(find.text('遛狗 32 分钟'), findsOneWidget);
      await pets.selectPet(other.id);
      await tester.pumpAndSettle();
      expect(find.text('遛狗 32 分钟'), findsNothing);
      await disposeTestApp(tester);
    },
  );

  testWidgets('full-screen food editor saves for its pet and can undo', (
    tester,
  ) async {
    final pet = await PetRepository(
      database,
    ).create(const PetDraft(name: '团子'));
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('新增记录'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('饮食'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.text('记录饮食'), findsOneWidget);
    expect(find.byType(AppNavBar), findsNothing);
    expect(
      tester.getSize(find.byType(SingleChildScrollView).last).height,
      greaterThan(200),
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '食物 / 品牌'),
      '成犬粮',
    );
    await tester.enterText(find.widgetWithText(TextFormField, '份量'), '120');
    await Scrollable.ensureVisible(
      tester.element(find.widgetWithText(ChoiceChip, '早餐')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '早餐'));
    await Scrollable.ensureVisible(
      tester.element(find.widgetWithText(ChoiceChip, '正常吃完')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '正常吃完'));
    await tester.tap(find.text('保存健康记录'));
    await tester.pumpAndSettle();
    final saved = (await tester.runAsync(
      () => HealthRecordRepository(database).findForPet(pet.id),
    ))!.single;
    expect(saved.type, 'food');
    expect(saved.numericValue, 120);
    expect(saved.unit, 'g');
    expect(saved.details, containsPair('meal', '早餐'));
    expect(saved.details, containsPair('appetite', '正常吃完'));
    expect(find.byType(AppNavBar), findsOneWidget);
    await tester.tap(find.text('撤销'));
    await tester.pumpAndSettle();
    expect(
      await tester.runAsync(
        () => HealthRecordRepository(database).findForPet(pet.id),
      ),
      isEmpty,
    );
    await disposeTestApp(tester);
  });

  testWidgets('walk timer stays available across tabs and stops once', (
    tester,
  ) async {
    final pet = await PetRepository(
      database,
    ).create(const PetDraft(name: '团子'));
    final care = CareRepository(database);
    await care.startWalk(
      petId: pet.id,
      at: DateTime.now().subtract(const Duration(minutes: 20)),
    );
    await tester.pumpWidget(testApp(tester));
    await tester.pumpAndSettle();
    for (final tab in ['时间线', '照护', '狗狗']) {
      await tester.tap(
        find.descendant(of: find.byType(AppNavBar), matching: find.text(tab)),
      );
      await tester.pumpAndSettle();
      if (tab == '时间线') {
        expect(find.text('计时中，可在底部结束'), findsOneWidget);
        expect(find.text('遛狗 0 分钟'), findsNothing);
      }
      expect(
        find.descendant(
          of: find.byType(WalkMiniBar),
          matching: find.text('结束遛狗'),
        ),
        findsOneWidget,
      );
    }
    await tester.tap(
      find.descendant(
        of: find.byType(WalkMiniBar),
        matching: find.text('结束遛狗'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('遛狗已结束'), findsOneWidget);
    expect(await care.getActiveWalk(pet.id), isNull);
    await tester.tap(find.text('稍后填写'));
    await tester.pumpAndSettle();
    expect(find.text('结束遛狗'), findsNothing);
    final walks = (await tester.runAsync(
      () => care.findForPet(pet.id, type: 'walk'),
    ))!;
    expect(walks, hasLength(1));
    expect(walks.single.duration!.inMinutes, greaterThanOrEqualTo(20));
    await disposeTestApp(tester);
  });

  testWidgets(
    'settings opens from the dog header and returns to the same tab',
    (tester) async {
      await PetRepository(database).create(const PetDraft(name: '团子'));
      await tester.pumpWidget(testApp(tester));
      await tester.pumpAndSettle();
      appRouter.go('/pet');
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('设置'));
      await tester.pumpAndSettle();
      expect(find.byType(AppNavBar), findsNothing);
      expect(find.text('首页快速记录'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(appRouter.routerDelegate.currentConfiguration.uri.path, '/pet');
      expect(find.byType(AppNavBar), findsOneWidget);
      appRouter.go('/settings');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(appRouter.routerDelegate.currentConfiguration.uri.path, '/today');
      await disposeTestApp(tester);
    },
  );

  testWidgets(
    'all tabs and keyboard editor fit a narrow screen with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await PetRepository(database).create(const PetDraft(name: '很长名字的毛孩子团子'));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(1.6),
            disableAnimations: true,
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
          child: testApp(tester),
        ),
      );
      await tester.pumpAndSettle();
      for (final route in ['/timeline', '/care', '/pet']) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
      }
      await tester.tap(find.byTooltip('新增记录'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('饮食'));
      await tester.tap(find.text('饮食'));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final button = find.text('保存健康记录').hitTestable();
      expect(tester.getRect(button).bottom, lessThanOrEqualTo(600));
      await disposeTestApp(tester);
    },
  );
}
