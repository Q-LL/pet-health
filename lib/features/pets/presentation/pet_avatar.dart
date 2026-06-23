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
  const PetPortrait({
    required this.pet,
    this.width = 84,
    this.height = 112,
    this.borderRadius = 24,
    this.showBadge = false,
    super.key,
  });

  final PetProfile pet;
  final double width;
  final double height;
  final double borderRadius;
  final bool showBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final photos = ref.watch(_avatarPhotoProvider(pet.id));
    final photo = photos.value?.firstOrNull;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: photo == null
                    ? _PetFallbackIcon(pet: pet)
                    : ref
                          .watch(_photoBytesProvider(photo.id))
                          .when(
                            loading: () => const Center(
                              child: SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            error: (_, _) => _PetFallbackIcon(pet: pet),
                            data: (bytes) => Image.memory(
                              bytes,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),
              ),
            ),
          ),
          if (showBadge)
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: .88),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera_rounded, size: 14),
                    const SizedBox(width: 4),
                    Text('3:4', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PetFallbackIcon extends StatelessWidget {
  const _PetFallbackIcon({required this.pet});

  final PetProfile pet;

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
      ),
      child: Center(
        child: Icon(
          pet.species == '狗' ? Icons.pets_rounded : Icons.cruelty_free_rounded,
          size: 34,
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
