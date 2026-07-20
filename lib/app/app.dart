import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/files/image_file_picker.dart';
import '../core/notifications/notification_service.dart';
import '../core/notifications/walk_live_activity_service.dart';
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
  StreamSubscription<NotificationResponse>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationSubscription = notificationService.responses.listen(
      _handleNotificationResponse,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recoverLostAvatarSelection();
      _handleNotificationLaunch();
      _showPendingLiveActivityWalkFinishSheet();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
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
    await _stopWalkAndPromptForDetails(
      endedAt: pending.endedAt,
      expectedStartedAt: pending.startedAt,
    );
    await walkLiveActivityService.clearPendingFinish();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload == walkFinishPayload ||
        response.actionId == walkFinishActionId) {
      _stopWalkAndPromptForDetails();
    }
  }

  Future<void> _handleNotificationLaunch() async {
    final details = await notificationService.getLaunchDetails();
    final response = details?.notificationResponse;
    if (response != null && mounted) _handleNotificationResponse(response);
  }

  Future<void> _stopWalkAndPromptForDetails({
    DateTime? endedAt,
    DateTime? expectedStartedAt,
  }) async {
    if (_showingWalkFinishSheet || !mounted) return;
    _showingWalkFinishSheet = true;
    appRouter.go('/home');
    await Future<void>.delayed(Duration.zero);
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      await showFinishWalkSheet(
        context,
        endedAt: endedAt,
        expectedStartedAt: expectedStartedAt,
      );
    }
    _showingWalkFinishSheet = false;
  }

  Future<void> _recoverLostAvatarSelection() async {
    try {
      final recovered = await recoverLostPetPhotoSelection();
      if (!recovered || !mounted) return;
      final context = rootNavigatorKey.currentContext;
      if (context == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已找回上次选择的头像；编辑狗狗档案并再次点头像即可继续。')),
      );
    } on Object catch (error) {
      if (!mounted) return;
      final context = rootNavigatorKey.currentContext;
      if (context == null || !context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('恢复上次选择的头像失败：$error')));
    }
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
