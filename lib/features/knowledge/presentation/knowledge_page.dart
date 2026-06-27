import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_frame.dart';
import '../data/knowledge_repository.dart';
import '../domain/knowledge_article.dart';

class KnowledgePage extends ConsumerStatefulWidget {
  const KnowledgePage({super.key});

  @override
  ConsumerState<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends ConsumerState<KnowledgePage> {
  String? _category;
  var _keyword = '';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(knowledgeCategoriesProvider);
    final articles = ref.watch(
      knowledgeArticlesProvider(
        KnowledgeQuery(category: _category, keyword: _keyword),
      ),
    );

    return PageFrame(
      title: '本地知识库',
      subtitle: '离线参考手册：用于观察、记录、护理和就医准备，不替代兽医诊断。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: '搜索饮水、腹泻、口腔护理...',
            ),
            onChanged: (value) => setState(() => _keyword = value),
          ),
          const SizedBox(height: 14),
          categories.when(
            data: (items) => _CategoryChips(
              categories: items,
              selected: _category,
              onSelected: (value) => setState(() => _category = value),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 18),
          articles.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const _KnowledgeEmpty(
              icon: Icons.error_outline_rounded,
              title: '知识库暂时不可用',
              message: '稍后重试，记录和提醒功能不受影响。',
            ),
            data: (items) {
              if (items.isEmpty) {
                return const _KnowledgeEmpty(
                  icon: Icons.search_off_rounded,
                  title: '没有找到相关文章',
                  message: '换个关键词或分类再试试。',
                );
              }
              return Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    _ArticleCard(article: items[index]),
                    if (index != items.length - 1) const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class KnowledgeArticlePage extends ConsumerWidget {
  const KnowledgeArticlePage({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(knowledgeArticleProvider(articleId));
    return article.when(
      loading: () => const PageFrame(
        title: '本地知识库',
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const PageFrame(
        title: '本地知识库',
        child: _KnowledgeEmpty(
          icon: Icons.error_outline_rounded,
          title: '文章暂时不可用',
          message: '稍后重试，记录和提醒功能不受影响。',
        ),
      ),
      data: (item) {
        if (item == null) {
          return const PageFrame(
            title: '本地知识库',
            child: _KnowledgeEmpty(
              icon: Icons.menu_book_outlined,
              title: '没有找到这篇文章',
              message: '它可能已经被新的知识包替换。',
            ),
          );
        }
        return PageFrame(
          title: item.title,
          subtitle: '${item.categoryLabel} · ${item.severityLabel}',
          child: _ArticleDetail(article: item),
        );
      },
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('全部'),
          selected: selected == null,
          onSelected: (_) => onSelected(null),
        ),
        for (final category in categories)
          FilterChip(
            label: Text(knowledgeCategories[category] ?? category),
            selected: selected == category,
            onSelected: (_) => onSelected(category),
          ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final KnowledgeArticle article;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
        leading: CircleAvatar(
          backgroundColor: _severityColor(article.severityLevel, colors),
          foregroundColor: _severityOnColor(article.severityLevel, colors),
          child: Icon(_categoryIcon(article.category), size: 20),
        ),
        title: Text(article.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            article.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/settings/knowledge/${article.id}'),
      ),
    );
  }
}

class _ArticleDetail extends StatelessWidget {
  const _ArticleDetail({required this.article});

  final KnowledgeArticle article;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoticeBox(article: article),
        const SizedBox(height: 18),
        Text(article.summary, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 14),
        Text(article.body, style: Theme.of(context).textTheme.bodyLarge),
        if (article.suggestedActions.isNotEmpty) ...[
          const SizedBox(height: 22),
          const SectionHeader('建议记录'),
          _BulletCard(items: article.suggestedActions),
        ],
        if (article.redFlags.isNotEmpty) ...[
          const SizedBox(height: 22),
          Text('建议联系兽医的情况', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _BulletCard(
            items: article.redFlags,
            color: colors.errorContainer,
            iconColor: colors.onErrorContainer,
          ),
        ],
        if (article.tags.isNotEmpty) ...[
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final tag in article.tags) Chip(label: Text(tag))],
          ),
        ],
        if (article.sources.isNotEmpty) ...[
          const SizedBox(height: 22),
          const SectionHeader('来源'),
          Card(
            child: Column(
              children: [
                for (final source in article.sources)
                  ListTile(
                    title: Text(source.organization),
                    subtitle: SelectableText('${source.title}\n${source.url}'),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _NoticeBox extends StatelessWidget {
  const _NoticeBox({required this.article});

  final KnowledgeArticle article;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _severityColor(article.severityLevel, colors),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            article.severityLevel == 'urgent'
                ? Icons.local_hospital_outlined
                : Icons.info_outline_rounded,
            color: _severityOnColor(article.severityLevel, colors),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              article.severityLevel == 'urgent'
                  ? '这篇文章只提供就医准备提示。出现红旗情况时，请优先联系兽医。'
                  : '这是一篇本地参考手册，用于帮助观察和记录，不替代兽医诊断。',
              style: TextStyle(
                color: _severityOnColor(article.severityLevel, colors),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({required this.items, this.color, this.iconColor});

  final List<String> items;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final item in items)
              ListTile(
                dense: true,
                leading: Icon(
                  Icons.check_circle_outline_rounded,
                  color: iconColor ?? colors.primary,
                ),
                title: Text(item),
              ),
          ],
        ),
      ),
    );
  }
}

class _KnowledgeEmpty extends StatelessWidget {
  const _KnowledgeEmpty({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(icon, size: 38, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

IconData _categoryIcon(String category) => switch (category) {
  'symptom_observation' => Icons.monitor_heart_outlined,
  'record_guide' => Icons.edit_note_rounded,
  'daily_care' => Icons.spa_outlined,
  'preventive_health' => Icons.shield_outlined,
  'vet_preparation' => Icons.local_hospital_outlined,
  'life_stage' => Icons.timeline_rounded,
  'breed_traits' => Icons.psychology_alt_outlined,
  'seasonal_care' => Icons.wb_sunny_outlined,
  _ => Icons.menu_book_outlined,
};

Color _severityColor(String severity, ColorScheme colors) => switch (severity) {
  'urgent' => colors.errorContainer,
  'watch' => colors.tertiaryContainer,
  _ => colors.primaryContainer,
};

Color _severityOnColor(String severity, ColorScheme colors) =>
    switch (severity) {
      'urgent' => colors.onErrorContainer,
      'watch' => colors.onTertiaryContainer,
      _ => colors.onPrimaryContainer,
    };
