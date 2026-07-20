import 'package:flutter/material.dart';

/// Honest empty state for the future dog memories timeline.
///
/// Photo import and milestone persistence are not implemented yet, so this
/// surface intentionally renders no sample events or plausible user data.
class MemoriesTab extends StatelessWidget {
  const MemoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 30),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colors.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    size: 40,
                    color: colors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '还没有成长时光',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  '照片导入和成长事件还没有接入。这里暂时保持为空，不会用示例内容代替狗狗的真实经历。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 24),
                const _FutureCapability(
                  icon: Icons.verified_outlined,
                  text: '以后只展示真实记录和你主动导入的照片',
                ),
                const SizedBox(height: 10),
                const _FutureCapability(
                  icon: Icons.lock_outline_rounded,
                  text: '图片与时间信息仍只保存在本机',
                ),
                const SizedBox(height: 24),
                FilledButton.tonalIcon(
                  onPressed: null,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('照片导入尚未开放'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FutureCapability extends StatelessWidget {
  const _FutureCapability({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 19, color: colors.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
