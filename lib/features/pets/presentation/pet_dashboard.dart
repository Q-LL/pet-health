import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../care/application/care_controller.dart';
import '../../care/presentation/care_page.dart';
import '../../records/data/health_record_repository.dart';
import '../../records/domain/health_record_filter.dart';
import '../../reminders/data/reminder_repository.dart';
import '../../reminders/domain/reminder_filter.dart';
import '../data/pet_repository.dart';
import '../domain/pet_profile.dart';
import 'pet_avatar.dart';

class PetDashboard extends ConsumerWidget {
  const PetDashboard({
    required this.pet,
    required this.pets,
    required this.onEdit,
    required this.onCreate,
    required this.onManage,
    super.key,
  });
  final PetProfile pet;
  final List<PetProfile> pets;
  final VoidCallback onEdit;
  final VoidCallback onCreate;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final weight = ref.watch(
      filteredHealthRecordsProvider(
        HealthRecordFilter(
          petId: pet.id,
          type: 'weight',
          from: DateTime(now.year, now.month, now.day - 90).toUtc(),
          limit: 90,
        ),
      ),
    );
    final weights =
        weight.value
            ?.where((item) => item.numericValue?.isFinite == true)
            .toList() ??
        [];
    final latest = weights.firstOrNull;
    final reminders = ref.watch(
      filteredRemindersProvider(ReminderFilter(petId: pet.id, enabled: true)),
    );
    final next = reminders.value?.where((item) => !item.paused).firstOrNull;
    final bath = ref.watch(careControllerProvider).lastBath;
    final bathLabel = bath == null
        ? '还未记录'
        : '${now.difference(bath.occurredAt).inDays.clamp(0, 9999)} 天前';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  PetPortrait(pet: pet, size: 64),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          [
                            if (pet.breed?.isNotEmpty == true) pet.breed!,
                            if (pet.sex != null) _sex(pet.sex!),
                            if (pet.neutered != null)
                              pet.neutered! ? '已绝育' : '未绝育',
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _age(pet.birthday),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: onEdit, child: const Text('编辑')),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '切换狗狗',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  for (final item in pets)
                    ChoiceChip(
                      label: Text(item.name),
                      selected: item.id == pet.id,
                      showCheckmark: false,
                      onSelected: (_) async {
                        try {
                          await ref
                              .read(petRepositoryProvider)
                              .selectPet(item.id);
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('切换失败：$error')),
                            );
                          }
                        }
                      },
                    ),
                  IconButton(
                    tooltip: '创建狗狗档案',
                    onPressed: onCreate,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          padding: const EdgeInsets.all(16),
          onTap: () => context.push('/records?type=weight'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '体重 · 近 90 天',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '查看趋势',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final number = Text(
                    weight.hasError
                        ? '读取失败'
                        : latest == null
                        ? '还未记录'
                        : '${latest.numericValue} ${latest.unit ?? 'kg'}',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontFamily: null),
                  );
                  final chart = weights.length < 2
                      ? Text(
                          '多记几次，看看变化',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : Semantics(
                          label: '近90天共${weights.length}次体重记录',
                          child: SizedBox(
                            height: 44,
                            child: CustomPaint(
                              painter: _WeightPainter([
                                for (final record in weights.reversed)
                                  (
                                    at: record.occurredAt.millisecondsSinceEpoch
                                        .toDouble(),
                                    value:
                                        record.numericValue! *
                                        (record.unit == '斤'
                                            ? .5
                                            : record.unit == 'lb'
                                            ? .45359237
                                            : 1),
                                  ),
                              ], colors.primary),
                              size: const Size(double.infinity, 44),
                            ),
                          ),
                        );
                  if (MediaQuery.textScalerOf(context).scale(16) > 23) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [number, const SizedBox(height: 8), chart],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: number),
                      const SizedBox(width: 12),
                      Expanded(child: chart),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final tiles = [
              StatTile(
                label: '上次洗澡',
                value: bathLabel,
                onTap: () => context.go('/timeline?type=care'),
              ),
              StatTile(
                label: '下次提醒',
                value: reminders.hasError
                    ? '读取失败'
                    : next == null
                    ? '暂无提醒'
                    : _reminderDate(next.scheduledAt),
                onTap: () => context.go(CareSegment.todo.location),
              ),
            ];
            if (MediaQuery.textScalerOf(context).scale(16) > 23) {
              return Column(
                children: [tiles[0], const SizedBox(height: 12), tiles[1]],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: tiles[0]),
                const SizedBox(width: 12),
                Expanded(child: tiles[1]),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const SectionHeader('健康档案'),
        SectionCard.rows(
          children: [
            ListRow(
              title: '疫苗记录',
              leading: const IconBadge(Icons.vaccines_outlined),
              onTap: () => context.push('/records?type=vaccine'),
            ),
            ListRow(
              title: '驱虫记录',
              leading: const IconBadge(Icons.bug_report_outlined),
              onTap: () => context.push('/records?type=deworming'),
            ),
            ListRow(
              title: '用药记录',
              leading: const IconBadge(Icons.medication_outlined),
              onTap: () => context.push('/records?type=medication'),
            ),
            ListRow(
              title: '爱宠时光',
              leading: const IconBadge(Icons.photo_library_outlined),
              onTap: () => context.push('/memories'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader('需要记住的事'),
        SectionCard.rows(
          children: [
            ListRow(
              title: '过敏信息',
              subtitle: pet.allergies.isEmpty ? '未填写' : pet.allergies,
              onTap: onEdit,
            ),
            ListRow(
              title: '慢性病 / 长期关注',
              subtitle: pet.chronicConditions.isEmpty
                  ? '未填写'
                  : pet.chronicConditions,
              onTap: onEdit,
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onManage,
          icon: const Icon(Icons.pets_outlined),
          label: const Text('管理全部狗狗'),
        ),
      ],
    );
  }
}

class _WeightPainter extends CustomPainter {
  _WeightPainter(this.points, this.color);
  final List<({double at, double value})> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final low = points.map((p) => p.value).reduce(math.min);
    final high = points.map((p) => p.value).reduce(math.max);
    final span = math.max(1.0, points.last.at - points.first.at);
    Offset position(int i) => Offset(
      4 + (points[i].at - points.first.at) / span * (size.width - 8),
      high == low
          ? size.height / 2
          : 6 + (high - points[i].value) / (high - low) * (size.height - 12),
    );
    final path = Path()..moveTo(position(0).dx, position(0).dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(position(i).dx, position(i).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(position(points.length - 1), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_WeightPainter oldDelegate) =>
      points != oldDelegate.points || color != oldDelegate.color;
}

String _sex(String sex) => sex == 'male'
    ? '公'
    : sex == 'female'
    ? '母'
    : '性别未注明';
String _age(DateTime? birthday) {
  if (birthday == null) return '出生日期待补充';
  final date = birthday.toLocal();
  final now = DateTime.now();
  var months = (now.year - date.year) * 12 + now.month - date.month;
  if (now.day < date.day) months--;
  if (months < 0) return '出生日期待确认';
  return months < 12
      ? '$months 个月'
      : '${months ~/ 12} 岁${months % 12 == 0 ? '' : ' ${months % 12} 个月'}';
}

String _reminderDate(DateTime value) {
  final local = value.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final label = day == today ? '今天' : '${local.month}/${local.day}';
  return '$label ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}
