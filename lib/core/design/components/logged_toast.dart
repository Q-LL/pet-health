import 'package:flutter/material.dart';

import '../paw_icons.dart';
import '../tokens.dart';

/// 一键记录后浮在底栏上方的提示条：已经记好，可以撤销或补充细节。
///
/// 不打断操作：什么都不点也没关系，几秒后由外层收起。
class LoggedToast extends StatelessWidget {
  const LoggedToast({
    super.key,
    required this.title,
    required this.detail,
    required this.undoLabel,
    required this.onUndo,
    required this.moreLabel,
    required this.onMore,
  });

  final String title;
  final String detail;
  final String undoLabel;
  final VoidCallback onUndo;
  final String moreLabel;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: PawColors.surface,
        elevation: 0,
        borderRadius: BorderRadius.circular(PawRadii.row),
        shadowColor: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PawRadii.row),
            boxShadow: const [
              BoxShadow(
                color: Color(0x382E2A35),
                blurRadius: 26,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: PawColors.successSoft,
                    shape: BoxShape.circle,
                  ),
                  child: PawIcon(
                    PawGlyph.check,
                    size: 18,
                    color: PawTones.mint.onFill,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: text.titleSmall),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onUndo,
                  style: TextButton.styleFrom(
                    foregroundColor: PawColors.inkMuted,
                  ),
                  child: Text(undoLabel),
                ),
                FilledButton(onPressed: onMore, child: Text(moreLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
