import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/calendar_page.dart';
import '../features/care/presentation/care_coverage_page.dart';
import '../features/care/presentation/care_plans_page.dart';
import '../features/health_tips/presentation/health_dynamics_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/knowledge/presentation/knowledge_page.dart';
import '../features/notifications/presentation/notification_center_page.dart';
import '../features/pets/presentation/pets_page.dart';
import '../features/records/presentation/add_record_sheet.dart';
import '../features/records/presentation/records_history_page.dart';
import '../features/reminders/presentation/reminders_page.dart';
import '../features/settings/presentation/settings_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
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
                  path: 'notifications',
                  builder: (_, _) => const NotificationCenterPage(),
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
          routes: [GoRoute(path: '/pets', builder: (_, _) => const PetsPage())],
        ),
        StatefulShellBranch(
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
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = navigationShell.currentIndex >= 2
        ? navigationShell.currentIndex + 1
        : navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            showAddRecordSheet(context);
            return;
          }
          final branchIndex = index > 2 ? index - 1 : index;
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
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
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: '记录',
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
    );
  }
}
