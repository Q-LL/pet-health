import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pets/application/current_pet.dart';
import '../data/plans_repository.dart';
import '../domain/plan.dart';

/// 当前狗狗全部计划此刻的状态，排序见 [PlansRepository.statusesFor]。
final currentPlanStatusesProvider =
    StreamProvider.autoDispose<List<PlanStatus>>((ref) {
      final pet = ref.watch(currentPetProvider);
      if (pet == null) return Stream.value(const []);
      return ref.watch(plansRepositoryProvider).watchStatuses(pet.id);
    });
