import 'package:flutter/material.dart';

import 'tokens.dart';

/// White rounded card that groups rows or content.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.color,
    this.onTap,
    super.key,
  });

  /// Stacks [children] with inset dividers between them.
  factory SectionCard.rows({
    required List<Widget> children,
    Color? color,
    Key? key,
  }) => SectionCard(
    key: key,
    color: color,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(),
          children[i],
        ],
      ],
    ),
  );

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: AppRadius.cardAll,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

/// A single row: leading badge, title, optional subtitle, trailing widget.
/// Rows with [onTap] show a chevron unless [trailing] is given.
class ListRow extends StatelessWidget {
  const ListRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.subtitleColor,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? subtitleColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final muted = colors.onSurfaceVariant;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: enabled ? null : muted,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtitleColor ?? muted,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null && enabled)
              Icon(Icons.chevron_right_rounded, color: muted, size: 20),
          ],
        ),
      ),
    );
    if (onTap == null || !enabled) return row;
    return InkWell(onTap: onTap, borderRadius: AppRadius.chipAll, child: row);
  }
}

/// Rounded-square icon holder used as a row or tile leading.
class IconBadge extends StatelessWidget {
  const IconBadge(
    this.icon, {
    this.size = 36,
    this.background,
    this.foreground,
    super.key,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? colors.primaryContainer,
        borderRadius: BorderRadius.circular(size * .34),
      ),
      child: Icon(
        icon,
        size: size * .56,
        color: foreground ?? colors.onPrimaryContainer,
      ),
    );
  }
}

/// A labelled metric with an optional visual such as a sparkline.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    this.unit,
    this.caption,
    this.visual,
    this.onTap,
    super.key,
  });

  final String label;
  final String value;
  final String? unit;
  final String? caption;
  final Widget? visual;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Semantics(
        label: '$label $value${unit ?? ''}',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: value,
                      children: [
                        if (unit != null)
                          TextSpan(
                            text: ' $unit',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                if (visual != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: visual!),
                ],
              ],
            ),
            if (caption != null) ...[
              const SizedBox(height: 4),
              Text(
                caption!,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
