import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/image_file_picker.dart';
import '../../../core/widgets/page_frame.dart';
import '../data/pet_photo_repository.dart';
import '../data/pet_repository.dart';
import '../domain/pet_profile.dart';
import 'pet_avatar.dart';

class PetsPage extends ConsumerWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(petsProvider);
    final selectedPetId = ref.watch(selectedPetIdProvider).value;
    return PageFrame(
      title: '狗狗',
      subtitle: '每只狗狗都有独立、连续的健康履历。',
      actions: [
        IconButton.filledTonal(
          tooltip: '创建狗狗档案',
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
    final result = await showDialog<_PetEditorResult>(
      context: context,
      builder: (_) => _PetEditorDialog(pet: pet),
    );
    if (result == null || !context.mounted) return;
    try {
      final repository = ref.read(petRepositoryProvider);
      late final PetProfile savedPet;
      if (pet == null) {
        savedPet = await repository.create(result.draft);
      } else {
        savedPet = await repository.update(pet.id, result.draft);
      }
      final photo = result.photo;
      if (photo != null) {
        await ref
            .read(petPhotoRepositoryProvider)
            .add(
              petId: savedPet.id,
              bytes: photo.bytes,
              originalName: photo.name,
              mediaType: photo.mediaType,
              setAsAvatar: true,
            );
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
        content: const Text('这只狗狗的健康记录和护理记录也会从本机删除，此操作无法撤销。'),
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
            label: const Text('创建狗狗档案'),
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
              PetPortrait(pet: pet, width: 72, height: 96, borderRadius: 20),
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (pet.birthday != null)
                          _MiniInfoChip(
                            icon: Icons.cake_outlined,
                            label: _formatDate(pet.birthday!.toLocal()),
                          ),
                        if (pet.sex != null)
                          _MiniInfoChip(
                            icon: Icons.wc_outlined,
                            label: _sexLabel(pet.sex),
                          ),
                        if (pet.neutered != null)
                          _MiniInfoChip(
                            icon: Icons.verified_outlined,
                            label: pet.neutered! ? '已绝育' : '未绝育',
                          ),
                      ],
                    ),
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

class _MiniInfoChip extends StatelessWidget {
  const _MiniInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
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
  PickedImageFile? _pickedPhoto;
  Uint8List? _previewBytes;

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
    title: Text(widget.pet == null ? '创建狗狗档案' : '编辑狗狗档案'),
    content: SizedBox(
      width: 480,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PhotoPickerPreview(
                pet: widget.pet,
                bytes: _previewBytes,
                onPick: _pickPhoto,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(labelText: '名字 *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? '请填写狗狗名字' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _species,
                decoration: const InputDecoration(
                  labelText: '类型',
                  hintText: '默认狗狗，可补充小型犬 / 中型犬 / 大型犬等',
                ),
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
            _PetEditorResult(
              draft: PetDraft(
                name: _name.text,
                species: _species.text,
                breed: _breed.text,
                sex: _sex,
                birthday: _birthday,
                neutered: _neutered,
                allergies: _allergies.text,
                chronicConditions: _conditions.text,
              ),
              photo: _pickedPhoto,
            ),
          );
        },
        child: const Text('保存'),
      ),
    ],
  );

  Future<void> _pickPhoto() async {
    try {
      final photo = await pickPetPhotoFile();
      if (photo == null || !mounted) return;
      setState(() {
        _pickedPhoto = photo;
        _previewBytes = photo.bytes;
      });
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('选择照片失败：$error')));
    }
  }
}

class _PetEditorResult {
  const _PetEditorResult({required this.draft, this.photo});

  final PetDraft draft;
  final PickedImageFile? photo;
}

class _PhotoPickerPreview extends StatelessWidget {
  const _PhotoPickerPreview({
    required this.pet,
    required this.bytes,
    required this.onPick,
  });

  final PetProfile? pet;
  final Uint8List? bytes;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 120,
            height: 160,
            color: colors.surfaceContainerHighest,
            child: bytes == null
                ? pet == null
                      ? Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 38,
                          color: colors.onSurfaceVariant,
                        )
                      : PetPortrait(
                          pet: pet!,
                          width: 120,
                          height: 160,
                          borderRadius: 0,
                          showBadge: true,
                        )
                : Image.memory(bytes!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('档案照片', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                '上传后会按 3:4 竖屏比例预览裁切，并作为首页和档案头像显示。',
                style: TextStyle(color: colors.onSurfaceVariant, height: 1.35),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.upload_rounded),
                label: Text(bytes == null ? '上传照片' : '更换照片'),
              ),
            ],
          ),
        ),
      ],
    );
  }
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

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String _sexLabel(String? value) => switch (value) {
  'male' => '公',
  'female' => '母',
  'unknown' => '未知',
  _ => '未填写',
};
