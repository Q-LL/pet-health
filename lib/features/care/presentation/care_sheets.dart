import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../records/presentation/add_record_sheet.dart';
import '../application/care_controller.dart';
import '../application/care_plan_controller.dart';

Future<void> showBathRecordSheet(BuildContext context) {
  return showCareActivitySheet(context, type: 'bath');
}

Future<void> showFinishWalkSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => const _FinishWalkSheet(),
  );
}

class _FinishWalkSheet extends ConsumerStatefulWidget {
  const _FinishWalkSheet();

  @override
  ConsumerState<_FinishWalkSheet> createState() => _FinishWalkSheetState();
}

class _FinishWalkSheetState extends ConsumerState<_FinishWalkSheet> {
  final _placeController = TextEditingController();

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref
        .read(careControllerProvider.notifier)
        .finishWalk(place: _placeController.text);
    if (mounted) Navigator.pop(context);

    // 检查是否开启了 paw_after_walk 护理计划
    if (!mounted) return;
    final planState = ref.read(carePlanControllerProvider);
    final pawPlan = planState.enabledPlans['paw_after_walk'];
    if (pawPlan != null && !pawPlan.paused) {
      _showPawCheckDialog(context, ref, pawPlan.candidateId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref
        .watch(walkElapsedProvider)
        .when(
          data: (value) => value,
          error: (_, _) => Duration.zero,
          loading: () => Duration.zero,
        );
    return _SheetFrame(
      title: '结束遛狗',
      subtitle: '本次已遛 ${formatDuration(elapsed)}，补充场所后保存。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _placeController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _finish(),
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
            onPressed: _finish,
            icon: const Icon(Icons.flag_rounded),
            label: const Text('结束并保存'),
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

void _showPawCheckDialog(
  BuildContext context,
  WidgetRef ref,
  String pawCandidateId,
) {
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
    // 记录足爪护理计划完成
    try {
      await ref
          .read(carePlanControllerProvider.notifier)
          .logCompletionWithActivity(pawCandidateId);
    } catch (_) {}
    // 打开足爪护理记录表单
    if (context.mounted) {
      await showCareActivitySheet(context, type: 'paw');
    }
  });
}
