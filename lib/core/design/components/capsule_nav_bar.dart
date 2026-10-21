import 'package:flutter/material.dart';

import '../paw_icons.dart';
import '../tokens.dart';

class CapsuleNavItem {
  const CapsuleNavItem({required this.glyph, required this.label});

  final PawGlyph glyph;
  final String label;
}

/// 悬浮的深色胶囊底栏：左右各两个页面，中间是记录按钮。
class CapsuleNavBar extends StatelessWidget {
  const CapsuleNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    required this.centerLabel,
    required this.onCenter,
  }) : assert(items.length == 4);

  final List<CapsuleNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  /// 中间按钮的读屏名称。
  final String centerLabel;
  final VoidCallback onCenter;

  static const height = 72.0;

  @override
  Widget build(BuildContext context) {
    Widget item(int index) {
      final selected = index == currentIndex;
      final color = selected ? PawColors.navActive : PawColors.navIdle;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          label: items[index].label,
          excludeSemantics: true,
          child: InkResponse(
            onTap: () => onSelect(index),
            radius: 32,
            child: SizedBox(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PawIcon(items[index].glyph, color: color, strokeWidth: 2.4),
                  const SizedBox(height: 3),
                  Text(
                    items[index].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: PawColors.navBar,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332E2A35),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          item(0),
          item(1),
          Expanded(
            child: Center(
              child: Semantics(
                button: true,
                label: centerLabel,
                excludeSemantics: true,
                child: Material(
                  color: PawColors.coral,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onCenter,
                    child: const SizedBox(
                      width: 54,
                      height: 54,
                      child: Center(
                        child: PawIcon(
                          PawGlyph.plus,
                          size: 26,
                          color: PawColors.ink,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          item(2),
          item(3),
        ],
      ),
    );
  }
}
