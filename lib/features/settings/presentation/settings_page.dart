import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '设置',
      subtitle: '管理知识、数据和隐私。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PrivacyBanner(),
          const SizedBox(height: 26),
          const SectionHeader('数据与协作'),
          const _SettingsGroup(
            children: [
              _SettingsTile(
                Icons.description_outlined,
                '健康摘要与导出',
                '整理就诊时需要的健康履历',
              ),
              _SettingsTile(
                Icons.cloud_download_outlined,
                '备份与恢复',
                '完整保存记录和照片附件',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader('知识与隐私'),
          const _SettingsGroup(
            children: [
              _SettingsTile(Icons.menu_book_outlined, '本地知识库', '离线搜索护理与药品基础信息'),
              _SettingsTile(Icons.shield_outlined, '权限与隐私', '数据默认保存在当前设备'),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '毛健康 · 数据属于你和毛孩子',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_rounded, color: colors.primary),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '离线优先',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('健康记录默认只保存在这台设备。'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1)
              const Divider(height: 1, indent: 66),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
