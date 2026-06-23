import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/files/image_file_picker.dart';
import '../../../core/widgets/page_frame.dart';
import '../data/pet_photo_repository.dart';
import '../data/pet_repository.dart';
import '../domain/pet_photo.dart';
import '../domain/pet_photo_filter.dart';

class PetPhotosPage extends ConsumerStatefulWidget {
  const PetPhotosPage({super.key});

  @override
  ConsumerState<PetPhotosPage> createState() => _PetPhotosPageState();
}

class _PetPhotosPageState extends ConsumerState<PetPhotosPage> {
  var _keyword = '';

  String? get _searchKeyword =>
      _keyword.trim().isEmpty ? null : _keyword.trim();

  @override
  Widget build(BuildContext context) {
    final petId = ref.watch(selectedPetIdProvider).value;
    final petName = ref.watch(petsProvider).value;
    final current = petName?.where((p) => p.id == petId).firstOrNull;
    final displayName = current?.name ?? '狗狗';

    final filter = petId == null
        ? null
        : PetPhotoFilter(petId: petId, keyword: _searchKeyword);
    final photos = filter == null
        ? const AsyncValue<List<PetPhoto>>.loading()
        : ref.watch(filteredPetPhotosProvider(filter));

    return PageFrame(
      title: '$displayName的照片',
      subtitle: '管理狗狗照片：设为头像、修改说明或删除。',
      actions: [
        IconButton.filledTonal(
          tooltip: '返回狗狗列表',
          onPressed: () => context.go('/pets'),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 12),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: '搜索文件名或说明…',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => setState(() => _keyword = ''),
                    )
                  : null,
            ),
            onChanged: (value) => setState(() => _keyword = value),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: petId == null ? null : () => _uploadPhoto(petId),
            icon: const Icon(Icons.add_photo_alternate_rounded),
            label: const Text('上传照片'),
          ),
          const SizedBox(height: 16),
          photos.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _ErrorCard(message: error.toString()),
            data: (items) {
              if (items.isEmpty) {
                return _EmptyPhotos(
                  onUpload: petId == null ? null : () => _uploadPhoto(petId),
                );
              }
              return _PhotoGrid(photos: items);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadPhoto(String petId) async {
    try {
      final photo = await pickPetPhotoFile();
      if (photo == null || !mounted) return;
      await ref
          .read(petPhotoRepositoryProvider)
          .add(
            petId: petId,
            bytes: photo.bytes,
            originalName: photo.name,
            mediaType: photo.mediaType,
            setAsAvatar: false,
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('照片已上传')));
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('上传失败：$error')));
      }
    }
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photos});

  final List<PetPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 520 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return _PhotoCard(photo: photo);
          },
        );
      },
    );
  }
}

class _PhotoCard extends ConsumerWidget {
  const _PhotoCard({required this.photo});

  final PetPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final bytesFuture = ref.watch(_photoBytesProvider(photo.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      color: photo.isAvatar ? colors.primaryContainer : colors.surfaceContainer,
      child: InkWell(
        onTap: () => _showPhotoActions(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: bytesFuture.when(
                loading: () => Container(
                  color: colors.surfaceContainerHighest,
                  child: const Center(
                    child: SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, _) => Container(
                  color: colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 36,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                data: (bytes) => Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.caption.isEmpty
                          ? photo.originalName
                          : photo.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  if (photo.isAvatar) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.star_rounded, size: 16, color: colors.primary),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PhotoActionSheet(photo: photo),
    );
  }
}

class _PhotoActionSheet extends ConsumerStatefulWidget {
  const _PhotoActionSheet({required this.photo});

  final PetPhoto photo;

  @override
  ConsumerState<_PhotoActionSheet> createState() => _PhotoActionSheetState();
}

class _PhotoActionSheetState extends ConsumerState<_PhotoActionSheet> {
  late final TextEditingController _caption;

  @override
  void initState() {
    super.initState();
    _caption = TextEditingController(text: widget.photo.caption);
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final photo = widget.photo;
    final bytesFuture = ref.watch(_photoBytesProvider(photo.id));

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  color: colors.surfaceContainerHighest,
                  child: bytesFuture.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const Center(
                      child: Icon(Icons.broken_image_outlined, size: 48),
                    ),
                    data: (bytes) => Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (photo.isAvatar) ...[
                  Icon(Icons.star_rounded, color: colors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text('当前头像', style: TextStyle(color: colors.primary)),
                ] else
                  Text(
                    photo.originalName,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                const Spacer(),
                Text(
                  _formatDate(photo.createdAt.toLocal()),
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caption,
              decoration: const InputDecoration(
                labelText: '照片说明',
                hintText: '例如：在公园散步',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: photo.isAvatar ? null : () => _setAvatar(ref),
                    icon: const Icon(Icons.star_outline_rounded),
                    label: const Text('设为头像'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _saveCaption(ref),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('保存说明'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => _deletePhoto(ref),
              style: FilledButton.styleFrom(foregroundColor: colors.error),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('删除照片'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAvatar(WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(petPhotoRepositoryProvider).setAvatar(widget.photo.id);
      if (mounted) {
        navigator.pop();
        messenger.showSnackBar(const SnackBar(content: Text('已设为头像')));
      }
    } on Object catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('操作失败：$error')));
      }
    }
  }

  Future<void> _saveCaption(WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref
          .read(petPhotoRepositoryProvider)
          .updateMetadata(
            widget.photo.id,
            caption: _caption.text,
            capturedAt: widget.photo.capturedAt,
          );
      if (mounted) {
        navigator.pop();
        messenger.showSnackBar(const SnackBar(content: Text('说明已更新')));
      }
    } on Object catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('保存失败：$error')));
      }
    }
  }

  Future<void> _deletePhoto(WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除这张照片？'),
        content: const Text('照片将从本机永久删除，此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(petPhotoRepositoryProvider).delete(widget.photo.id);
      if (mounted) {
        navigator.pop();
        messenger.showSnackBar(const SnackBar(content: Text('照片已删除')));
      }
    } on Object catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('删除失败：$error')));
      }
    }
  }
}

final _photoBytesProvider = FutureProvider.autoDispose
    .family<Uint8List, String>((ref, photoId) {
      return ref.watch(petPhotoRepositoryProvider).readBytes(photoId);
    });

class _EmptyPhotos extends StatelessWidget {
  const _EmptyPhotos({this.onUpload});

  final VoidCallback? onUpload;

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
            child: Icon(
              Icons.photo_library_outlined,
              size: 42,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text('还没有照片', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          const Text('上传狗狗照片，可以设为头像或添加说明来记录美好瞬间。', textAlign: TextAlign.center),
          const SizedBox(height: 26),
          if (onUpload != null)
            FilledButton.icon(
              onPressed: onUpload,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('上传第一张照片'),
            ),
        ],
      ),
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
      child: Text('读取照片失败：$message'),
    ),
  );
}

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
