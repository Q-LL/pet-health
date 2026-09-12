import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../core/files/album_asset_types.dart';
import '../../../core/files/local_video_controller.dart';
import '../../pets/data/pet_repository.dart';
import '../data/memory_repository.dart';
import '../domain/memory_entry.dart';

const _quickMoods = ['😊', '🥰', '🤩', '😌', '🥹', '😴', '😢', '🤒'];

class MemoriesTab extends ConsumerWidget {
  const MemoriesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petId = ref.watch(selectedPetIdProvider).value;
    final service = ref.watch(albumAssetServiceProvider);
    if (petId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final memories = ref.watch(memoriesForPetProvider(petId));
    return Stack(
      children: [
        memories.when(
          data: (items) => items.isEmpty
              ? _EmptyMemoriesState(
                  supported: service.isSupported,
                  onCreate: () => _openEditor(context, ref, petId),
                )
              : _MemoryTimeline(
                  items: items,
                  onEdit: (entry) =>
                      _openEditor(context, ref, petId, entry: entry),
                  onDelete: (entry) => _deleteEntry(context, ref, entry),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _LoadError(
            onRetry: () => ref.invalidate(memoriesForPetProvider(petId)),
          ),
        ),
        if (service.isSupported)
          Positioned(
            right: 20,
            bottom: 28,
            child: FloatingActionButton.extended(
              heroTag: 'new-memory',
              tooltip: '记录新的爱宠时光',
              onPressed: () => _openEditor(context, ref, petId),
              icon: const Icon(Icons.add_rounded),
              label: const Text('写随笔'),
            ),
          ),
      ],
    );
  }
}

class _MemoryTimeline extends StatelessWidget {
  const _MemoryTimeline({
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PetMemoryEntry> items;
  final ValueChanged<PetMemoryEntry> onEdit;
  final ValueChanged<PetMemoryEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final entry = items[index];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _MemoryCard(
              entry: entry,
              onEdit: () => onEdit(entry),
              onDelete: () => onDelete(entry),
            ),
          ),
        );
      },
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final PetMemoryEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _formatDateTime(entry.occurredAt),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                if (entry.moodEmoji != null)
                  Semantics(
                    label: '心情贴纸 ${entry.moodEmoji}',
                    child: Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.tertiaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Text(
                        entry.moodEmoji!,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                PopupMenuButton<String>(
                  tooltip: '日志操作',
                  onSelected: (value) =>
                      value == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('编辑')),
                    PopupMenuItem(value: 'delete', child: Text('删除')),
                  ],
                ),
              ],
            ),
            if (entry.media.isNotEmpty) ...[
              const SizedBox(height: 12),
              _MemoryMedia(entry.media),
            ],
            if (entry.note.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                entry.note,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemoryMedia extends ConsumerStatefulWidget {
  const _MemoryMedia(this.media);

  final List<MemoryMediaReference> media;

  @override
  ConsumerState<_MemoryMedia> createState() => _MemoryMediaState();
}

class _MemoryMediaState extends ConsumerState<_MemoryMedia> {
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    final first = widget.media.first;
    if (first.kind == AlbumAssetKind.video) {
      return _VideoCover(media: first);
    }
    final pages = <List<MemoryMediaReference>>[];
    for (var index = 0; index < widget.media.length; index += 2) {
      pages.add(
        widget.media.sublist(index, (index + 2).clamp(0, widget.media.length)),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: pages.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (context, index) {
              final page = pages[index];
              return Row(
                children: [
                  for (
                    var itemIndex = 0;
                    itemIndex < page.length;
                    itemIndex++
                  ) ...[
                    if (itemIndex > 0) const SizedBox(width: 8),
                    Expanded(child: _PhotoTile(media: page[itemIndex])),
                  ],
                ],
              );
            },
          ),
        ),
        if (widget.media.length > 2) ...[
          const SizedBox(height: 8),
          Text(
            '${_page * 2 + 1}–${((_page + 1) * 2).clamp(0, widget.media.length)} / '
            '${widget.media.length}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _PhotoTile extends ConsumerWidget {
  const _PhotoTile({required this.media});

  final MemoryMediaReference media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(albumAssetServiceProvider);
    return Semantics(
      button: true,
      label: '查看爱宠照片',
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showPhotoPreview(context, service, media.platformRef),
          child: FutureBuilder<Uint8List?>(
            future: service.requestThumbnail(media.platformRef),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final bytes = snapshot.data;
              if (bytes == null) return const _UnavailableMedia();
              return Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => const _UnavailableMedia(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VideoCover extends ConsumerWidget {
  const _VideoCover({required this.media});

  final MemoryMediaReference media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(albumAssetServiceProvider);
    return Semantics(
      button: true,
      label: '播放爱宠视频',
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _VideoViewer(
                service: service,
                platformRef: media.platformRef,
              ),
            ),
          ),
          child: SizedBox(
            height: 240,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FutureBuilder<Uint8List?>(
                  future: service.requestThumbnail(media.platformRef),
                  builder: (context, snapshot) {
                    final bytes = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (bytes == null) return const _UnavailableMedia();
                    return Image.memory(bytes, fit: BoxFit.cover);
                  },
                ),
                Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .58),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                if (media.durationMs != null)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: _DurationBadge(media.durationMs!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge(this.durationMs);

  final int durationMs;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: durationMs);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$minutes:${seconds.toString().padLeft(2, '0')}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _UnavailableMedia extends StatelessWidget {
  const _UnavailableMedia();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: colors.onSurfaceVariant,
              size: 34,
            ),
            const SizedBox(height: 8),
            Text(
              '原媒体不可用\n可编辑日志重新选择',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryEditorPage extends ConsumerStatefulWidget {
  const _MemoryEditorPage({required this.petId, this.entry});

  final String petId;
  final PetMemoryEntry? entry;

  @override
  ConsumerState<_MemoryEditorPage> createState() => _MemoryEditorPageState();
}

class _MemoryEditorPageState extends ConsumerState<_MemoryEditorPage> {
  late final TextEditingController _noteController;
  late DateTime _occurredAt;
  late String? _moodEmoji;
  late List<AlbumAssetReference> _media;
  var _saving = false;
  var _picking = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _noteController = TextEditingController(text: entry?.note ?? '');
    _occurredAt = entry?.occurredAt ?? DateTime.now();
    _moodEmoji = entry?.moodEmoji;
    _media =
        entry?.media
            .map(
              (item) => AlbumAssetReference(
                platformRef: item.platformRef,
                kind: item.kind,
                width: item.width,
                height: item.height,
                durationMs: item.durationMs,
                capturedAt: item.capturedAt,
              ),
            )
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑爱宠时光' : '记录爱宠时光'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: [
            _EditorSection(
              title: '记录时间',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule_rounded),
                title: Text(_formatDateTime(_occurredAt)),
                subtitle: const Text('可改为照片或事件实际发生的时间'),
                trailing: const Icon(Icons.edit_calendar_rounded),
                onTap: _pickDateTime,
              ),
            ),
            const SizedBox(height: 16),
            _EditorSection(
              title: '心情贴纸（可选）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final mood in _quickMoods)
                        _MoodButton(
                          emoji: mood,
                          selected: _moodEmoji == mood,
                          onTap: () => setState(() => _moodEmoji = mood),
                        ),
                      ActionChip(
                        avatar: const Icon(
                          Icons.add_reaction_outlined,
                          size: 20,
                        ),
                        label: const Text('更多'),
                        onPressed: _pickMoreMood,
                      ),
                      if (_moodEmoji != null)
                        ActionChip(
                          avatar: const Icon(Icons.close_rounded, size: 20),
                          label: const Text('清除'),
                          onPressed: () => setState(() => _moodEmoji = null),
                        ),
                    ],
                  ),
                  if (_moodEmoji != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      '当前心情  $_moodEmoji',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _EditorSection(
              title: '照片或视频',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _picking ? null : _addPhotos,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: Text(
                            _media.firstOrNull?.kind == AlbumAssetKind.image
                                ? '继续添加照片'
                                : '选择照片',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _picking ? null : _chooseVideo,
                          icon: const Icon(Icons.video_library_outlined),
                          label: const Text('选择视频'),
                        ),
                      ),
                    ],
                  ),
                  if (_picking) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(),
                  ],
                  if (_media.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _SelectedMediaStrip(
                      media: _media,
                      onRemove: _removeMedia,
                      onMove: _moveMedia,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '照片可分批添加并左右滑动展示；视频每篇只能选择一个。媒体仍由系统相册保管。',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _EditorSection(
              title: '随笔',
              child: TextField(
                controller: _noteController,
                minLines: 5,
                maxLines: 12,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: '今天发生了什么？写下你想记住的瞬间……',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    if (time == null) return;
    setState(() {
      _occurredAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickMoreMood() async {
    final mood = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .62,
        child: EmojiPicker(
          onEmojiSelected: (_, emoji) => Navigator.of(context).pop(emoji.emoji),
          config: const Config(height: 420),
        ),
      ),
    );
    if (mood != null && mounted) setState(() => _moodEmoji = mood);
  }

  Future<void> _addPhotos() async {
    setState(() => _picking = true);
    try {
      final picked = await ref.read(albumAssetServiceProvider).pickImages();
      if (!mounted || picked.isEmpty) return;
      setState(() {
        if (_media.firstOrNull?.kind == AlbumAssetKind.video) _media.clear();
        final existing = _media.map((item) => item.platformRef).toSet();
        _media.addAll(picked.where((item) => existing.add(item.platformRef)));
      });
      await _warnForReferenceLimit();
    } catch (error) {
      _showError(error, fallback: '无法读取所选照片，请检查相册权限');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _chooseVideo() async {
    setState(() => _picking = true);
    try {
      final picked = await ref.read(albumAssetServiceProvider).pickVideo();
      if (!mounted || picked == null) return;
      setState(() => _media = [picked]);
      await _warnForReferenceLimit();
    } catch (error) {
      _showError(error, fallback: '无法读取所选视频，请检查相册权限');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _warnForReferenceLimit() async {
    final persistedCount = await ref
        .read(memoryRepositoryProvider)
        .distinctReferenceCount();
    final selectedCount = _media.map((item) => item.platformRef).toSet().length;
    final projectedCount = persistedCount + selectedCount;
    if (!mounted || projectedCount < androidAlbumReferenceWarningThreshold) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('系统相册引用预计使用 $projectedCount / 5000，请留意旧媒体授权')),
    );
  }

  void _removeMedia(int index) {
    setState(() => _media.removeAt(index));
  }

  void _moveMedia(int from, int delta) {
    final to = from + delta;
    if (to < 0 || to >= _media.length) return;
    setState(() {
      final item = _media.removeAt(from);
      _media.insert(to, item);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final repository = ref.read(memoryRepositoryProvider);
      if (widget.entry == null) {
        await repository.create(
          petId: widget.petId,
          occurredAt: _occurredAt,
          note: _noteController.text,
          moodEmoji: _moodEmoji,
          media: _media,
        );
      } else {
        await repository.update(
          widget.entry!.id,
          occurredAt: _occurredAt,
          note: _noteController.text,
          moodEmoji: _moodEmoji,
          media: _media,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      _showError(error, fallback: '保存失败，请稍后重试');
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(Object error, {required String fallback}) {
    if (!mounted) return;
    final message = error is FormatException ? error.message : fallback;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '选择心情 $emoji',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.tertiaryContainer
                : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? colors.tertiary : colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}

class _SelectedMediaStrip extends ConsumerWidget {
  const _SelectedMediaStrip({
    required this.media,
    required this.onRemove,
    required this.onMove,
  });

  final List<AlbumAssetReference> media;
  final ValueChanged<int> onRemove;
  final void Function(int index, int delta) onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(albumAssetServiceProvider);
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = media[index];
          return SizedBox(
            width: 116,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FutureBuilder<Uint8List?>(
                      future: service.requestThumbnail(item.platformRef),
                      builder: (context, snapshot) {
                        final bytes = snapshot.data;
                        if (bytes == null) {
                          return ColoredBox(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const _UnavailableMedia(),
                          );
                        }
                        return Image.memory(bytes, fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton.filled(
                    tooltip: '移除媒体',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onRemove(index),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                if (media.length > 1)
                  Positioned(
                    left: 2,
                    right: 2,
                    bottom: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filledTonal(
                          tooltip: '向前移动',
                          onPressed: index == 0
                              ? null
                              : () => onMove(index, -1),
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                        IconButton.filledTonal(
                          tooltip: '向后移动',
                          onPressed: index == media.length - 1
                              ? null
                              : () => onMove(index, 1),
                          icon: const Icon(Icons.chevron_right_rounded),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _VideoViewer extends StatefulWidget {
  const _VideoViewer({required this.service, required this.platformRef});

  final AlbumAssetService service;
  final String platformRef;

  @override
  State<_VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<_VideoViewer> {
  VideoPlayerController? _controller;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final playable = await widget.service.openAsset(widget.platformRef);
      if (playable == null) throw StateError('原视频不可用');
      final controller = createLocalVideoController(playable);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      await controller.play();
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text('爱宠视频'),
      ),
      body: Center(
        child: _error != null
            ? const Text(
                '原视频不可用，请返回后编辑日志重新选择。',
                style: TextStyle(color: Colors.white),
              )
            : controller == null
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller),
                    IconButton.filled(
                      tooltip: controller.value.isPlaying ? '暂停' : '播放',
                      onPressed: () => setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      }),
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _EmptyMemoriesState extends StatelessWidget {
  const _EmptyMemoriesState({required this.supported, required this.onCreate});

  final bool supported;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 58),
                const SizedBox(height: 20),
                Text(
                  '还没有爱宠时光',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  supported
                      ? '用随笔、心情和系统相册里的真实瞬间，记录毛孩子的每一天。'
                      : '爱宠时光需要在 iPhone 或 Android 手机上使用系统相册。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                if (supported) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('记录第一篇'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('爱宠时光读取失败'),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

Future<void> _openEditor(
  BuildContext context,
  WidgetRef ref,
  String petId, {
  PetMemoryEntry? entry,
}) async {
  final service = ref.read(albumAssetServiceProvider);
  if (!service.isSupported) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请在 iPhone 或 Android 手机上使用此功能')),
    );
    return;
  }
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _MemoryEditorPage(petId: petId, entry: entry),
    ),
  );
}

Future<void> _deleteEntry(
  BuildContext context,
  WidgetRef ref,
  PetMemoryEntry entry,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('删除这篇爱宠时光？'),
      content: const Text('随笔和心情会被删除，但不会删除系统相册中的照片或视频。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref.read(memoryRepositoryProvider).delete(entry.id);
}

Future<void> _showPhotoPreview(
  BuildContext context,
  AlbumAssetService service,
  String platformRef,
) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: const Text('爱宠照片'),
        ),
        body: Center(
          child: FutureBuilder<Uint8List?>(
            future: service.requestPreview(platformRef),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final bytes = snapshot.data;
              if (bytes == null) {
                return const Text(
                  '原照片不可用，请返回后编辑日志重新选择。',
                  style: TextStyle(color: Colors.white),
                );
              }
              return InteractiveViewer(
                maxScale: 5,
                child: Image.memory(bytes, fit: BoxFit.contain),
              );
            },
          ),
        ),
      ),
    ),
  );
}

String _formatDateTime(DateTime value) {
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.year}年${value.month}月${value.day}日 '
      '${value.hour}:$minute';
}
