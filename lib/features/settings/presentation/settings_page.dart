import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '设置',
      subtitle: '管理知识、数据和隐私。',
      child: Card(
        child: Column(
          children: const [
            _SettingsTile(Icons.menu_book_outlined, '本地知识库', '离线搜索护理与药品基础信息'),
            Divider(height: 1, indent: 64),
            _SettingsTile(
              Icons.description_outlined,
              '健康摘要与导出',
              '整理就诊时需要的健康履历',
            ),
            Divider(height: 1, indent: 64),
            _SettingsTile(
              Icons.cloud_download_outlined,
              '备份与恢复',
              '完整保存记录和照片附件',
            ),
            Divider(height: 1, indent: 64),
            _SettingsTile(Icons.shield_outlined, '权限与隐私', '数据默认保存在当前设备'),
          ],
        ),
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
