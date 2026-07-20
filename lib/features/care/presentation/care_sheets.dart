import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../application/care_controller.dart';
import '../application/care_plan_controller.dart';
import '../domain/care_models.dart';

Future<void> showBathRecordSheet(BuildContext context) {
  return showCareActivitySheet(context, type: 'bath');
}

/// Stops the timer first, then offers optional details for the saved walk.
///
/// Dismissing the sheet never resumes the timer: ending a walk is a single,
/// immediate action while place and notes are progressive enhancement.
Future<WalkRecord?> showFinishWalkSheet(
  BuildContext context, {
  DateTime? endedAt,
  DateTime? expectedStartedAt,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  late final WalkRecord? record;
  try {
    record = await container
        .read(careControllerProvider.notifier)
        .finishWalk(at: endedAt, expectedStartedAt: expectedStartedAt);
  } on Object catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('结束遛狗失败：$error')));
    }
    return null;
  }
  if (record == null || !context.mounted) return record;

  await showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => _FinishWalkSheet(parentContext: context, record: record!),
  );
  return record;
}

class _FinishWalkSheet extends ConsumerStatefulWidget {
  const _FinishWalkSheet({required this.parentContext, required this.record});

  final BuildContext parentContext;
  final WalkRecord record;

  @override
  ConsumerState<_FinishWalkSheet> createState() => _FinishWalkSheetState();
}

class _FinishWalkSheetState extends ConsumerState<_FinishWalkSheet> {
  final _placeController = TextEditingController();
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _placeController.text = widget.record.place;
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(careControllerProvider.notifier)
          .updateWalkDetails(widget.record, place: _placeController.text);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('补充遛狗信息失败：$error')));
        setState(() => _saving = false);
      }
      return;
    }

    final planState = ref.read(carePlanControllerProvider);
    final pawPlan = planState.enabledPlans['paw_after_walk'];
    if (mounted) Navigator.pop(context, true);

    if (pawPlan != null && !pawPlan.paused) {
      await Future<void>.delayed(Duration.zero);
      if (!widget.parentContext.mounted) return;
      _showPawCheckDialog(widget.parentContext, pawPlan.candidateId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: '遛狗已结束',
      subtitle:
          '计时已经停止，本次遛了 ${formatDuration(widget.record.duration)}。地点可以现在补充，也可以稍后在记录中编辑。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _placeController,
            autofocus: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _saveDetails(),
            decoration: const InputDecoration(
              labelText: '遛狗场所（可选）',
              hintText: '例如：滨江公园、小区花园',
              prefixIcon: Icon(Icons.park_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.route_outlined),
                SizedBox(width: 10),
                Expanded(child: Text('GPS 路线将在后续版本作为可选功能加入')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saving ? null : _saveDetails,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? '保存中…' : '保存补充信息'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: const Text('稍后填写'),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}

void _showPawCheckDialog(BuildContext context, String pawCandidateId) {
  showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('检查足爪'),
      content: const Text('遛狗结束啦，是否现在检查一下足爪？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('稍后再说'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('检查足爪'),
        ),
      ],
    ),
  ).then((confirmed) async {
    if (confirmed != true || !context.mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    await showCareActivitySheet(
      context,
      type: 'paw',
      beforeSave: (draft) async {
        await container
            .read(carePlanControllerProvider.notifier)
            .logCompletionWithActivity(pawCandidateId, activityDraft: draft);
        return null;
      },
    );
  });
}
