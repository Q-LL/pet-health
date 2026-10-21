import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/pets/data/pets_repository.dart';
import '../features/pets/presentation/pet_page.dart';
import '../features/plans/presentation/plans_page.dart';
import '../features/timeline/presentation/timeline_page.dart';
import '../features/today/presentation/today_page.dart';
import 'shell.dart';

abstract final class Routes {
  static const welcome = '/welcome';
  static const today = '/today';
  static const timeline = '/timeline';
  static const plans = '/plans';
  static const pet = '/pet';
}

final routerProvider = Provider<GoRouter>((ref) {
  // 狗狗列表变化时重新判断要不要进引导页。
  final petsChanged = ValueNotifier(0);
  ref.listen(allPetsProvider, (_, _) => petsChanged.value++);

  final router = GoRouter(
    initialLocation: Routes.today,
    refreshListenable: petsChanged,
    redirect: (context, state) {
      final pets = ref.read(allPetsProvider);
      if (!pets.hasValue) return null;
      final hasPet = pets.requireValue.isNotEmpty;
      final atWelcome = state.matchedLocation == Routes.welcome;
      if (!hasPet && !atWelcome) return Routes.welcome;
      if (hasPet && atWelcome) return Routes.today;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.today,
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.timeline,
                builder: (context, state) => const TimelinePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.plans,
                builder: (context, state) => const PlansPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.pet,
                builder: (context, state) => const PetPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    petsChanged.dispose();
  });
  return router;
});
