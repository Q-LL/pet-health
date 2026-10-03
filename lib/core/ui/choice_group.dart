import 'package:flutter/material.dart';

import 'tokens.dart';

class Choice<T> {
  const Choice(this.value, this.label);

  final T value;
  final String label;
}

/// Visible options instead of a dropdown. Shows at most [maxVisible]
/// options inline; the rest open from a trailing "更多" chip.
///
/// Single-select by default; tapping the selected option again clears it
/// when [allowDeselect] is true.
class ChoiceGroup<T> extends StatelessWidget {
  const ChoiceGroup({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.label,
    this.allowDeselect = false,
    this.maxVisible = 7,
    super.key,
  });

  final List<Choice<T>> options;
  final T? selected;
  final ValueChanged<T?> onChanged;
  final String? label;
  final bool allowDeselect;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overflow = options.length > maxVisible;
    final inline = overflow ? _inlineOptions() : options;

    final chips = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in inline)
          ChoiceChip(
            label: Text(option.label),
            selected: option.value == selected,
            onSelected: (isSelected) {
              if (isSelected) {
                onChanged(option.value);
              } else if (allowDeselect) {
                onChanged(null);
              }
            },
          ),
        if (overflow)
          ActionChip(
            label: const Text('更多'),
            avatar: const Icon(Icons.expand_more_rounded, size: 18),
            onPressed: () => _showAll(context),
          ),
      ],
    );

    if (label == null) return chips;
    return Semantics(
      container: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          chips,
        ],
      ),
    );
  }

  /// First `maxVisible - 1` options, with the current selection kept
  /// visible even when it lives in the overflow.
  List<Choice<T>> _inlineOptions() {
    final head = options.take(maxVisible - 1).toList();
    final current = options.where((o) => o.value == selected).firstOrNull;
    if (current != null && !head.contains(current)) {
      head[head.length - 1] = current;
    }
    return head;
  }

  Future<void> _showAll(BuildContext context) async {
    final picked = await showModalBottomSheet<Choice<T>>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .7,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            0,
            AppSpacing.page,
            AppSpacing.section,
          ),
          children: [
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            for (final option in options)
              ListTile(
                title: Text(option.label),
                trailing: option.value == selected
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        ),
      ),
    );
    if (picked != null) onChanged(picked.value);
  }
}
