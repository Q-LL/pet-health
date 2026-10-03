import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/ui/ui.dart';
import '../features/care/presentation/walk_mini_bar.dart';
import '../features/records/presentation/add_record_sheet.dart';

/// Tab destinations in branch order. The record action sits between the
/// second and third tab and is not a branch.
const appTabs = [
  AppTab('今天', Icons.home_outlined, Icons.home_rounded),
  AppTab('时间线', Icons.view_agenda_outlined, Icons.view_agenda_rounded),
  AppTab('照护', Icons.spa_outlined, Icons.spa_rounded),
  AppTab('狗狗', Icons.pets_outlined, Icons.pets_rounded),
];

class AppTab {
  const AppTab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WalkMiniBar(),
          AppNavBar(
            currentIndex: navigationShell.currentIndex,
            onSelect: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            onRecord: () => showAddRecordSheet(context),
          ),
        ],
      ),
    );
  }
}

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.currentIndex,
    required this.onSelect,
    required this.onRecord,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Widget tab(int index) => Expanded(
      child: _NavItem(
        tab: appTabs[index],
        selected: index == currentIndex,
        onTap: () => onSelect(index),
      ),
    );

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Material(
        color: colors.surface,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  tab(0),
                  tab(1),
                  Expanded(child: _RecordButton(onPressed: onRecord)),
                  tab(2),
                  tab(3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = selected ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              curve: AppMotion.emphasized,
              width: 56,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? colors.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                selected ? tab.selectedIcon : tab.icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Tooltip(
        message: '新增记录',
        excludeFromSemantics: true,
        child: Semantics(
          button: true,
          label: '新增记录',
          excludeSemantics: true,
          child: Material(
            color: colors.primary,
            borderRadius: BorderRadius.circular(18),
            elevation: 1,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 56,
                height: 48,
                child: Icon(
                  Icons.add_rounded,
                  size: 28,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
