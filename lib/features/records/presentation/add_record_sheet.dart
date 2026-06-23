import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/motion.dart';
import '../../care/application/care_controller.dart';
import '../../care/data/care_repository.dart';
import '../../care/domain/care_models.dart';
import '../../care/presentation/care_sheets.dart';
import '../../pets/data/pet_repository.dart';
import '../data/health_record_repository.dart';
import '../domain/health_record.dart';

const healthRecordLabels = <String, String>{
  'weight': '体重',
  'food': '饮食',
  'water': '饮水',
  'elimination': '排泄',
  'symptom': '症状',
  'medication': '用药',
  'vaccine': '疫苗',
  'deworming': '驱虫',
  'custom': '自定义记录',
};

const careActivityLabels = <String, String>{
  'bath': '洗澡',
  'walk': '遛狗',
  'oral': '口腔护理',
  'combing': '梳毛',
  'styling': '美容',
  'nail': '指甲护理',
  'ear': '耳部护理',
  'eye': '眼部护理',
  'paw': '足爪护理',
  'environment': '用品 / 环境清洁',
  'custom': '自定义护理',
};

Future<void> showAddRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (context) => const _AddRecordSheet(),
  );
}

Future<void> showHealthRecordSheet(
  BuildContext context, {
  String type = 'custom',
  HealthRecord? record,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _HealthRecordSheet(initialType: type, record: record),
  );
}

Future<void> showCareActivitySheet(
  BuildContext context, {
  String type = 'custom',
  CareActivity? activity,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _CareActivitySheet(initialType: type, activity: activity),
  );
}

Future<void> showWalkRecordSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (_) => const _WalkRecordChoiceSheet(),
  );
}

void _showGroomingChoiceSheet(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.medium,
      reverseDuration: AppMotion.fast,
    ),
    builder: (context) => _RecordSheetFrame(
      title: '梳毛 / 美容',
      subtitle: '选择本次护理类型',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChoiceTile(
            icon: Icons.brush_outlined,
            title: '梳毛',
            subtitle: '日常梳毛、去结毛、整理毛发',
            color: colors.primaryContainer,
            onTap: () {
              Navigator.pop(context);
              showCareActivitySheet(context, type: 'combing');
            },
          ),
          const SizedBox(height: 12),
          _ChoiceTile(
            icon: Icons.content_cut_rounded,
            title: '美容',
            subtitle: '宠物店美容、造型、修剪',
            color: colors.tertiaryContainer,
            onTap: () {
              Navigator.pop(context);
              showCareActivitySheet(context, type: 'styling');
            },
          ),
        ],
      ),
    ),
  );
}

class _AddRecordSheet extends ConsumerWidget {
  const _AddRecordSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWalking = ref.watch(
      careControllerProvider.select(
        (state) => state.activeWalkStartedAt != null,
      ),
    );
    final colors = Theme.of(context).colorScheme;

    // ── 健康记录 ──
    const healthOrder = [
      'weight', 'symptom', 'medication', 'vaccine', 'deworming',
      'food', 'water', 'elimination', 'custom',
    ];
    final healthRecords = [
      for (final key in healthOrder)
        if (healthRecordLabels.containsKey(key))
          (
            icon: _healthIcon(key),
            label: healthRecordLabels[key]!,
            action: () {
              Navigator.pop(context);
              showHealthRecordSheet(context, type: key);
            },
          ),
    ];

