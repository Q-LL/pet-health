import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../data/pet_repository.dart';

/// Whether at least one real (non-placeholder) dog profile exists. Stays
/// `true` while profiles load so pages do not flash the empty state.
final hasRealPetProvider = Provider<bool>((ref) {
  final pets = ref.watch(petsProvider).value;
  return pets == null || pets.any((pet) => !pet.isPlaceholder);
});

/// Shown by tabs whose content belongs to a dog profile before one exists.
class NoPetProfileView extends StatelessWidget {
  const NoPetProfileView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.pets_rounded,
      title: '先创建狗狗档案',
      message: message,
      action: FilledButton.icon(
        onPressed: () => context.go('/pet'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('创建档案'),
      ),
    );
  }
}
