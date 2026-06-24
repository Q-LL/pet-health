import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pet_photo_repository.dart';
import '../domain/pet_photo.dart';
import '../domain/pet_profile.dart';

final _avatarPhotoProvider = StreamProvider.autoDispose
    .family<List<PetPhoto>, String>((ref, petId) {
      return ref.watch(petPhotoRepositoryProvider).watchForPet(petId, limit: 1);
    });

final _photoBytesProvider = FutureProvider.autoDispose
    .family<Uint8List, String>((ref, photoId) {
      return ref.watch(petPhotoRepositoryProvider).readBytes(photoId);
    });

class PetPortrait extends ConsumerWidget {
  const PetPortrait({required this.pet, this.size = 84, super.key});

  final PetProfile pet;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final photos = ref.watch(_avatarPhotoProvider(pet.id));
    final photo = photos.value?.firstOrNull;

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: photo == null
              ? _PetFallbackIcon(pet: pet, iconSize: size * 0.4)
              : ref
                    .watch(_photoBytesProvider(photo.id))
                    .when(
                      loading: () => const Center(
                        child: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, _) =>
                          _PetFallbackIcon(pet: pet, iconSize: size * 0.4),
                      data: (bytes) => Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
        ),
      ),
    );
  }
}

class _PetFallbackIcon extends StatelessWidget {
  const _PetFallbackIcon({required this.pet, required this.iconSize});

  final PetProfile pet;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primaryContainer,
            colors.tertiaryContainer.withValues(alpha: .8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          pet.species == '狗' ? Icons.pets_rounded : Icons.cruelty_free_rounded,
          size: iconSize,
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
