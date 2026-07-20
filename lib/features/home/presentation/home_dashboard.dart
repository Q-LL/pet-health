import 'package:flutter/material.dart';

/// Owns the home information hierarchy so section ordering and spacing can be
/// changed without touching the feature widgets themselves.
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    required this.hasRealPetProfile,
    required this.profileHeader,
    required this.today,
    required this.quickActions,
    required this.care,
    required this.health,
    required this.onManageReminders,
    required this.onViewHealth,
    super.key,
  });

  final bool hasRealPetProfile;
  final Widget profileHeader;
  final Widget today;
  final Widget quickActions;
  final Widget care;
  final Widget health;
  final VoidCallback onManageReminders;
  final VoidCallback onViewHealth;

  @override
  Widget build(BuildContext context) {
    if (!hasRealPetProfile) return profileHeader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        profileHeader,
        const SizedBox(height: 24),
        HomeDashboardSection(
          icon: Icons.today_outlined,
          title: '今天',
          actionLabel: '管理提醒',
          onAction: onManageReminders,
          child: today,
        ),
        const SizedBox(height: 26),
        HomeDashboardSection(
          icon: Icons.add_task_rounded,
          title: '快速记录',
          child: quickActions,
        ),
        const SizedBox(height: 26),
        HomeDashboardSection(
          icon: Icons.spa_outlined,
          title: '日常护理',
          child: care,
        ),
        const SizedBox(height: 26),
        HomeDashboardSection(
          icon: Icons.insights_outlined,
          title: '健康动态',
          actionLabel: '查看详情',
          onAction: onViewHealth,
          child: health,
        ),
      ],
    );
  }
}

class HomeDashboardSection extends StatelessWidget {
  const HomeDashboardSection({
    required this.icon,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: colors.onPrimaryContainer),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            if (actionLabel != null)
              TextButton.icon(
                onPressed: onAction,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(actionLabel!),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
