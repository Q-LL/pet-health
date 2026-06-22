import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../application/care_controller.dart';

Future<void> showBathRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => const _BathRecordSheet(),
  );
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

class _BathRecordSheet extends ConsumerStatefulWidget {
  const _BathRecordSheet();

  @override
  ConsumerState<_BathRecordSheet> createState() => _BathRecordSheetState();
}

class _BathRecordSheetState extends ConsumerState<_BathRecordSheet> {
  final _placeController = TextEditingController();
  var _date = DateTime.now();

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (result != null && mounted) setState(() => _date = result);
  }

  void _save() {
    ref
        .read(careControllerProvider.notifier)
        .recordBath(occurredAt: _date, place: _placeController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: '记录洗澡',
      subtitle: '以后可以快速看到距离上次洗澡多久、在哪里洗的。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_rounded),
            label: Text(_formatDate(_date)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _placeController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: '洗澡地点（可选）',
              hintText: '例如：家里、暖爪宠物店',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded),
            label: const Text('保存洗澡记录'),
          ),
        ],
      ),
    );
  }
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

  void _finish() {
    ref
        .read(careControllerProvider.notifier)
        .finishWalk(place: _placeController.text);
    Navigator.pop(context);
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

String _formatDate(DateTime date) =>
    '${date.year} 年 ${date.month} 月 ${date.day} 日';
