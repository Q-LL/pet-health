import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/knowledge_repository.dart';

class RelatedKnowledgeLink extends ConsumerWidget {
  const RelatedKnowledgeLink({
    required this.contextKey,
    this.compact = false,
    super.key,
  });

  final String contextKey;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = ref.watch(relatedKnowledgeProvider(contextKey));
    return related.maybeWhen(
      data: (articles) {
        if (articles.isEmpty) return const SizedBox.shrink();
        final article = articles.first;
        final colors = Theme.of(context).colorScheme;
        return InkWell(
          borderRadius: BorderRadius.circular(compact ? 12 : 16),
          onTap: () => context.push('/settings/knowledge/${article.id}'),
          child: Container(
            padding: EdgeInsets.all(compact ? 10 : 12),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: .55),
              borderRadius: BorderRadius.circular(compact ? 12 : 16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: compact ? 16 : 18,
                  color: colors.primary,
                ),
                SizedBox(width: compact ? 6 : 8),
                Expanded(
                  child: Text(
                    compact ? article.title : '了解更多：${article.title}',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: compact ? 11 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: compact ? 16 : 18,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
