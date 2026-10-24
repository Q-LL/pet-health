import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/design/design.dart';
import 'package:pet_health/features/cards/domain/card_codes.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';

/// WCAG 2.1 对比度。
double _contrast(Color a, Color b) {
  double luminance(Color c) {
    double channel(double v) =>
        v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(c.r) +
        0.7152 * channel(c.g) +
        0.0722 * channel(c.b);
  }

  final la = luminance(a);
  final lb = luminance(b);
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

Widget _wrap(Widget child) => MaterialApp(
  theme: buildPawTheme(const Locale('zh')),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('颜色对比度（WCAG 4.5:1）', () {
    void expectReadable(Color fg, Color bg, String name) {
      expect(_contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: name);
    }

    test('正文和次要文字', () {
      expectReadable(PawColors.ink, PawColors.ground, 'ink / ground');
      expectReadable(PawColors.inkMuted, PawColors.ground, 'muted / ground');
      expectReadable(PawColors.inkMuted, PawColors.surface, 'muted / surface');
      expectReadable(PawColors.coralText, PawColors.surface, 'coral text');
      expectReadable(PawColors.ink, PawColors.coral, 'ink on coral button');
      expectReadable(PawColors.navActive, PawColors.navBar, 'nav active');
      expectReadable(PawColors.navIdle, PawColors.navBar, 'nav idle');
    });

    test('每种记录类型的图标颜色', () {
      for (final type in EntryType.values) {
        final tone = PawTones.forEntry(type);
        // 图标是非文字元素，标准是 3:1；这里按文字标准要求，留足余量。
        expectReadable(tone.onFill, tone.fill, type.code);
      }
    });

    test('每日卡片的标签和正文', () {
      for (final category in CardCategory.values) {
        final tone = CardTone.of(category);
        expectReadable(tone.onTag, tone.tag, '${category.code} tag');
        expectReadable(PawColors.ink, tone.fill, '${category.code} body');
        expectReadable(PawColors.inkMuted, tone.fill, '${category.code} meta');
      }
    });
  });

  group('组件', () {
    testWidgets('一键记录：点一下记录，长按打开补充面板', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(
        _wrap(
          QuickLogButton(
            glyph: PawGlyph.potty,
            tone: PawTones.sand,
            label: '排泄',
            caption: '便便 1 次',
            onTap: () => taps++,
            onLongPress: () => longPresses++,
          ),
        ),
      );
      await tester.tap(find.text('排泄'));
      await tester.longPress(find.text('排泄'));
      expect(taps, 1);
      expect(longPresses, 1);
      expect(find.bySemanticsLabel('排泄, 便便 1 次'), findsOneWidget);
    });

    testWidgets('提示条：撤销和补充', (tester) async {
      var undone = false;
      var more = false;
      await tester.pumpWidget(
        _wrap(
          LoggedToast(
            title: '已记下',
            detail: '便便 · 正常 · 08:42',
            undoLabel: '撤销',
            onUndo: () => undone = true,
            moreLabel: '补充',
            onMore: () => more = true,
          ),
        ),
      );
      await tester.tap(find.text('撤销'));
      await tester.tap(find.text('补充'));
      expect(undone, isTrue);
      expect(more, isTrue);
    });

    testWidgets('选项格子报告选中状态', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              OptionTile(label: '正常', selected: true, onTap: () {}),
              OptionTile(
                label: '有血或黏液',
                selected: false,
                attention: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('正常')),
        matchesSemantics(
          label: '正常',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
        ),
      );
      expect(tester.getSize(find.byType(OptionTile).first).height, 58);
    });

    testWidgets('卡片显示标签、说明和正文，按钮可点', (tester) async {
      var logged = false;
      await tester.pumpWidget(
        _wrap(
          DailyCard(
            tone: CardTone.of(CardCategory.comingUp),
            tag: '该做了',
            meta: '驱虫 · 每月',
            body: '距离上次心丝虫预防 30 天了。',
            actions: [
              CardButton(
                label: '记一次',
                primary: true,
                onPressed: () => logged = true,
              ),
            ],
          ),
        ),
      );
      expect(find.text('该做了'), findsOneWidget);
      expect(find.text('驱虫 · 每月'), findsOneWidget);
      await tester.tap(find.text('记一次'));
      expect(logged, isTrue);
    });

    testWidgets('胶囊切换', (tester) async {
      var value = 'poop';
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => PillSegmented<String>(
              options: const ['poop', 'pee'],
              selected: value,
              labelOf: (v) => v == 'poop' ? '便便' : '尿尿',
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );
      await tester.tap(find.text('尿尿'));
      await tester.pump();
      expect(value, 'pee');
    });
  });
}
