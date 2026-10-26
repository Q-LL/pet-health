import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entries/data/entries_repository.dart';
import '../../entries/domain/entry.dart';
import '../../entries/domain/entry_groups.dart';
import '../../pets/application/current_pet.dart';

/// 时间线读取的范围：最近 [limit] 条，可以只看某一组。
typedef TimelineQuery = ({int limit, EntryGroup? group});

/// 当前狗狗的记录，按时间倒序。
final timelineEntriesProvider = StreamProvider.autoDispose
    .family<List<Entry>, TimelineQuery>((ref, query) {
      final pet = ref.watch(currentPetProvider);
      if (pet == null) return Stream.value(const []);
      return ref
          .watch(entriesRepositoryProvider)
          .watchForPet(
            pet.id,
            types: query.group?.types.toSet(),
            limit: query.limit,
          );
    });
