import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tokens.dart';

/// Renders an [AsyncValue] with the shared loading and error views.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.loadingLabel,
    this.errorTitle = '读取失败',
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final String? loadingLabel;
  final String errorTitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnReload: true,
    data: data,
    loading: () => LoadingView(label: loadingLabel),
    error: (error, _) => ErrorView(
      title: errorTitle,
      message: describeError(error),
      onRetry: onRetry,
    ),
  );
}

/// Strips Dart's exception prefixes so errors read as sentences.
String describeError(Object error) =>
    error.toString().replaceFirst(RegExp(r'^(Exception|Bad state): '), '');

class LoadingView extends StatelessWidget {
  const LoadingView({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      liveRegion: true,
      label: label ?? '正在读取',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.section),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Text(label!, style: TextStyle(color: muted)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon = Icons.pets_rounded,
    this.illustration,
    this.action,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;

  /// Replaces [icon] when given, e.g. an asset image.
  final Widget? illustration;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.section,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          illustration ??
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, size: 30, color: colors.primary),
              ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.title, this.message, this.onRetry, super.key});

  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.error_outline_rounded,
    title: title,
    message: message,
    action: onRetry == null
        ? null
        : FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
  );
}
