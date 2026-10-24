import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/l10n/labels.dart';
import '../data/pet_photo_repository.dart';
import '../data/pets_repository.dart';
import '../domain/breed_catalog.dart';
import '../domain/pet.dart';
import '../domain/pet_codes.dart';
import 'pet_fields.dart';

/// 打开编辑档案的面板。
///
/// 用底部面板而不是新页面：新页面会完全盖住下面的页面，让它们暂停接收
/// 数据更新；在这期间改了数据，关闭时暂停的更新会在重建中途一起涌回来。
Future<void> showPetEditSheet(BuildContext context, Pet pet) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.94,
        child: PetEditPage(pet: pet),
      ),
    );

/// 编辑档案：名字、性别、绝育、品种、生日和到家日期；也可以删除档案。
class PetEditPage extends ConsumerStatefulWidget {
  const PetEditPage({super.key, required this.pet});

  final Pet pet;

  @override
  ConsumerState<PetEditPage> createState() => _PetEditPageState();
}

class _PetEditPageState extends ConsumerState<PetEditPage> {
  late String _name = widget.pet.name;
  late PetSex? _sex = widget.pet.sex;
  late bool _neutered = widget.pet.neutered ?? false;
  late String? _breedCode = widget.pet.breedCode;
  late String? _breedName = widget.pet.breedName;
  // 预设犬种的分组由犬种决定；手填犬种时才单独保存分组。
  late BreedGroup? _breedGroup = widget.pet.breedCode == null
      ? widget.pet.breedGroup
      : null;
  late DateTime? _birthDate = widget.pet.birthDate;
  late BirthPrecision _birthPrecision = widget.pet.birthPrecision;
  late DateTime? _homeDate = widget.pet.homeDate;
  var _saving = false;

  bool get _valid => _name.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_valid || _saving) return;
    final l = AppLocalizations.of(context);
    setState(() => _saving = true);
    final pets = ref.read(petsRepositoryProvider);
    try {
      final updated = await pets.update(
        widget.pet.id,
        PetDraft(
          name: _name,
          sex: _sex,
          neutered: _neutered,
          birthDate: _birthDate,
          birthPrecision: _birthPrecision,
          homeDate: _homeDate,
          breedCode: _breedCode,
          breedName: _breedName,
          breedGroup: _breedGroup,
        ),
      );
      if (!mounted) return;
      if (updated.breedGroup != widget.pet.breedGroup) {
        final regenerate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(l.breedChangedApply),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: PawColors.inkMuted,
                ),
                child: Text(l.actionKeep),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l.actionRegenerate),
              ),
            ],
          ),
        );
        if (regenerate == true) await pets.applyBreedDefaults(widget.pet.id);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.profileDeleteConfirm(widget.pet.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: PawColors.inkMuted),
            child: Text(l.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // 先清理照片文件，再删档案；数据库里的记录、计划随外键一起删除。
    await ref.read(petPhotoRepositoryProvider).deleteAllForPet(widget.pet.id);
    await ref.read(petsRepositoryProvider).delete(widget.pet.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
        children: [
          Row(
            children: [
              Expanded(child: Text(l.petEdit, style: text.headlineSmall)),
              IconButton(
                tooltip: l.sheetClose,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: PawColors.subtle,
                  minimumSize: const Size(44, 44),
                ),
                icon: const PawIcon(PawGlyph.close, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FieldLabel(l.onboardingNameLabel),
          TextFormField(
            initialValue: _name,
            maxLength: 30,
            decoration: InputDecoration(
              counterText: '',
              errorText: _valid ? null : l.onboardingNameRequired,
            ),
            onChanged: (value) => setState(() => _name = value),
          ),
          const SizedBox(height: PawSpace.lg),
          FieldLabel(l.onboardingSexLabel),
          Wrap(
            spacing: PawSpace.sm,
            children: [
              for (final sex in PetSex.values)
                PawChoiceChip(
                  label: l.sex(sex),
                  selected: _sex == sex,
                  onTap: () => setState(() => _sex = _sex == sex ? null : sex),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.petNeutered),
            value: _neutered,
            onChanged: (value) => setState(() => _neutered = value),
          ),
          const SizedBox(height: PawSpace.md),
          PetDateFields(
            birthDate: _birthDate,
            birthPrecision: _birthPrecision,
            homeDate: _homeDate,
            onBirthDate: (date) => setState(() => _birthDate = date),
            onBirthPrecision: (value) =>
                setState(() => _birthPrecision = value),
            onHomeDate: (date) => setState(() => _homeDate = date),
          ),
          const SizedBox(height: PawSpace.xl),
          FieldLabel(l.onboardingBreedTitle(_name.trim())),
          BreedSelector(
            breedCode: _breedCode,
            breedName: _breedName,
            breedGroup: _breedGroup ?? breedGroupFor(_breedCode),
            onBreed: (code) => setState(() {
              _breedCode = code;
              _breedName = null;
              _breedGroup = null;
            }),
            onOther: () => setState(() {
              _breedCode = null;
              _breedGroup ??= BreedGroup.mixed;
            }),
            onName: (name) => setState(() => _breedName = name),
            onGroup: (group) => setState(() => _breedGroup = group),
          ),
          const SizedBox(height: PawSpace.xl),
          FilledButton(
            onPressed: _valid && !_saving ? _save : null,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
            child: Text(l.sheetSave),
          ),
          const SizedBox(height: PawSpace.md),
          TextButton(onPressed: _delete, child: Text(l.profileDelete)),
        ],
      ),
    );
  }
}
