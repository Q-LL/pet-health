import 'package:flutter/material.dart';

import '../../../core/widgets/page_frame.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: '宠物',
      subtitle: '每只宠物都有独立、连续的健康履历。',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                child: const Icon(Icons.pets_rounded, size: 38),
              ),
              const SizedBox(height: 18),
              Text('添加第一只宠物', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                '记录名字、品种、生日，以及需要长期关注的信息。',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('创建宠物档案'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
