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
  'food_water': '饮食 / 饮水',
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
  'grooming': '梳毛 / 美容',
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
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _HealthRecordSheet(initialType: type),
  );
}

Future<void> showCareActivitySheet(
  BuildContext context, {
  String type = 'custom',
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _CareActivitySheet(initialType: type),
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
    final records = <({IconData icon, String label, VoidCallback action})>[
      for (final entry in healthRecordLabels.entries)
        (
          icon: _healthIcon(entry.key),
          label: entry.value,
          action: () {
            Navigator.pop(context);
            showHealthRecordSheet(context, type: entry.key);
          },
        ),
      for (final entry in careActivityLabels.entries)
        (
          icon: _careIcon(entry.key),
          label: entry.key == 'walk' && isWalking ? '结束遛狗' : entry.value,
          action: () {
            Navigator.pop(context);
            if (entry.key == 'bath') {
              showBathRecordSheet(context);
            } else if (entry.key == 'walk') {
              if (isWalking) {
                showFinishWalkSheet(context);
              } else {
                ref.read(careControllerProvider.notifier).startWalk();
              }
            } else {
              showCareActivitySheet(context, type: entry.key);
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
                '健康与日常护理都会保存到当前宠物的本地档案',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.sizeOf(context).width > 620
                      ? 4
                      : 2,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthRecordSheet extends ConsumerStatefulWidget {
  const _HealthRecordSheet({required this.initialType});

  final String initialType;

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
    _type = widget.initialType;
    _title.text = healthRecordLabels[_type] ?? '健康记录';
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
      await ref
          .read(healthRecordRepositoryProvider)
          .create(
            HealthRecordDraft(
              petId: petId,
              type: _type,
              occurredAt: _occurredAt,
              title: _title.text,
              note: _note.text,
              numericValue: _type == 'weight'
                  ? double.tryParse(_value.text.trim())
                  : null,
              unit: _type == 'weight' ? 'kg' : null,
              severity: _type == 'symptom' ? _severity : null,
            ),
          );
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
      title: '新增健康记录',
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
              label: const Text('保存健康记录'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareActivitySheet extends ConsumerStatefulWidget {
  const _CareActivitySheet({required this.initialType});

  final String initialType;

  @override
  ConsumerState<_CareActivitySheet> createState() => _CareActivitySheetState();
}

class _CareActivitySheetState extends ConsumerState<_CareActivitySheet> {
  final _place = TextEditingController();
  final _note = TextEditingController();
  late String _type;
  var _occurredAt = DateTime.now();
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _place.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final petId = await ref.read(petRepositoryProvider).ensureSelectedPetId();
      await ref
          .read(careRepositoryProvider)
          .create(
            CareActivityDraft(
              petId: petId,
              type: _type,
              occurredAt: _occurredAt,
              place: _place.text,
              note: _note.text,
            ),
          );
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
      title: '新增护理记录',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: '护理类型'),
            items: careActivityLabels.entries
                .where((entry) => entry.key != 'walk')
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
          _DateTimeField(
            value: _occurredAt,
            onChanged: (value) => setState(() => _occurredAt = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _place,
            decoration: const InputDecoration(
              labelText: '地点（可选）',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: const InputDecoration(labelText: '护理情况（可选）'),
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
            label: const Text('保存护理记录'),
          ),
        ],
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.value, required this.onChanged});

  final DateTime value;
  final ValueChanged<DateTime> onChanged;

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
    label: Text(_formatDateTime(value)),
  );
}

class _RecordSheetFrame extends StatelessWidget {
  const _RecordSheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

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
            '记录会保存在当前宠物的本地档案中。',
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
  'food_water' => Icons.restaurant_outlined,
  'elimination' => Icons.water_drop_outlined,
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
  'grooming' => Icons.content_cut_rounded,
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
