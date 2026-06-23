import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/page_frame.dart';
import '../data/pet_repository.dart';
import '../domain/pet_profile.dart';

class PetsPage extends ConsumerWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(petsProvider);
    final selectedPetId = ref.watch(selectedPetIdProvider).value;
    return PageFrame(
      title: '宠物',
      subtitle: '每只宠物都有独立、连续的健康履历。',
      actions: [
        IconButton.filledTonal(
          tooltip: '创建宠物档案',
          onPressed: () => _editPet(context, ref),
          icon: const Icon(Icons.add_rounded),
        ),
        const SizedBox(width: 12),
      ],
      child: pets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorCard(message: error.toString()),
        data: (items) {
          final realPets = items
              .where((pet) => !pet.isPlaceholder)
              .toList(growable: false);
          if (realPets.isEmpty) {
            return _EmptyPets(onCreate: () => _editPet(context, ref));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final pet in realPets) ...[
                _PetCard(
                  pet: pet,
                  selected: pet.id == selectedPetId,
                  onSelect: () =>
                      ref.read(petRepositoryProvider).selectPet(pet.id),
                  onEdit: () => _editPet(context, ref, pet: pet),
                  onDelete: () => _deletePet(context, ref, pet),
                ),
                const SizedBox(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _editPet(
    BuildContext context,
    WidgetRef ref, {
    PetProfile? pet,
  }) async {
    final draft = await showDialog<PetDraft>(
      context: context,
      builder: (_) => _PetEditorDialog(pet: pet),
    );
    if (draft == null || !context.mounted) return;
    try {
      final repository = ref.read(petRepositoryProvider);
      if (pet == null) {
        await repository.create(draft);
      } else {
        await repository.update(pet.id, draft);
      }
    } on Object catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败：$error')));
      }
    }
  }

  Future<void> _deletePet(
    BuildContext context,
    WidgetRef ref,
    PetProfile pet,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除 ${pet.name}？'),
        content: const Text('该宠物的健康记录和护理记录也会从本机删除，此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(petRepositoryProvider).deletePet(pet.id);
    }
  }
}

class _EmptyPets extends StatelessWidget {
  const _EmptyPets({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: colors.surface.withValues(alpha: .78),
            child: Icon(Icons.pets_rounded, size: 42, color: colors.primary),
          ),
          const SizedBox(height: 24),
          Text('认识一下毛孩子吧', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          const Text(
            '先添加名字和需要长期留意的信息，之后每一条记录都会准确回到它的档案里。',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 26),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('创建宠物档案'),
          ),
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.pet,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  final PetProfile pet;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final details = [pet.species, pet.breed].whereType<String>().join(' · ');
    return Card(
      color: selected ? colors.primaryContainer : colors.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.surface,
                child: const Icon(Icons.pets_rounded),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pet.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(width: 8),
                          const Chip(label: Text('当前')),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(details.isEmpty ? '档案信息待补充' : details),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('编辑档案')),
                  PopupMenuItem(value: 'delete', child: Text('删除档案')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetEditorDialog extends StatefulWidget {
  const _PetEditorDialog({this.pet});

  final PetProfile? pet;

  @override
  State<_PetEditorDialog> createState() => _PetEditorDialogState();
}

class _PetEditorDialogState extends State<_PetEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _species;
  late final TextEditingController _breed;
  late final TextEditingController _allergies;
  late final TextEditingController _conditions;
  String? _sex;
  bool? _neutered;
  DateTime? _birthday;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    _name = TextEditingController(text: pet?.name);
    _species = TextEditingController(text: pet?.species);
    _breed = TextEditingController(text: pet?.breed);
    _allergies = TextEditingController(text: pet?.allergies);
    _conditions = TextEditingController(text: pet?.chronicConditions);
    _sex = pet?.sex;
    _neutered = pet?.neutered;
    _birthday = pet?.birthday?.toLocal();
  }

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    _breed.dispose();
    _allergies.dispose();
    _conditions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.pet == null ? '创建宠物档案' : '编辑宠物档案'),
    content: SizedBox(
      width: 480,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(labelText: '名字 *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? '请填写宠物名字' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _species,
                decoration: const InputDecoration(labelText: '物种，例如：猫、狗'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _breed,
                decoration: const InputDecoration(labelText: '品种'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _sex,
                decoration: const InputDecoration(labelText: '性别'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('未填写')),
                  DropdownMenuItem(value: 'male', child: Text('公')),
                  DropdownMenuItem(value: 'female', child: Text('母')),
                  DropdownMenuItem(value: 'unknown', child: Text('未知 / 其他')),
                ],
                onChanged: (value) => setState(() => _sex = value),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final value = await showDatePicker(
                    context: context,
                    initialDate: _birthday ?? DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (value != null) setState(() => _birthday = value);
                },
                icon: const Icon(Icons.cake_outlined),
                label: Text(
                  _birthday == null
                      ? '出生日期（未填写）'
                      : '出生日期：${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<bool?>(
                initialValue: _neutered,
                decoration: const InputDecoration(labelText: '绝育状态'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('未填写')),
                  DropdownMenuItem(value: true, child: Text('已绝育')),
                  DropdownMenuItem(value: false, child: Text('未绝育')),
                ],
                onChanged: (value) => setState(() => _neutered = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _allergies,
                decoration: const InputDecoration(labelText: '过敏信息'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _conditions,
                decoration: const InputDecoration(labelText: '慢性病或长期关注事项'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          Navigator.pop(
            context,
            PetDraft(
              name: _name.text,
              species: _species.text,
              breed: _breed.text,
              sex: _sex,
              birthday: _birthday,
              neutered: _neutered,
              allergies: _allergies.text,
              chronicConditions: _conditions.text,
            ),
          );
        },
        child: const Text('保存'),
      ),
    ],
  );
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Text('读取本地档案失败：$message'),
    ),
  );
}
