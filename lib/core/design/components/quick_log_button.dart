import 'package:flutter/material.dart';

import '../paw_icons.dart';
import '../tokens.dart';

/// 首页的一键记录按钮：大圆图标、名称和今天的进度。
///
/// 点一下直接记录；长按打开补充面板。[due] 显示提醒小圆点，
/// [justLogged] 在刚记完时显示绿色外圈和对勾。
class QuickLogButton extends StatelessWidget {
  const QuickLogButton({
    super.key,
    required this.glyph,
    required this.tone,
    required this.label,
    required this.caption,
    required this.onTap,
    this.onLongPress,
    this.due = false,
    this.justLogged = false,
  });

  final PawGlyph glyph;
  final PawTone tone;
  final String label;
  final String caption;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool due;
  final bool justLogged;

  static const _size = 70.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final highlight = due || justLogged;
    return Semantics(
      button: true,
      label: '$label, $caption',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(PawRadii.tile),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: tone.fill,
                  shape: BoxShape.circle,
                  boxShadow: justLogged
                      ? const [
                          BoxShadow(color: PawColors.ground, spreadRadius: 4),
                          BoxShadow(color: PawColors.success, spreadRadius: 7),
                        ]
                      : null,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    PawIcon(glyph, size: 32, color: tone.onFill),
                    if (justLogged)
                      const Positioned(top: -6, right: -6, child: _CheckBadge())
                    else if (due)
                      const Positioned(top: 2, right: 2, child: _DueDot()),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Text(label, style: text.titleSmall, maxLines: 1),
              const SizedBox(height: 2),
              Text(
                caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelSmall?.copyWith(
                  color: highlight ? PawTones.mint.onFill : PawColors.inkMuted,
                  fontWeight: highlight ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DueDot extends StatelessWidget {
  const _DueDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: PawColors.coral,
      shape: BoxShape.circle,
      border: Border.all(color: PawColors.ground, width: 3),
    ),
  );
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) => Container(
    width: 26,
    height: 26,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: PawColors.success,
      shape: BoxShape.circle,
      border: Border.all(color: PawColors.ground, width: 3),
    ),
    child: const PawIcon(
      PawGlyph.check,
      size: 14,
      color: Colors.white,
      strokeWidth: 3.4,
    ),
  );
}
