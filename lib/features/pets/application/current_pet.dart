import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/data/preferences_repository.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';

/// 当前选中的狗狗；选中的不存在时用最早建的那只，一只都没有时为 `null`。
final currentPetProvider = Provider<Pet?>((ref) {
  final selectedId = ref.watch(appPreferencesProvider).value?.selectedPetId;
  final pets = ref.watch(allPetsProvider).value ?? const <Pet>[];
  return pets.where((pet) => pet.id == selectedId).firstOrNull ??
      pets.firstOrNull;
});
