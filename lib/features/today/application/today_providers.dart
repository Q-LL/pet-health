import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../entries/data/entries_repository.dart';
import '../../entries/domain/entry.dart';
import '../../pets/application/current_pet.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';

/// 今天零点（本地时间）。
// TODO: 跨过零点时还不会自动刷新，回到前台时由页面重新读取。
final todayProvider = Provider<DateTime>((ref) {
  final now = ref.watch(clockProvider)();
  return DateTime(now.year, now.month, now.day);
});

/// 当前狗狗的习惯预设。
final currentPresetsProvider = StreamProvider.autoDispose<PetPresets?>((ref) {
  final pet = ref.watch(currentPetProvider);
  if (pet == null) return Stream.value(null);
  return ref.watch(petsRepositoryProvider).watchPresets(pet.id);
});

/// 当前狗狗今天的记录，按时间倒序。
final todayEntriesProvider = StreamProvider.autoDispose<List<Entry>>((ref) {
  final pet = ref.watch(currentPetProvider);
  if (pet == null) return Stream.value(const []);
  final today = ref.watch(todayProvider);
  return ref
      .watch(entriesRepositoryProvider)
      .watchForPet(
        pet.id,
        from: today,
        to: DateTime(today.year, today.month, today.day + 1),
      );
});

/// 当前狗狗正在进行的遛狗。
final activeWalkProvider = StreamProvider.autoDispose<Entry?>((ref) {
  final pet = ref.watch(currentPetProvider);
  if (pet == null) return Stream.value(null);
  return ref.watch(entriesRepositoryProvider).watchActiveWalk(pet.id);
});
