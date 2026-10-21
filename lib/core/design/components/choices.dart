import 'package:flutter/material.dart';

import '../paw_icons.dart';
import '../tokens.dart';

/// 等大的选项格子，补充面板里用来选状态。约 58px 高，好点、不换行。
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.attention = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// 需要留意的选项（如"有血或黏液"）用淡暖红底色，醒目但不吓人。
  final bool attention;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fill = selected
        ? PawColors.successSoft
        : attention
        ? const Color(0xFFFFF1EC)
        : const Color(0xFFF7F3F8);
    return Semantics(
      selected: selected,
      button: true,
      inMutuallyExclusiveGroup: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PawRadii.tile),
          side: selected
              ? const BorderSide(color: PawColors.success, width: 2.5)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PawRadii.tile),
          ),
          onTap: onTap,
          child: SizedBox(
            height: 58,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _Radio(selected: selected, attention: attention),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyLarge?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selected ? PawTones.mint.onFill : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected, required this.attention});

  final bool selected;
  final bool attention;

  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 22,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: selected ? PawColors.success : null,
      border: selected
          ? null
          : Border.all(
              color: attention
                  ? const Color(0xFFE7A795)
                  : const Color(0xFFCFC5D6),
              width: 2,
            ),
    ),
    child: selected
        ? const PawIcon(
            PawGlyph.check,
            size: 13,
            color: Colors.white,
            strokeWidth: 3.6,
          )
        : null,
  );
}

/// 胶囊形的二选一或多选一切换。
class PillSegmented<T> extends StatelessWidget {
  const PillSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> options;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: PawColors.subtle,
        borderRadius: BorderRadius.circular(PawRadii.chip),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: Semantics(
                selected: option == selected,
                button: true,
                inMutuallyExclusiveGroup: true,
                label: labelOf(option),
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: option == selected ? PawColors.ink : null,
                      borderRadius: BorderRadius.circular(PawRadii.chip),
                    ),
                    child: Text(
                      labelOf(option),
                      style: text.titleMedium?.copyWith(
                        color: option == selected ? Colors.white : null,
                        fontWeight: option == selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
