import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/app/theme.dart';
import 'package:pet_health/core/ui/ui.dart';

Widget _host(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('AppTheme', () {
    test('light and dark carry the app color extension', () {
      expect(AppTheme.light.extension<AppColors>(), AppColors.light);
      expect(AppTheme.dark.extension<AppColors>(), AppColors.dark);
    });

    test('uses the forest palette as primary', () {
      expect(AppTheme.light.colorScheme.primary, AppPalette.forest);
      expect(AppTheme.light.scaffoldBackgroundColor, AppPalette.paper);
      expect(AppTheme.dark.colorScheme.surface, AppPalette.nightPaper);
    });
  });

  group('ChoiceGroup', () {
    const meals = [
      Choice('breakfast', '早餐'),
      Choice('lunch', '午餐'),
      Choice('dinner', '晚餐'),
    ];

    testWidgets('selects and, when allowed, clears an option', (tester) async {
      String? value;
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, setState) => ChoiceGroup<String>(
              label: '餐次',
              options: meals,
              selected: value,
              allowDeselect: true,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );

      await tester.tap(find.text('午餐'));
      await tester.pump();
      expect(value, 'lunch');

      await tester.tap(find.text('午餐'));
      await tester.pump();
      expect(value, isNull);
    });

    testWidgets('keeps an overflowed selection visible and picks from more', (
      tester,
    ) async {
      final options = [for (var i = 1; i <= 10; i++) Choice(i, '选项$i')];
      int? value = 9;
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, setState) => ChoiceGroup<int>(
              label: '单位',
              options: options,
              selected: value,
              maxVisible: 4,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );

      expect(find.text('选项9'), findsOneWidget);
      expect(find.text('选项7'), findsNothing);

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('选项7'));
      await tester.pumpAndSettle();
      expect(value, 7);
      expect(find.text('选项7'), findsOneWidget);
      expect(find.text('选项9'), findsNothing);
    });
  });

  group('AsyncValueView', () {
    testWidgets('shows loading, data and a retryable error', (tester) async {
      Widget view(AsyncValue<String> value, {VoidCallback? onRetry}) => _host(
        AsyncValueView<String>(
          value: value,
          loadingLabel: '正在读取提醒',
          errorTitle: '提醒加载失败',
          onRetry: onRetry,
          data: (text) => Text(text),
        ),
      );

      await tester.pumpWidget(view(const AsyncValue.loading()));
      expect(find.text('正在读取提醒'), findsOneWidget);

      await tester.pumpWidget(view(const AsyncValue.data('驱虫药')));
      expect(find.text('驱虫药'), findsOneWidget);

      var retried = false;
      await tester.pumpWidget(
        view(
          AsyncValue.error(Exception('磁盘不可用'), StackTrace.empty),
          onRetry: () => retried = true,
        ),
      );
      expect(find.text('提醒加载失败'), findsOneWidget);
      expect(find.text('磁盘不可用'), findsOneWidget);
      await tester.tap(find.text('重试'));
      expect(retried, isTrue);
    });
  });

  testWidgets('ListRow and StatTile render in dark mode with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var tapped = false;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 640),
          textScaler: TextScaler.linear(1.6),
        ),
        child: _host(
          theme: AppTheme.dark,
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              children: [
                SectionCard.rows(
                  children: [
                    ListRow(
                      leading: const IconBadge(Icons.spa_outlined),
                      title: '护理计划',
                      subtitle: '按自己的节奏，安排日常照护',
                      onTap: () => tapped = true,
                    ),
                    const ListRow(
                      title: '就诊与处方',
                      enabled: false,
                      trailing: Text('即将推出'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const StatTile(label: '最近体重', value: '12.4', unit: 'kg'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('护理计划'));
    expect(tapped, isTrue);
    expect(find.bySemanticsLabel('最近体重 12.4kg'), findsOneWidget);
  });
}
