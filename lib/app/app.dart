import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/notifications/walk_live_activity_service.dart';
import '../features/care/application/care_controller.dart';
import '../features/care/presentation/care_sheets.dart';
import 'router.dart';
import 'theme.dart';

class PetHealthApp extends ConsumerStatefulWidget {
  const PetHealthApp({super.key});

  @override
  ConsumerState<PetHealthApp> createState() => _PetHealthAppState();
}

class _PetHealthAppState extends ConsumerState<PetHealthApp>
    with WidgetsBindingObserver {
  var _showingWalkFinishSheet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPendingLiveActivityWalkFinishSheet();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _showPendingLiveActivityWalkFinishSheet();
    }
  }

  Future<void> _showPendingLiveActivityWalkFinishSheet() async {
    if (_showingWalkFinishSheet || !mounted) return;
    final pending = await walkLiveActivityService.getPendingFinish();
    if (pending == null || !mounted) return;

    final activeWalkStartedAt = ref.read(
      careControllerProvider.select((state) => state.activeWalkStartedAt),
    );
    if (activeWalkStartedAt == null ||
        !_isSameWalkStart(pending.startedAt, activeWalkStartedAt)) {
      await walkLiveActivityService.clearPendingFinish();
      return;
    }

    _showingWalkFinishSheet = true;
    appRouter.go('/home');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = rootNavigatorKey.currentContext;
      if (!mounted || context == null) {
        _showingWalkFinishSheet = false;
        return;
      }
      final saved = await showFinishWalkSheet(
        context,
        endedAt: pending.endedAt,
      );
      if (saved == true) {
        await walkLiveActivityService.clearPendingFinish();
      }
      _showingWalkFinishSheet = false;
    });
  }

  bool _isSameWalkStart(DateTime pending, DateTime active) {
    final deltaSeconds = pending
        .toUtc()
        .difference(active.toUtc())
        .inSeconds
        .abs();
    return deltaSeconds <= 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '毛健康',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
