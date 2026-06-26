import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/health_tips_provider.dart';
import '../domain/health_tip.dart';

/// 健康动态卡片区域，替换首页的 _ActivityCard + _InsightCard。
class HealthTipsCard extends ConsumerWidget {
  const HealthTipsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(healthTipsProvider);

    return tipsAsync.when(
      loading: () => const _TipsLoading(),
      error: (_, _) => const SizedBox.shrink(),
      data: (tips) {
        if (tips.isEmpty) return const _TipsEmpty();
        return _TipsList(tips: tips);
      },
    );
  }
}

class _TipsLoading extends StatelessWidget {
  const _TipsLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _TipsEmpty extends StatelessWidget {
  const _TipsEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined, color: colors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '积累更多记录，解锁个性化健康建议',
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsList extends StatefulWidget {
  const _TipsList({required this.tips});
  final List<HealthTip> tips;

  @override
  State<_TipsList> createState() => _TipsListState();
}

class _TipsListState extends State<_TipsList> {
  final Set<String> _dismissedIds = {};

  void _dismiss(String id) {
    setState(() {
      _dismissedIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleTips = widget.tips
        .where((tip) => !_dismissedIds.contains(tip.id))
        .toList();
    if (visibleTips.isEmpty) return const _TipsEmpty();

    return SizedBox(
      height: _cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: visibleTips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final tip = visibleTips[index];
          return SizedBox(
            width: _cardWidth,
            child: _TipCard(tip: tip, onDismiss: () => _dismiss(tip.id)),
          );
        },
      ),
    );
  }
}

const double _cardWidth = 300;
const double _cardHeight = 196;

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.onDismiss});
  final HealthTip tip;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scheme = _categoryScheme(tip.category, colors);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: scheme.containerColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: scheme.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tip.icon, color: scheme.iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _categoryLabel(tip.category),
                  style: TextStyle(
                    color: scheme.badgeTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (tip.priority == 'high')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '重要',
                    style: TextStyle(
                      color: colors.onErrorContainer,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  tooltip: '不再显示',
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.badgeColor.withValues(alpha: .72),
                    foregroundColor: scheme.textColor.withValues(alpha: .66),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tip.title,
            style: TextStyle(
              color: scheme.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              tip.body,
              style: TextStyle(
                color: scheme.textColor.withValues(alpha: .82),
                fontSize: 13,
                height: 1.45,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: scheme.textColor.withValues(alpha: .5),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  tip.reason,
                  style: TextStyle(
                    color: scheme.textColor.withValues(alpha: .5),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipColorScheme {
  const _TipColorScheme({
    required this.containerColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.textColor,
  });

  final Color containerColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color textColor;
}

_TipColorScheme _categoryScheme(String category, ColorScheme colors) {
  return switch (category) {
    'seasonal' => _TipColorScheme(
      containerColor: const Color(0xFFE8F5E9),
      iconBgColor: const Color(0xFFC8E6C9),
      iconColor: const Color(0xFF2E7D32),
      badgeColor: const Color(0xFFA5D6A7),
      badgeTextColor: const Color(0xFF1B5E20),
      textColor: const Color(0xFF1B5E20),
    ),
    'life_stage' => _TipColorScheme(
      containerColor: const Color(0xFFE3F2FD),
      iconBgColor: const Color(0xFFBBDEFB),
      iconColor: const Color(0xFF1565C0),
      badgeColor: const Color(0xFF90CAF9),
      badgeTextColor: const Color(0xFF0D47A1),
      textColor: const Color(0xFF0D47A1),
    ),
    'data_insight' => _TipColorScheme(
      containerColor: const Color(0xFFFFF3E0),
      iconBgColor: const Color(0xFFFFE0B2),
      iconColor: const Color(0xFFE65100),
      badgeColor: const Color(0xFFFFCC80),
      badgeTextColor: const Color(0xFFBF360C),
      textColor: const Color(0xFFBF360C),
    ),
    'breed' => _TipColorScheme(
      containerColor: const Color(0xFFF3E5F5),
      iconBgColor: const Color(0xFFE1BEE7),
      iconColor: const Color(0xFF6A1B9A),
      badgeColor: const Color(0xFFCE93D8),
      badgeTextColor: const Color(0xFF4A148C),
      textColor: const Color(0xFF4A148C),
    ),
    _ => _TipColorScheme(
      containerColor: colors.surfaceContainerHigh,
      iconBgColor: colors.surfaceContainerHighest,
      iconColor: colors.onSurface,
      badgeColor: colors.surfaceContainerHighest,
      badgeTextColor: colors.onSurface,
      textColor: colors.onSurface,
    ),
  };
}

String _categoryLabel(String category) {
  return switch (category) {
    'seasonal' => '季节养护',
    'life_stage' => '生命阶段',
    'data_insight' => '数据洞察',
    'breed' => '品种关注',
    _ => '健康建议',
  };
}
