import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PageFrame(
      title: '宠物',
      subtitle: '每只宠物都有独立、连续的健康履历。',
      child: Container(
        decoration: BoxDecoration(
          color: colors.tertiaryContainer,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: colors.surface.withValues(alpha: .78),
                    child: Icon(
                      Icons.pets_rounded,
                      size: 42,
                      color: colors.primary,
                    ),
                  ),
                  Positioned(
                    right: -5,
                    bottom: -3,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: colors.primary,
                      child: Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '认识一下毛孩子吧',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                '先添加名字、生日和需要长期留意的信息。以后每一条记录都会准确回到它的档案里。',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('创建宠物档案'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.help_outline_rounded, size: 18),
                label: const Text('档案里会记录什么？'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
