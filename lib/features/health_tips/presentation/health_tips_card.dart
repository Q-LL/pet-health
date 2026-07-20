import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/health_tips_provider.dart';
import '../domain/health_tip.dart';
import '../../knowledge/presentation/related_knowledge_link.dart';

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
const double _cardHeight = 230;

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
          const SizedBox(height: 8),
          RelatedKnowledgeLink(
            contextKey: _contextKeyForTip(tip),
            compact: true,
          ),
        ],
      ),
    );
  }
}

String _contextKeyForTip(HealthTip tip) {
  final id = tip.id;
  final title = tip.title;

  // ─── 数据洞察：按具体 id 精准映射 ─────────────────────────────────────
  if (tip.category == 'data_insight') {
    return switch (id) {
      'insight_stool_abnormal' => 'record.elimination',
      'insight_urine_abnormal' => 'record.elimination',
      'insight_water_change' => 'health_dynamics.water_change',
      'insight_water_urine_cluster' => 'health_dynamics.water_change',
      'insight_symptom_frequent' => 'record.symptom',
      'insight_diet_sparse' => 'record.food',
      'insight_digestive_cluster' => 'health_dynamics.digestive',
      'insight_weight_up' || 'insight_weight_down' =>
        'health_dynamics.weight_change',
      'insight_coverage_low' => 'health_dynamics.care_plan',
      'insight_record_gap' => 'health_dynamics.tracking',
      'insight_positive_routine' => 'health_dynamics.tracking',
      _ => 'health_dynamics.general',
    };
  }

  // ─── 品种风险：按标题中的品种名匹配 ─────────────────────────────────────
  // breed risk tips 使用 hash ID（breed_xxx.hashCode），无法从 ID 推断品种，
  // 因此必须通过标题关键词匹配。
  final breedContextKey = _matchBreedInTitle(title);
  if (breedContextKey != null) return breedContextKey;

  // ─── 品种风险关键词（标题中无品种名时的通用风险匹配）───────────────────
  if (title.contains('关节') || title.contains('髋')) return 'breed.large';
  if (title.contains('肿瘤')) return 'breed.golden_retriever';
  if (title.contains('心脏')) return 'breed.large';
  if (title.contains('肥胖')) return 'record.weight';
  if (title.contains('耳部') || title.contains('耳朵')) return 'care.ear';
  if (title.contains('脊椎') || title.contains('脊柱')) return 'breed.large';
  if (title.contains('消化')) return 'health_dynamics.digestive';
  if (title.contains('膝盖')) return 'breed.small';
  if (title.contains('牙周') || title.contains('牙齿') || title.contains('口腔')) {
    return 'care.oral';
  }
  if (title.contains('气管') || title.contains('呼吸')) {
    return 'breed.brachycephalic';
  }
  if (title.contains('眼部') || title.contains('眼')) return 'care.eye';
  if (title.contains('皮肤褶皱') || title.contains('褶皱')) {
    return 'breed.brachycephalic';
  }

  // ─── 生命阶段 ────────────────────────────────────────────────────────────
  if (id.contains('puppy') || title.contains('幼犬')) {
    return 'life_stage.puppy';
  }
  if (id.contains('senior') || title.contains('老年') || title.contains('高龄')) {
    return 'life_stage.senior';
  }
  if (id.contains('geriatric')) return 'life_stage.senior';
  if (tip.category == 'life_stage') return 'health_dynamics.life_stage';

  // ─── 季节性：按具体主题 ID 精确匹配 ────────────────────────────────────
  if (id.contains('deworm') || id.contains('parasite') || title.contains('驱虫')) {
    return 'reminder.deworming';
  }
  if (id.contains('vaccine') || title.contains('疫苗')) return 'reminder.vaccine';
  if (id.contains('shedding') || title.contains('换毛')) return 'care.combing';
  if (id.contains('allergy') || title.contains('过敏')) return 'record.symptom';
  if (id.contains('mating') || title.contains('发情')) {
    return 'health_dynamics.life_stage';
  }
  if (id.contains('heat') || title.contains('防暑') || title.contains('高温')) {
    return 'season.summer';
  }
  if (id.contains('water') && id.contains('summer')) return 'season.summer';
  if (id.contains('food') && id.contains('summer')) return 'season.summer';
  if (id.contains('walk') || title.contains('遛狗')) return 'care.paw';
  if (id.contains('brachy') || title.contains('短鼻')) {
    return 'breed.brachycephalic';
  }
  if (id.contains('appetite') || title.contains('食欲')) return 'record.food';
  if (id.contains('disease') || title.contains('传染病')) {
    return 'reminder.vaccine';
  }
  if (id.contains('temp') || title.contains('温差') || title.contains('感冒')) {
    return 'season.autumn';
  }
  if (id.contains('warmth') || title.contains('保暖')) return 'season.winter';
  if (id.contains('joint') || title.contains('关节')) return 'breed.large';
  if (id.contains('bath') || title.contains('洗澡')) return 'care.bath';
  if (id.contains('exercise') || title.contains('运动')) {
    return 'health_dynamics.life_stage';
  }
  if (id.contains('skin') || title.contains('皮肤') || title.contains('干燥')) {
    return 'record.symptom';
  }
  if (id.contains('spring')) return 'season.spring';
  if (id.contains('summer')) return 'season.summer';
  if (id.contains('autumn')) return 'season.autumn';
  if (id.contains('winter')) return 'season.winter';

  // ─── 通用关键词匹配（按 ID + 标题）───────────────────────────────────────
  if (id.contains('water') || title.contains('饮水')) return 'record.water';
  if (id.contains('weight') || title.contains('体重')) {
    return 'health_dynamics.weight_change';
  }
  if (id.contains('digestive') || title.contains('消化') || title.contains('食欲')) {
    return 'health_dynamics.digestive';
  }

  // ─── 护理类型 ────────────────────────────────────────────────────────────
  if (title.contains('口腔') || title.contains('牙')) return 'care.oral';
  if (title.contains('耳')) return 'care.ear';
  if (title.contains('梳毛') || title.contains('换毛')) return 'care.combing';
  if (title.contains('指甲') || title.contains('修甲')) return 'care.nail';
  if (title.contains('眼')) return 'care.eye';
  if (title.contains('足') || title.contains('爪') || title.contains('遛狗')) {
    return 'care.paw';
  }
  if (title.contains('洗澡')) return 'care.bath';

  // ─── 季节类型兜底（使用当前季节）──────────────────────────────────────────
  if (tip.category == 'seasonal') return _currentSeasonKey();

  return 'health_dynamics.general';
}

/// 根据标题中的品种名匹配知识库 contextKey。
String? _matchBreedInTitle(String title) {
  if (title.contains('金毛')) return 'breed.golden_retriever';
  if (title.contains('拉布拉多')) return 'breed.golden_retriever';
  if (title.contains('贵宾') || title.contains('泰迪')) return 'breed.poodle';
  if (title.contains('边牧') || title.contains('边境')) return 'breed.border_collie';
  if (title.contains('腊肠')) return 'breed.dachshund';
  if (title.contains('哈士奇')) return 'breed.husky';
  if (title.contains('法斗') || title.contains('法国斗牛') || title.contains('巴哥')) {
    return 'breed.brachycephalic';
  }
  return null;
}

/// 返回当前月份对应的季节 contextKey。
String _currentSeasonKey() {
  final month = DateTime.now().month;
  if (month >= 3 && month <= 5) return 'season.spring';
  if (month >= 6 && month <= 8) return 'season.summer';
  if (month >= 9 && month <= 11) return 'season.autumn';
  return 'season.winter';
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