    // ── 护理记录 ──
    const careOrder = [
      'walk', 'bath', 'grooming', 'oral', 'nail',
      'ear', 'eye', 'paw', 'environment', 'custom',
    ];
    final careRecords = <({IconData icon, String label, VoidCallback action})>[
      for (final key in careOrder)
        if (key == 'grooming')
          (
            icon: Icons.content_cut_rounded,
            label: '梳毛 / 美容',
            action: () {
              Navigator.pop(context);
              _showGroomingChoiceSheet(context);
            },
          )
        else if (careActivityLabels.containsKey(key) &&
            key != 'combing' && key != 'styling')
          (
            icon: _careIcon(key),
            label: key == 'walk' && isWalking ? '结束遛狗' : careActivityLabels[key]!,
            action: () {
              Navigator.pop(context);
              if (key == 'bath') {
                showBathRecordSheet(context);
              } else if (key == 'walk') {
                if (isWalking) {
                  showFinishWalkSheet(context);
                } else {
                  showWalkRecordSheet(context);
                }
              } else {
                showCareActivitySheet(context, type: key);
              }
            },
          ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('新增记录', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                '健康与日常护理都会保存到当前狗狗的本地档案',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // ── 健康记录标题 ──
              _SectionHeader(
                icon: Icons.favorite_outline,
                label: '健康',
                color: colors.errorContainer,
                onColor: colors.onErrorContainer,
              ),
              const SizedBox(height: 10),
              _RecordGrid(records: healthRecords),

              const SizedBox(height: 22),

              // ── 护理记录标题 ──
              _SectionHeader(
                icon: Icons.spa_outlined,
                label: '护理',
                color: colors.tertiaryContainer,
                onColor: colors.onTertiaryContainer,
              ),
              const SizedBox(height: 10),
              _RecordGrid(records: careRecords),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    required this.onColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: onColor),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}

class _RecordGrid extends StatelessWidget {
  const _RecordGrid({required this.records});

  final List<({IconData icon, String label, VoidCallback action})> records;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 620 ? 4 : 2,
        mainAxisExtent: 76,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) => Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: records[index].action,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(records[index].icon),
                const SizedBox(width: 10),
                Expanded(child: Text(records[index].label)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalkRecordChoiceSheet extends ConsumerWidget {
  const _WalkRecordChoiceSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWalking = ref.watch(
      careControllerProvider.select(
        (state) => state.activeWalkStartedAt != null,
      ),
    );
    final colors = Theme.of(context).colorScheme;
    return _RecordSheetFrame(
      title: isWalking ? '正在遛狗' : '添加遛狗记录',
      subtitle: isWalking
          ? '当前有一段正在计时的遛狗，可以直接结束并保存。'
          : '手动补录适合刚才忘记打开计时；快速开始会从现在起计时。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWalking)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showFinishWalkSheet(context);
              },
              icon: const Icon(Icons.flag_rounded),
              label: const Text('结束当前遛狗'),
            )
          else ...[
            _ChoiceTile(
              icon: Icons.edit_calendar_outlined,
              title: '手动添加',
              subtitle: '填写开始时间、结束时间和地点',
              color: colors.primaryContainer,
              onTap: () {
                Navigator.pop(context);
                showCareActivitySheet(context, type: 'walk');
              },
            ),
            const SizedBox(height: 12),
            _ChoiceTile(
              icon: Icons.timer_outlined,
              title: '开始计时',
              subtitle: '从现在开始记录这次遛狗',
              color: colors.tertiaryContainer,
              onTap: () {
                Navigator.pop(context);
                ref.read(careControllerProvider.notifier).startWalk();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: .7),
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthRecordSheet extends ConsumerStatefulWidget {
  const _HealthRecordSheet({required this.initialType, this.record});

  final String initialType;
  final HealthRecord? record;

  @override
  ConsumerState<_HealthRecordSheet> createState() => _HealthRecordSheetState();
}

class _HealthRecordSheetState extends ConsumerState<_HealthRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  final _value = TextEditingController();
  late String _type;
  var _occurredAt = DateTime.now();
  int? _severity;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    _type = record?.type ?? widget.initialType;
    _title.text = record?.title ?? healthRecordLabels[_type] ?? '健康记录';
    _note.text = record?.note ?? '';
    _value.text = record?.numericValue?.toString() ?? '';
    _occurredAt = record?.occurredAt.toLocal() ?? DateTime.now();
    _severity = record?.severity;
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
      final draft = HealthRecordDraft(
        petId: widget.record?.petId ?? petId,
        type: _type,
        occurredAt: _occurredAt,
        title: _title.text,
        note: _note.text,
        numericValue: _type == 'weight'
            ? double.tryParse(_value.text.trim())
            : null,
        unit: _type == 'weight' ? 'kg' : null,
        severity: _type == 'symptom' ? _severity : null,
      );
      final repository = ref.read(healthRecordRepositoryProvider);
      if (widget.record == null) {
        await repository.create(draft);
      } else {
        await repository.update(widget.record!.id, draft);
      }
      if (mounted) Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：$error')));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RecordSheetFrame(
      title: widget.record == null ? '新增健康记录' : '编辑健康记录',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: '记录类型'),
              items: healthRecordLabels.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _type = value!;
                _title.text = healthRecordLabels[value] ?? '健康记录';
                _severity = null;
              }),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: '标题 *'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? '请填写标题' : null,
            ),
            if (_type == 'weight') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _value,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '体重 *',
                  suffixText: 'kg',
                ),
                validator: (value) =>
                    double.tryParse(value?.trim() ?? '') == null
                    ? '请输入有效体重'
                    : null,
              ),
            ],
            if (_type == 'symptom') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _severity,
                decoration: const InputDecoration(labelText: '严重程度（可选）'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('未填写')),
                  DropdownMenuItem(value: 1, child: Text('1 · 轻微')),
                  DropdownMenuItem(value: 2, child: Text('2')),
                  DropdownMenuItem(value: 3, child: Text('3 · 中等')),
                  DropdownMenuItem(value: 4, child: Text('4')),
                  DropdownMenuItem(value: 5, child: Text('5 · 严重')),
                ],
                onChanged: (value) => setState(() => _severity = value),
              ),
            ],
            const SizedBox(height: 12),
            _DateTimeField(
              value: _occurredAt,
              onChanged: (value) => setState(() => _occurredAt = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '备注（可选）'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(widget.record == null ? '保存健康记录' : '保存修改'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareActivitySheet extends ConsumerStatefulWidget {
  const _CareActivitySheet({required this.initialType, this.activity});

  final String initialType;
  final CareActivity? activity;

  @override
  ConsumerState<_CareActivitySheet> createState() => _CareActivitySheetState();
}

class _CareActivitySheetState extends ConsumerState<_CareActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  final _place = TextEditingController();
  final _note = TextEditingController();
  late String _type;
  var _occurredAt = DateTime.now();
  late DateTime _startedAt;
  late DateTime _endedAt;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final activity = widget.activity;
    _type = activity?.type ?? widget.initialType;
    _occurredAt = activity?.occurredAt.toLocal() ?? DateTime.now();
    _startedAt =
        activity?.startedAt?.toLocal() ??
        DateTime.now().subtract(const Duration(minutes: 30));
    _endedAt = activity?.endedAt?.toLocal() ?? DateTime.now();
    _place.text = activity?.place ?? '';
    _note.text = activity?.note ?? '';
  }

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
      final isWalk = _type == 'walk';
      final draft = CareActivityDraft(
        petId: widget.activity?.petId ?? petId,
        type: _type,
        occurredAt: isWalk ? _startedAt : _occurredAt,
        startedAt: isWalk ? _startedAt : null,
        endedAt: isWalk ? _endedAt : null,
        place: _place.text,
        note: _note.text,
        routeFilePath: widget.activity?.routeFilePath,
      );
      final repository = ref.read(careRepositoryProvider);
      if (widget.activity == null) {
        await repository.create(draft);
      } else {
        await repository.update(widget.activity!.id, draft);
      }
      if (mounted) Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：$error')));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showWalkFields = _type == 'walk';
    final typeEntries = careActivityLabels.entries.where(
      (entry) => entry.key != 'walk' || widget.initialType == 'walk',
    );
    return _RecordSheetFrame(
      title: widget.activity == null ? '新增护理记录' : '编辑护理记录',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: '护理类型'),
              items: typeEntries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            const SizedBox(height: 12),
            if (showWalkFields) ...[
              _DateTimeField(
                label: '开始时间',
                value: _startedAt,
                onChanged: (value) => setState(() => _startedAt = value),
              ),
              const SizedBox(height: 12),
              _DateTimeField(
                label: '结束时间',
                value: _endedAt,
                onChanged: (value) => setState(() => _endedAt = value),
              ),
              if (_endedAt.isBefore(_startedAt)) ...[
                const SizedBox(height: 8),
                Text(
                  '结束时间不能早于开始时间',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ] else
              _DateTimeField(
                value: _occurredAt,
                onChanged: (value) => setState(() => _occurredAt = value),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _place,
              decoration: InputDecoration(
                labelText: showWalkFields ? '遛狗地点（可选）' : '地点（可选）',
                prefixIcon: Icon(
                  showWalkFields
                      ? Icons.park_outlined
                      : Icons.location_on_outlined,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: showWalkFields ? '遛狗情况（可选）' : '护理情况（可选）',
              ),
              validator: (_) => _type == 'walk' && _endedAt.isBefore(_startedAt)
                  ? '结束时间不能早于开始时间'
                  : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(widget.activity == null ? '保存护理记录' : '保存修改'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.value,
    required this.onChanged,
    this.label = '发生时间',
  });

  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (date == null || !context.mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(value),
      );
      if (time == null) return;
      onChanged(
        DateTime(date.year, date.month, date.day, time.hour, time.minute),
      );
    },
    icon: const Icon(Icons.schedule_rounded),
    label: Text('$label：${_formatDateTime(value)}'),
  );
}

class _RecordSheetFrame extends StatelessWidget {
  const _RecordSheetFrame({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(
      20,
      4,
      20,
      24 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            subtitle ?? '记录会保存在当前狗狗的本地档案中。',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );
}

IconData _healthIcon(String type) => switch (type) {
  'weight' => Icons.monitor_weight_outlined,
  'food' => Icons.restaurant_outlined,
  'water' => Icons.water_drop_rounded,
  'elimination' => Icons.wc_outlined,
  'symptom' => Icons.healing_outlined,
  'medication' => Icons.medication_outlined,
  'vaccine' => Icons.vaccines_outlined,
  'deworming' => Icons.bug_report_outlined,
  _ => Icons.note_add_outlined,
};

IconData _careIcon(String type) => switch (type) {
  'bath' => Icons.bathtub_outlined,
  'walk' => Icons.directions_walk_rounded,
  'oral' => Icons.medical_services_outlined,
  'combing' => Icons.brush_outlined,
  'styling' => Icons.content_cut_rounded,
  'nail' => Icons.back_hand_outlined,
  'ear' => Icons.hearing_outlined,
  'eye' => Icons.visibility_outlined,
  'paw' => Icons.pets_outlined,
  'environment' => Icons.cleaning_services_outlined,
  _ => Icons.note_add_outlined,
};

String _formatDateTime(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
