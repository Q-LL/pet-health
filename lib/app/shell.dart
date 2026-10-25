import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design/design.dart';
import '../core/l10n/app_locale.dart';
import '../features/entries/presentation/log_flow.dart';
import '../features/entries/presentation/record_center.dart';
import '../features/pets/application/current_pet.dart';

/// 底栏悬浮在内容上方；页面底部要留出这段距离，内容才不会被挡住。
const navClearance = CapsuleNavBar.height + 16 + 24;

/// 四个主页面共用的外框：各自保留状态，底部是悬浮胶囊底栏，
/// 底栏上方是记录后的提示条。
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  /// 中间的 + ：打开记录中心，选好类型后打开对应的面板。
  Future<void> _openRecordCenter(BuildContext context, WidgetRef ref) async {
    final pet = ref.read(currentPetProvider);
    if (pet == null) return;
    final type = await showRecordCenter(context);
    if (type == null || !context.mounted) return;
    await openNewEntry(context, ref, petId: pet.id, type: type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final petName = ref.watch(currentPetProvider)?.name;
    final bottomInset = math.max(MediaQuery.viewPaddingOf(context).bottom, 16);
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          shell,
          Positioned(
            left: 14,
            right: 14,
            bottom: bottomInset + CapsuleNavBar.height + 12,
            child: const LogToastHost(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: CapsuleNavBar(
          currentIndex: shell.currentIndex,
          onSelect: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          centerLabel: l.navLog,
          onCenter: () => _openRecordCenter(context, ref),
          items: [
            CapsuleNavItem(glyph: PawGlyph.today, label: l.navToday),
            CapsuleNavItem(glyph: PawGlyph.timeline, label: l.navTimeline),
            CapsuleNavItem(glyph: PawGlyph.plans, label: l.navPlans),
            CapsuleNavItem(
              glyph: PawGlyph.paw,
              label: petName ?? l.navPetFallback,
            ),
          ],
        ),
      ),
    );
  }
}

/// 还没做好的页面的占位。
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, this.sticker});

  final String title;
  final StickerArt? sticker;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          PawSpace.page,
          26,
          PawSpace.page,
          navClearance,
        ),
        children: [
          Text(title, style: text.headlineMedium),
          const SizedBox(height: PawSpace.xl),
          Center(
            child: Sticker(
              sticker ?? StickerArt.golden,
              size: 132,
              turns: -0.017,
            ),
          ),
          const SizedBox(height: PawSpace.lg),
          Center(child: Text(l.pageComingSoon, style: text.bodySmall)),
        ],
      ),
    );
  }
}
