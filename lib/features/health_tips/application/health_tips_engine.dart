import 'dart:math';

import '../domain/breed_health_risks.dart';
import '../domain/data_insight_tips.dart';
import '../domain/health_tip.dart';
import '../domain/life_stage_tips.dart';
import '../domain/seasonal_tips.dart';

/// 健康动态推荐引擎。
///
/// 纯本地计算，零网络请求。基于宠物档案、健康记录、护理数据和季节信息，
/// 由四个子生成器分别产出建议，最后合并、去重、排序，输出最终列表。
class HealthTipsEngine {
  const HealthTipsEngine();

  /// 生成建议列表，[maxTips] 控制最终输出条数（默认 4）。
  List<HealthTip> generate(HealthTipsContext ctx, {int maxTips = 4}) {
    if (ctx.pet.name.trim().isEmpty) return const [];

    final allTips = <HealthTip>[
      ..._generateSeasonal(ctx),
      ..._generateLifeStage(ctx),
      ...const DataInsightTipsGenerator().generate(ctx),
      ..._generateBreed(ctx),
    ];

    // 去重（同 id 只保留优先级更高的那条）
    final seen = <String, HealthTip>{};
    for (final tip in allTips) {
      final existing = seen[tip.id];
      if (existing == null ||
          _priorityRank(tip.priority) < _priorityRank(existing.priority)) {
        seen[tip.id] = tip;
      }
    }

    final deduped = seen.values.toList();

    // 排序：high > medium > low，同类别内按 id 稳定排序
    deduped.sort((a, b) {
      final rankCompare = _priorityRank(
        a.priority,
      ).compareTo(_priorityRank(b.priority));
      if (rankCompare != 0) return rankCompare;
      final categoryCompare = _categoryRank(
        a.category,
      ).compareTo(_categoryRank(b.category));
      if (categoryCompare != 0) return categoryCompare;
      return a.id.compareTo(b.id);
    });

    return deduped.take(maxTips).toList();
  }

  // ─── 季节性建议 ────────────────────────────────────────────────────────────

  List<HealthTip> _generateSeasonal(HealthTipsContext ctx) {
    final pool = seasonalTipsForMonth(ctx.now.month);
    final tips = <HealthTip>[];

    // 驱虫检查：最近 30 天是否有驱虫记录
    final recentDeworming = ctx.recentRecords.any((r) => r.type == 'deworming');
    final hasDewormingPlan = ctx.hasEnabledDewormingPlan;

    // 关节条件检查
    final hasJointCondition = _containsKeyword(
      ctx.pet.chronicConditions,
      _jointKeywords,
    );

    // 短鼻犬检查
    final isBrachycephalic = brachycephalicBreeds.contains(
      ctx.pet.breed?.trim(),
    );

    // 未绝育检查
    final isNotNeutered = ctx.pet.neutered == false || ctx.pet.neutered == null;

    // 第一轮：收集所有条件匹配的建议（高优先级）
    for (final template in pool) {
      final hasCondition =
          template.needsDewormingCheck ||
          template.needsBrachycephalic ||
          template.needsJointCondition ||
          template.needsNotNeutered;
      if (!hasCondition) {
        continue;
      }

      if (template.needsDewormingCheck &&
          (recentDeworming || hasDewormingPlan)) {
        continue;
      }
      if (template.needsBrachycephalic && !isBrachycephalic) {
        continue;
      }
      if (template.needsJointCondition && !hasJointCondition) {
        continue;
      }
      if (template.needsNotNeutered && !isNotNeutered) {
        continue;
      }

      tips.add(
        HealthTip(
          id: template.id,
          category: 'seasonal',
          priority: 'high',
          icon: template.icon,
          title: template.title,
          body: template.body,
          reason: _seasonalReason(ctx.now.month),
        ),
      );
    }

    // 第二轮：补充通用建议（无条件），最多凑满 2 条
    for (final template in pool) {
      if (tips.length >= 2) break;
      if (tips.any((t) => t.id == template.id)) continue;
      final hasCondition =
          template.needsDewormingCheck ||
          template.needsBrachycephalic ||
          template.needsJointCondition ||
          template.needsNotNeutered;
      if (hasCondition) continue;

      tips.add(
        HealthTip(
          id: template.id,
          category: 'seasonal',
          priority: 'medium',
          icon: template.icon,
          title: template.title,
          body: template.body,
          reason: _seasonalReason(ctx.now.month),
        ),
      );
    }

    return tips;
  }

  String _seasonalReason(int month) {
    if (month >= 3 && month <= 5) return '当前正值春季，气温回暖，是养护重点转换期。';
    if (month >= 6 && month <= 8) return '当前正值夏季，高温高湿，需特别注意防暑降温。';
    if (month >= 9 && month <= 11) return '当前正值秋季，温差变化大，需关注健康防护。';
    return '当前正值冬季，气温低，保暖和室内活动是重点。';
  }

