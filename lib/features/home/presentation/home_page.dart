import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PageFrame(
      title: '早上好',
      subtitle: '今天也一起照顾好毛孩子。',
      actions: [
        IconButton(
          tooltip: '通知',
          onPressed: () {},
          icon: const Badge(child: Icon(Icons.notifications_outlined)),
        ),
        const SizedBox(width: 8),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: colors.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colors.onPrimaryContainer.withValues(
                      alpha: .1,
                    ),
                    child: const Icon(Icons.pets_rounded, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '先创建宠物档案',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('添加基本信息，开始记录长期健康变化'),
                      ],
                    ),
                  ),
                  FilledButton.tonal(onPressed: () {}, child: const Text('创建')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader('今日提醒', action: '查看全部'),
          const _EmptyCard(
            icon: Icons.task_alt_rounded,
            title: '今天没有待办',
            message: '新增用药、疫苗或复诊提醒后，会显示在这里。',
          ),
          const SizedBox(height: 22),
          const SectionHeader('快速记录'),
          const _QuickActions(),
          const SizedBox(height: 22),
          const SectionHeader('最近记录', action: '时间线'),
          const _EmptyCard(
            icon: Icons.history_rounded,
            title: '还没有健康记录',
            message: '从体重或日常观察开始，几秒钟就能完成。',
          ),
          const SizedBox(height: 22),
          const SectionHeader('趋势提示'),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              leading: Icon(Icons.insights_rounded, color: colors.primary),
              title: const Text('记录一段时间后生成趋势'),
              subtitle: const Text('所有分析都在设备本地完成，并会说明触发原因。'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.monitor_weight_outlined, '体重'),
      (Icons.restaurant_outlined, '饮食'),
      (Icons.medication_outlined, '用药'),
      (Icons.healing_outlined, '症状'),
    ];
    return Row(
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(actions[index].$1),
                    const SizedBox(height: 8),
                    Text(actions[index].$2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 34, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
