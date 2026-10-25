import 'package:flutter/material.dart';

import '../stickers.dart';
import '../theme.dart';
import '../tokens.dart';

/// 每日卡片：类别标签、可选的补充说明、正文、可选的贴纸和按钮。
class DailyCard extends StatelessWidget {
  const DailyCard({
    super.key,
    required this.tone,
    required this.tag,
    required this.body,
    this.meta,
    this.sticker,
    this.stickerTurns = 0.028,
    this.emphasis = false,
    this.actions = const [],
    this.onTap,
  });

  final CardTone tone;
  final String tag;
  final String? meta;
  final String body;
  final StickerArt? sticker;
  final double stickerTurns;

  /// 陪伴时刻用标题字体显示正文。
  final bool emphasis;
  final List<Widget> actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sticker = this.sticker;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TagChip(label: tag, color: tone.tag, onColor: tone.onTag),
              if (meta case final meta?) ...[
                const SizedBox(width: PawSpace.sm),
                Flexible(
                  child: Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium?.copyWith(
                      color: PawColors.inkMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: PawSpace.sm),
          Padding(
            padding: EdgeInsets.only(right: sticker == null ? 0 : 68),
            child: Text(
              body,
              style: emphasis
                  ? text.titleLarge?.copyWith(fontSize: 19, height: 1.45)
                  : PawTextStyles.of(context).note,
            ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: PawSpace.md),
            Wrap(spacing: 10, runSpacing: 8, children: actions),
          ],
        ],
      ),
    );

    return Material(
      color: tone.fill,
      borderRadius: BorderRadius.circular(PawRadii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            content,
            if (sticker != null)
              Positioned(
                right: 10,
                bottom: 8,
                child: Sticker(sticker, size: 70, turns: stickerTurns),
              ),
          ],
        ),
      ),
    );
  }
}

/// 胶囊形的类别标签。
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.color,
    required this.onColor,
  });

  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(PawRadii.chip),
    ),
    child: Text(
      label,
      style: PawTextStyles.of(context).tag.copyWith(color: onColor),
    ),
  );
}

/// 卡片里的胶囊按钮：主要动作用深色底，次要动作用白底。
class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: primary ? PawColors.ink : PawColors.surface,
      foregroundColor: primary ? Colors.white : PawColors.ink,
    ),
    child: Text(label),
  );
}