  // ─── 生命阶段建议 ──────────────────────────────────────────────────────────

  List<HealthTip> _generateLifeStage(HealthTipsContext ctx) {
    final birthday = ctx.pet.birthday;
    if (birthday == null) return const [];

    final ageInYears = ctx.now.difference(birthday).inDays / 365.25;
    if (ageInYears < 0) return const [];

    final isLarge = _isLargeBreed(ctx.pet.species, ctx.pet.breed);
    final stage = computeLifeStage(ageInYears, isLargeBreed: isLarge);
    final stageTips = tipsForStage(stage);

    if (stageTips.isEmpty) return const [];

    // 随机选一条（基于日期 seed 保证同一天展示同一条）
    final daySeed = ctx.now.year * 10000 + ctx.now.month * 100 + ctx.now.day;
    final rng = Random(daySeed);
    final index = rng.nextInt(stageTips.length);
    final tip = stageTips[index];

    final stageLabel = lifeStageLabels[stage] ?? '当前阶段';
    final ageLabel = ageInYears < 1
        ? '${(ageInYears * 12).toInt()} 个月'
        : '${ageInYears.toStringAsFixed(1)} 岁';

    return [
      HealthTip(
        id: tip.id,
        category: 'life_stage',
        priority:
            stage == DogLifeStage.senior || stage == DogLifeStage.geriatric
            ? 'high'
            : 'medium',
        icon: tip.icon,
        title: tip.title,
        body: tip.body,
        reason: '${ctx.pet.name} 目前 $ageLabel，处于$stageLabel。${tip.reason}',
      ),
    ];
  }

  // ─── 品种特定建议 ──────────────────────────────────────────────────────────

  List<HealthTip> _generateBreed(HealthTipsContext ctx) {
    final breed = ctx.pet.breed;
    final risks = risksForBreed(breed);
    if (risks.isEmpty) return const [];

    // 根据生命阶段选择不同文案
    final birthday = ctx.pet.birthday;
    final isSenior =
        birthday != null &&
        () {
          final age = ctx.now.difference(birthday).inDays / 365.25;
          final isLarge = _isLargeBreed(ctx.pet.species, breed);
          final stage = computeLifeStage(age, isLargeBreed: isLarge);
          return stage == DogLifeStage.senior ||
              stage == DogLifeStage.geriatric;
        }();

    // 基于日期 seed 选一条
    final daySeed =
        ctx.now.year * 10000 + ctx.now.month * 100 + ctx.now.day + 7;
    final rng = Random(daySeed);
    final index = rng.nextInt(risks.length);
    final risk = risks[index];

    final breedLabel = breed != null && breed.trim().isNotEmpty
        ? breed.trim()
        : '狗狗';

    return [
      HealthTip(
        id: 'breed_${risk.name.hashCode}',
        category: 'breed',
        priority: isSenior ? 'high' : 'low',
        icon: risk.icon,
        title: '$breedLabel需关注：${risk.name}',
        body: isSenior ? risk.seniorBody : risk.body,
        reason: breed != null && breed.trim().isNotEmpty
            ? '$breed犬种有特定的健康风险倾向。'
            : '所有犬种都有常见的健康风险需要关注。',
      ),
    ];
  }

  // ─── 工具方法 ──────────────────────────────────────────────────────────────

  static const _jointKeywords = {'关节', '骨骼', '髋', '膝', '脊椎', '腰椎'};

  bool _containsKeyword(String text, Set<String> keywords) {
    if (text.trim().isEmpty) return false;
    return keywords.any((kw) => text.contains(kw));
  }

  bool _isLargeBreed(String? species, String? breed) {
    // 通过 species 字段判断
    if (species != null) {
      if (species.contains('大型') || species.contains('巨型')) return true;
    }
    // 通过品种名推断常见大型犬
    if (breed != null) {
      const largeBreeds = {
        '金毛',
        '拉布拉多',
        '德国牧羊犬',
        '哈士奇',
        '阿拉斯加',
        '罗威纳',
        '杜宾',
        '萨摩耶',
        '大麦町',
        '边牧',
        '边境牧羊犬',
      };
      return largeBreeds.any((lb) => breed.contains(lb));
    }
    return false;
  }

  int _priorityRank(String priority) {
    return switch (priority) {
      'high' => 0,
      'medium' => 1,
      'low' => 2,
      _ => 3,
    };
  }

  int _categoryRank(String category) {
    return switch (category) {
      'data_insight' => 0, // 数据洞察最优先（与用户数据最相关）
      'seasonal' => 1,
      'life_stage' => 2,
      'breed' => 3,
      _ => 4,
    };
  }
}
