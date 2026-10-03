import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/ui/ui.dart';
import '../features/calendar/presentation/timeline_page.dart';
import '../features/care/presentation/care_page.dart';
import '../features/care/presentation/care_coverage_page.dart';
import '../features/health_tips/presentation/health_dynamics_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/knowledge/presentation/knowledge_page.dart';
import '../features/memories/presentation/memories_page.dart';
import '../features/notifications/presentation/notification_center_page.dart';
import '../features/pets/presentation/pets_page.dart';
import '../features/records/presentation/records_history_page.dart';
import '../features/records/domain/health_record_spec.dart';
import '../features/reminders/presentation/reminders_page.dart';
import '../features/settings/presentation/settings_page.dart';
import 'app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Locations from the four-tab layout, kept so notifications, saved state
/// and old links still land on the right screen.
String? legacyRedirect(Uri uri) {
  final path = uri.path;
  const exact = {
    '/home': '/today',
    '/home/reminders': '/care?seg=todo',
    '/home/care-plans': '/care?seg=plans',
    '/home/care-coverage': '/care?seg=insight',
    '/home/health-dynamics': '/care?seg=insight',
    '/home/memories': '/memories',
    '/calendar': '/timeline',
    '/calendar/records': '/records',
    '/pets': '/pet',
    '/settings/knowledge': '/knowledge',
  };
  String withQuery(String target) {
    final destination = Uri.parse(target);
    final parameters = {...uri.queryParameters, ...destination.queryParameters};
    return destination
        .replace(
          queryParameters: parameters.isEmpty ? null : parameters,
          fragment: uri.hasFragment ? uri.fragment : null,
        )
        .toString();
  }

  if (exact[path] case final target?) return withQuery(target);
  const articlePrefix = '/settings/knowledge/';
  if (path.startsWith(articlePrefix)) {
    return withQuery('/knowledge/${path.substring(articlePrefix.length)}');
  }
  return null;
}

void _returnFromPage(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/today');
  }
}

/// A full-screen page above the tab bar. [AppPage]-based screens need the
/// scaffold that the shell otherwise provides.
GoRoute _rootRoute(String path, Widget Function(GoRouterState) builder) =>
    GoRoute(
      path: path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => Scaffold(
        body: AppPageBackScope(
          onBack: () => _returnFromPage(context),
          child: builder(state),
        ),
      ),
    );

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/today',
  redirect: (_, state) => legacyRedirect(state.uri),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/today', builder: (_, _) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/timeline',
              builder: (_, state) => TimelinePage(
                filter: TimelineFilter.fromQuery(
                  state.uri.queryParameters['type'],
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/care',
              builder: (_, state) => CarePage(
                segment: CareSegment.fromQuery(
                  state.uri.queryParameters['seg'],
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/pet', builder: (_, _) => const PetsPage())],
        ),
      ],
    ),
    _rootRoute(
      '/records',
      (state) => RecordsHistoryPage(
        initialHealthType:
            healthRecordLabels.containsKey(state.uri.queryParameters['type'])
            ? state.uri.queryParameters['type']
            : null,
      ),
    ),
    _rootRoute('/reminders', (_) => const RemindersPage()),
    _rootRoute('/care/coverage', (_) => const CareCoveragePage()),
    _rootRoute('/care/dynamics', (_) => const HealthDynamicsPage()),
    GoRoute(
      path: '/memories',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('爱宠时光'),
          leading: BackButton(onPressed: () => _returnFromPage(context)),
        ),
        body: const MemoriesTab(),
      ),
    ),
    _rootRoute('/inbox', (_) => const NotificationCenterPage()),
    _rootRoute('/settings', (_) => const SettingsPage()),
    _rootRoute('/knowledge', (_) => const KnowledgePage()),
    _rootRoute(
      '/knowledge/:articleId',
      (state) =>
          KnowledgeArticlePage(articleId: state.pathParameters['articleId']!),
    ),
  ],
);
