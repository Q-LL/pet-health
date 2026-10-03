import 'package:flutter/material.dart';

import 'motion.dart';
import 'tokens.dart';

/// Standard scrolling page: large serif title that collapses into the app
/// bar, optional subtitle, and a width-constrained body.
class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.compact = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigation = AppPageBackScope.maybeOf(context);
    final embed = AppPageEmbed.maybeOf(context);
    if (embed != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [if (embed.showTitle) SectionHeader(title), child],
      );
    }
    if (compact) {
      return SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          key: PageStorageKey('tab-page-$title'),
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          child: AppContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          title,
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                    ),
                    ...?actions,
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
                const SizedBox(height: AppSpacing.lg),
                child,
              ],
            ),
          ),
        ),
      );
    }
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(title),
            leading: navigation == null
                ? null
                : BackButton(onPressed: navigation.onBack),
            actions: [
              ...?actions,
              const SizedBox(width: AppSpacing.sm),
            ],
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
          SliverToBoxAdapter(
            child: AppContent(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                0,
                AppSpacing.page,
                AppSpacing.navClearance,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.page),
                  ],
                  EntranceAnimation(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Provides a return action to full-screen pages, including direct links.
class AppPageBackScope extends InheritedWidget {
  const AppPageBackScope({
    required this.onBack,
    required super.child,
    super.key,
  });

  final VoidCallback onBack;

  static AppPageBackScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppPageBackScope>();

  @override
  bool updateShouldNotify(AppPageBackScope oldWidget) =>
      onBack != oldWidget.onBack;
}

/// Hosts [AppPage]s as plain content inside another scrolling page, e.g.
/// the segments of a tab. Embedded pages drop their app bar, subtitle and
/// actions; the host is responsible for scrolling.
class AppPageEmbed extends InheritedWidget {
  const AppPageEmbed({required super.child, this.showTitle = false, super.key});

  /// Renders each embedded page's title as a section header.
  final bool showTitle;

  static AppPageEmbed? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppPageEmbed>();

  @override
  bool updateShouldNotify(AppPageEmbed oldWidget) =>
      showTitle != oldWidget.showTitle;
}

/// Centers [child] and caps it at [AppSpacing.maxContentWidth].
class AppContent extends StatelessWidget {
  const AppContent({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.page),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Center(
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
      child: Padding(padding: padding, child: child),
    ),
  );
}

/// A titled block within a page, with an optional trailing text action.
class AppSection extends StatelessWidget {
  const AppSection({
    required this.title,
    required this.child,
    this.action,
    this.onTap,
    super.key,
  });

  final String title;
  final Widget child;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(title, action: action, onTap: onTap),
      child,
    ],
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.action, this.onTap, super.key});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            if (action != null)
              TextButton(onPressed: onTap, child: Text(action!)),
          ],
        ),
      ),
    );
  }
}
