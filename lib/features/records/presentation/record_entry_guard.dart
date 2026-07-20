import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pets/data/pet_repository.dart';

/// Ensures record-like actions always belong to a real, visible dog profile.
Future<bool> requireRealPetProfile(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    final realPetCount = await container.read(petRepositoryProvider).count();
    if (realPetCount > 0) return true;
  } catch (error) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('暂时无法读取狗狗档案：$error')));
    return false;
  }

  if (!context.mounted) return false;
  final createProfile = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.pets_rounded),
      title: const Text('先创建狗狗档案'),
      content: const Text('每条健康和护理记录都需要归属到一只真实狗狗。创建档案后再开始记录。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('暂不创建'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(dialogContext, true),
          icon: const Icon(Icons.add_rounded),
          label: const Text('创建档案'),
        ),
      ],
    ),
  );
  if (createProfile == true && context.mounted) {
    context.go('/pets');
  }
  return false;
}
