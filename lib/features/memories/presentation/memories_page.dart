import 'package:flutter/material.dart';

/// 爱宠时光 —— 以时间线形式记录宠物的成长历程。
///
/// 当前为 UI 占位框架，具体数据层和 EXIF 读取逻辑待后续迭代接入。
class MemoriesTab extends StatelessWidget {
  const MemoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MemoriesHeader(),
              SizedBox(height: 24),
              _GrowthTimeline(),
              SizedBox(height: 24),
              _HowItWorks(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 顶部引导区域：简要说明 + 导入按钮。
class _MemoriesHeader extends StatelessWidget {
  const _MemoriesHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.auto_awesome_outlined,
              color: colors.onTertiaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '记录狗狗的成长瞬间',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '图片导入接入中，稍后会按时间整理成属于它的成长故事。',
                  style: TextStyle(
                    color: colors.onTertiaryContainer.withValues(alpha: .8),
                    height: 1.35,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: '图片导入功能接入中',
            child: FilledButton.tonalIcon(
              onPressed: null,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('导入'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 成长时间线：用竖向线条连接各个时间节点，展示宠物成长轨迹。
class _GrowthTimeline extends StatelessWidget {
  const _GrowthTimeline();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // 示例时间节点（占位数据，后续接入真实数据）
    final milestones = [
      _Milestone(
        date: '2026 年 1 月',
        title: '来到家里',
        description: '第一次见面的日子，从此开始一起生活。',
        icon: Icons.home_outlined,
      ),
      _Milestone(
        date: '2026 年 3 月',
        title: '第一次体检',
        description: '完成了第一次全面体检和疫苗接种。',
        icon: Icons.medical_services_outlined,
      ),
      _Milestone(
        date: '2026 年 6 月',
        title: '开始记录',
        description: '开始在毛健康里记录每一天的小变化。',
        icon: Icons.edit_note_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '成长时间线',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        // 空状态 + 时间线预览
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < milestones.length; i++) ...[
                _TimelineNode(
                  milestone: milestones[i],
                  isLast: i == milestones.length - 1,
                  isFirst: i == 0,
                ),
                if (i < milestones.length - 1)
                  _TimelineConnector(color: colors.primary),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 提示：这是示例数据
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.secondaryContainer.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: colors.onSecondaryContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '以上为示例展示，图片导入功能接入后即可记录真实的成长时间线。',
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 时间线节点。
class _TimelineNode extends StatelessWidget {
  const _TimelineNode({
    required this.milestone,
    required this.isLast,
    required this.isFirst,
  });

  final _Milestone milestone;
  final bool isLast;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：节点圆点
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFirst ? colors.primary : colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                milestone.icon,
                size: 20,
                color: isFirst ? colors.onPrimary : colors.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // 右侧：内容
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.date,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.description,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 时间线连接线。
class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // 与节点圆点对齐（40px 宽度的中心线）
          SizedBox(
            width: 40,
            child: Center(
              child: Container(
                width: 2,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 说明卡片：介绍狗狗时光的工作方式。
class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final steps = [
      (Icons.photo_library_outlined, '选择照片', '从相册选择一张或多张狗狗照片'),
      (Icons.access_time_rounded, '读取时间', '本地读取拍摄时间，不上传原图'),
      (Icons.fact_check_outlined, '确认草稿', '逐张确认狗狗、修改日期和描述'),
      (Icons.timeline_rounded, '保存时间线', '写入成长时间线，随时可以编辑'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: colors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '工作方式',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    steps[i].$1,
                    size: 16,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].$2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        steps[i].$3,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Milestone {
  const _Milestone({
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String date;
  final String title;
  final String description;
  final IconData icon;
}
