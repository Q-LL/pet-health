import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/navigation/popup_route_visibility.dart';
import '../features/calendar/presentation/calendar_page.dart';
import '../features/care/presentation/care_coverage_page.dart';
import '../features/care/presentation/care_plans_page.dart';
import '../features/health_tips/presentation/health_dynamics_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/knowledge/presentation/knowledge_page.dart';
import '../features/pets/presentation/pets_page.dart';
import '../features/records/presentation/add_record_sheet.dart';
import '../features/records/presentation/records_history_page.dart';
import '../features/reminders/presentation/reminders_page.dart';
import '../features/settings/presentation/settings_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final popupRouteVisibilityController = PopupRouteVisibilityController();
final _rootPopupObserver = PopupRouteVisibilityObserver(
  popupRouteVisibilityController,
);
final _branchPopupObservers = List<PopupRouteVisibilityObserver>.generate(
  4,
  (_) => PopupRouteVisibilityObserver(popupRouteVisibilityController),
);

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [_rootPopupObserver],
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(
        navigationShell: navigationShell,
        showRecordAction: state.uri.path == '/home',
      ),
      branches: [
        StatefulShellBranch(
          observers: [_branchPopupObservers[0]],
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, _) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'care-plans',
                  builder: (_, _) => const CarePlansPage(),
                ),
                GoRoute(
                  path: 'care-coverage',
                  builder: (_, _) => const CareCoveragePage(),
                ),
                GoRoute(
                  path: 'reminders',
                  builder: (_, _) => const RemindersPage(),
                ),
                GoRoute(
                  path: 'health-dynamics',
                  builder: (_, _) => const HealthDynamicsPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          observers: [_branchPopupObservers[1]],
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (_, _) => const CalendarPage(),
              routes: [
                GoRoute(
                  path: 'records',
                  builder: (_, _) => const RecordsHistoryPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          observers: [_branchPopupObservers[2]],
          routes: [GoRoute(path: '/pets', builder: (_, _) => const PetsPage())],
        ),
        StatefulShellBranch(
          observers: [_branchPopupObservers[3]],
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: 'knowledge',
                  builder: (_, _) => const KnowledgePage(),
                  routes: [
                    GoRoute(
                      path: ':articleId',
                      builder: (_, state) => KnowledgeArticlePage(
                        articleId: state.pathParameters['articleId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    required this.showRecordAction,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final bool showRecordAction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: popupRouteVisibilityController,
      builder: (context, _) => Scaffold(
        body: navigationShell,
        floatingActionButton:
            showRecordAction && !popupRouteVisibilityController.hasVisiblePopup
            ? FloatingActionButton.extended(
                tooltip: '新增记录',
                onPressed: () => showAddRecordSheet(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('记录'),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: '日历',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets_rounded),
              label: '狗狗',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}
