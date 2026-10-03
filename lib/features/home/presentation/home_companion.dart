import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pets/data/pet_repository.dart';
import '../../pets/data/pet_photo_repository.dart';
import '../../pets/domain/pet_profile.dart';
import '../../pets/domain/pet_photo.dart';
import '../../notifications/presentation/notification_center_page.dart';
import '../../pets/presentation/pet_avatar.dart';
import '../../../core/ui/ui.dart';

const homeIllustration = 'assets/illustrations/home-companion.png';

final homePortraitProvider = StreamProvider.autoDispose
    .family<List<PetPhoto>, String>(
      (ref, id) =>
          ref.watch(petPhotoRepositoryProvider).watchForPet(id, limit: 1),
    );
final homePhotoBytesProvider = FutureProvider.autoDispose
    .family<Uint8List, String>(
      (ref, id) => ref.watch(petPhotoRepositoryProvider).readBytes(id),
    );

class _InboxButton extends ConsumerWidget {
  const _InboxButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(inboxCountProvider);
    return IconButton.filledTonal(
      tooltip: count == 0 ? '通知中心' : '通知中心，$count 条待处理',
      onPressed: () => context.push('/inbox'),
      icon: Badge(
        isLabelVisible: count > 0,
        backgroundColor: AppColors.of(context).overdueMark,
        smallSize: 8,
        child: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}

class HomeCompanion extends ConsumerWidget {
  const HomeCompanion({required this.pet, required this.pets, super.key});
  final PetProfile? pet;
  final List<PetProfile> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    if (pet != null) {
      final count = ref.watch(inboxCountProvider);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: '切换狗狗，当前${pet!.name}',
                  excludeSemantics: true,
                  child: InkWell(
                    borderRadius: AppRadius.chipAll,
                    onTap: () => _selectPet(context, ref),
                    child: Row(
                      children: [
                        _HomeAvatar(pet: pet!, size: 44),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pet!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                              Text(
                                pet!.breed?.isNotEmpty == true
                                    ? pet!.breed!
                                    : '毛健康 · 健康手帐',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const _InboxButton(),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${now.month}月${now.day}日 · ${weekdays[now.weekday - 1]}',
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            count == 0 ? '今天，轻松一点' : '今天还有 $count 件事',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '毛健康',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '今天',
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const _InboxButton(),
            if (pet != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Semantics(
                button: true,
                label: '切换狗狗，当前${pet!.name}',
                child: Material(
                  color: colors.surfaceContainerLow,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _selectPet(context, ref),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _HomeAvatar(pet: pet!, size: 36),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 13),
        Text(
          '${now.month}月${now.day}日 · ${weekdays[now.weekday - 1]}',
          style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 22),
        AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.fast),
          child: _CompanionHero(key: ValueKey(pet?.id ?? 'welcome'), pet: pet),
        ),
      ],
    );
  }

  Future<void> _selectPet(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .7,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '今天陪伴谁？',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            for (final item in pets)
              ListTile(
                leading: _HomeAvatar(pet: item, size: 44),
                title: Text(item.name),
                trailing: item.id == pet?.id
                    ? const Icon(Icons.check_circle_rounded)
                    : null,
                onTap: () => Navigator.pop(context, item.id),
              ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, '__manage__'),
              icon: const Icon(Icons.pets_outlined),
              label: const Text('管理狗狗档案'),
            ),
          ],
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    if (selected == '__manage__') {
      context.go('/pet');
      return;
    }
    try {
      await ref.read(petRepositoryProvider).selectPet(selected);
      if (context.mounted) HapticFeedback.selectionClick();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('切换失败，请重试')));
      }
    }
  }
}

class _CompanionHero extends ConsumerWidget {
  const _CompanionHero({required this.pet, super.key});
  final PetProfile? pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final photo = pet == null
        ? null
        : ref.watch(homePortraitProvider(pet!.id)).value?.firstOrNull;
    final bytes = photo == null
        ? null
        : ref.watch(homePhotoBytesProvider(photo.id)).value;
    final greeting = DateTime.now().hour < 11
        ? '早安，'
        : DateTime.now().hour < 18
        ? '午后好，'
        : '晚上好，';
    final title = pet == null ? '一起，\n好好生活。' : '$greeting\n${pet!.name}';
    final subtitle = pet == null
        ? '从认识毛孩子开始，\n留下属于你们的健康手帐。'
        : '小小的记录，\n是长长久久的陪伴。';
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pet == null ? 'HELLO, LITTLE FRIEND' : 'A LITTLE LOVE, EVERY DAY',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: pet == null ? 25 : 28,
            height: 1.32,
            fontWeight: FontWeight.w700,
            letterSpacing: -.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            height: 1.65,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 14),
        if (pet == null)
          FilledButton(
            onPressed: () => context.go('/pet'),
            child: const Text('创建档案'),
          )
        else
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () => context.go('/pet'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('查看档案'),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
      ],
    );
    final portrait = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _illustration(context),
              )
            : _illustration(context),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = MediaQuery.textScalerOf(context).scale(16) > 23;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      text,
                      const SizedBox(height: 16),
                      SizedBox(height: 190, child: portrait),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: text),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Transform.rotate(angle: .035, child: portrait),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _illustration(BuildContext context) => Image.asset(
    homeIllustration,
    fit: BoxFit.cover,
    cacheWidth: 480,
    excludeFromSemantics: true,
    color: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xCCFFFFFF)
        : null,
    colorBlendMode: BlendMode.modulate,
  );
}

class _HomeAvatar extends ConsumerWidget {
  const _HomeAvatar({required this.pet, required this.size});
  final PetProfile pet;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPhoto =
        ref.watch(homePortraitProvider(pet.id)).value?.isNotEmpty == true;
    final colors = Theme.of(context).colorScheme;
    return hasPhoto
        ? PetPortrait(pet: pet, size: size)
        : CircleAvatar(
            radius: size / 2,
            backgroundColor: colors.primaryContainer,
            child: Icon(
              Icons.pets_rounded,
              size: size * .45,
              color: colors.primary,
            ),
          );
  }
}
