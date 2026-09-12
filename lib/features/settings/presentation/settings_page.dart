import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/page_frame.dart';
import '../../memories/data/memory_repository.dart';
import '../data/app_settings_repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickActions = ref.watch(quickActionIdsProvider);
    return PageFrame(
      title: '设置',
      subtitle: '管理知识、数据和隐私。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PrivacyBanner(),
          const SizedBox(height: 26),
          const SectionHeader('首页'),
          _SettingsGroup(
            children: [
              _SettingsTile(
                Icons.tune_rounded,
                '首页快速记录',
                quickActions.when(
                  data: (ids) => ids
                      .map(
                        (id) => quickActionOptions
                            .firstWhere((option) => option.id == id)
                            .label,
                      )
                      .join('、'),
                  loading: () => '正在读取配置',
                  error: (_, _) => '点击重新设置',
                ),
                onTap: () => _showQuickActionSheet(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
              _MemoryCacheTile(),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader('知识与隐私'),
          _SettingsGroup(
            children: [
              _SettingsTile(
                Icons.menu_book_outlined,
                '本地知识库',
                '离线查看观察、记录、护理和就医准备',
                onTap: () => context.push('/settings/knowledge'),
              ),
              const _SettingsTile(
                Icons.shield_outlined,
                '权限与隐私',
                '数据默认保存在当前设备',
              ),
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

class _MemoryCacheTile extends ConsumerStatefulWidget {
  const _MemoryCacheTile();

  @override
  ConsumerState<_MemoryCacheTile> createState() => _MemoryCacheTileState();
}

class _MemoryCacheTileState extends ConsumerState<_MemoryCacheTile> {
  late Future<int> _usage;

  @override
  void initState() {
    super.initState();
    _usage = _readUsage();
  }

  Future<int> _readUsage() {
    return ref.read(albumAssetServiceProvider).cacheUsageBytes();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: const Icon(Icons.photo_library_outlined),
      title: const Text('爱宠时光缓存'),
      subtitle: FutureBuilder<int>(
        future: _usage,
        builder: (context, snapshot) => Text(
          snapshot.hasData
              ? '缩略图占用 ${_formatBytes(snapshot.data!)}，上限 100 MB'
              : '正在计算缩略图缓存',
        ),
      ),
      trailing: const Icon(Icons.cleaning_services_outlined),
      onTap: _clear,
    );
  }

  Future<void> _clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除爱宠时光缓存？'),
        content: const Text('只清除可重新生成的缩略图，不会删除日志或系统相册中的媒体。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(albumAssetServiceProvider).clearCache();
    if (!mounted) return;
    setState(() => _usage = _readUsage());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('爱宠时光缓存已清除')));
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
  const _SettingsTile(this.icon, this.title, this.subtitle, {this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

Future<void> _showQuickActionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _QuickActionSheet(),
  );
}

class _QuickActionSheet extends ConsumerStatefulWidget {
  const _QuickActionSheet();

  @override
  ConsumerState<_QuickActionSheet> createState() => _QuickActionSheetState();
}

class _QuickActionSheetState extends ConsumerState<_QuickActionSheet> {
  late Set<String> _selected;
  var _initialized = false;
  var _saving = false;

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(quickActionIdsProvider);
    if (!_initialized && current.hasValue) {
      _selected = current.value!.toSet();
      _initialized = true;
    } else if (!_initialized) {
      _selected = defaultQuickActionIds.toSet();
      _initialized = true;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('首页快速记录', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '选择 3 个自定义入口；“更多记录”会固定显示在第 4 个位置。',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _QuickActionOptionGroup(
            title: '健康',
            options: quickActionOptions
                .where((option) => option.kind == 'health')
                .toList(),
            selected: _selected,
            onChanged: _toggle,
          ),
          const SizedBox(height: 18),
          _QuickActionOptionGroup(
            title: '护理',
            options: quickActionOptions
                .where((option) => option.kind == 'care')
                .toList(),
            selected: _selected,
            onChanged: _toggle,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _saving || _selected.length != 3 ? null : _save,
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              _selected.length == 3 ? '保存' : '还需选择 ${3 - _selected.length} 个',
            ),
          ),
        ],
      ),
    );
  }

  void _toggle(String id, bool selected) {
    setState(() {
      if (selected) {
        if (_selected.length < 3) _selected.add(id);
      } else {
        _selected.remove(id);
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(appSettingsRepositoryProvider)
          .saveQuickActionIds(_selected.toList());
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error is FormatException ? error.message : '保存失败'),
        ),
      );
    }
  }
}

class _QuickActionOptionGroup extends StatelessWidget {
  const _QuickActionOptionGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<QuickActionOption> options;
  final Set<String> selected;
  final void Function(String id, bool selected) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(option.label),
                selected: selected.contains(option.id),
                onSelected: (value) => onChanged(option.id, value),
              ),
          ],
        ),
      ],
    );
  }
}
