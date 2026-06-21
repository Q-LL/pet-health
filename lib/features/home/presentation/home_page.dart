import 'package:flutter/material.dart';

import '../../../core/widgets/motion.dart';
import '../../../core/widgets/page_frame.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '毛健康',
      subtitle: '把每一天的小变化，留成安心的健康履历。',
      actions: [
        IconButton.filledTonal(
          tooltip: '通知',
          onPressed: () {},
          icon: const Badge(child: Icon(Icons.notifications_none_rounded)),
        ),
        const SizedBox(width: 12),
      ],
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EntranceAnimation(child: _WelcomeHero()),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 70),
            child: SectionHeader('快速记录'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 100),
            child: _QuickActions(),
          ),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 140),
            child: SectionHeader('今天', action: '全部提醒'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 170),
            child: _TodayCard(),
          ),
          SizedBox(height: 28),
          EntranceAnimation(
            delay: Duration(milliseconds: 210),
            child: SectionHeader('健康动态', action: '查看时间线'),
          ),
          EntranceAnimation(
            delay: Duration(milliseconds: 240),
            child: _ActivityCard(),
          ),
          SizedBox(height: 16),
          EntranceAnimation(
            delay: Duration(milliseconds: 280),
            child: _InsightCard(),
          ),
        ],
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -48,
            child: _SoftCircle(size: 154, color: colors.onTertiaryContainer),
          ),
          Positioned(
            right: 62,
            bottom: -50,
            child: _SoftCircle(size: 104, color: colors.onPrimaryContainer),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: .75),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pets_rounded,
                        color: colors.primary,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      avatar: const Icon(Icons.lock_outline_rounded, size: 16),
                      label: const Text('仅存本机'),
                      backgroundColor: colors.surface.withValues(alpha: .7),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  '从认识毛孩子开始',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '创建第一份宠物档案，体重、提醒和每次就诊都会有迹可循。',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('创建档案'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(onPressed: () {}, child: const Text('稍后再说')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .055),
      shape: BoxShape.circle,
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final actions = [
      (
        Icons.monitor_weight_outlined,
        '体重',
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      (
        Icons.restaurant_rounded,
        '饮食',
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      (
        Icons.medication_outlined,
        '用药',
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      (
        Icons.healing_outlined,
        '症状',
        colors.errorContainer,
        colors.onErrorContainer,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 2 : 4,
            mainAxisExtent: 104,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return PressableScale(
              child: Material(
                color: action.$3,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(action.$1, color: action.$4, size: 26),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                action.$2,
                                style: TextStyle(
                                  color: action.$4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(Icons.add_rounded, color: action.$4, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PressableScale(
      child: Card(
        color: colors.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今天轻轻松松',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('暂时没有待完成的提醒'),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: '新增提醒',
                onPressed: () {},
                icon: const Icon(Icons.add_alarm_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.auto_graph_rounded, color: colors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '记录越连续，变化越清晰',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                for (var index = 0; index < 7; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: AppMotion.medium,
                          height: index == 6 ? 38 : 8,
                          decoration: BoxDecoration(
                            color: index == 6
                                ? colors.primary
                                : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ['一', '二', '三', '四', '五', '六', '日'][index],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '完成第一条记录，开启本周健康时间线',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '本地趋势提示',
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '毛健康只和宠物自己的历史比较，并清楚说明每条提示为什么出现。',
                  style: TextStyle(
                    color: colors.onSecondaryContainer,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
