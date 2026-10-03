import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/ui.dart';
import '../application/care_controller.dart';
import 'care_sheets.dart';

String formatWalkTimer(Duration elapsed) {
  final seconds = elapsed.inSeconds.clamp(0, 86400000);
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final rest = seconds % 60;
  String two(int value) => value.toString().padLeft(2, '0');
  return hours > 0
      ? '$hours:${two(minutes)}:${two(rest)}'
      : '${two(minutes)}:${two(rest)}';
}

/// Floating strip shown above the navigation bar while a walk is running,
/// so the timer and the stop action are reachable from every tab.
class WalkMiniBar extends ConsumerStatefulWidget {
  const WalkMiniBar({super.key});

  @override
  ConsumerState<WalkMiniBar> createState() => _WalkMiniBarState();
}

class _WalkMiniBarState extends ConsumerState<WalkMiniBar> {
  var _finishing = false;

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(
      careControllerProvider.select((s) => s.activeWalkStartedAt != null),
    );
    return AnimatedSwitcher(
      duration: AppMotion.of(context),
      switchInCurve: AppMotion.emphasized,
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        alignment: Alignment.bottomCenter,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: active ? _bar(context) : const SizedBox.shrink(),
    );
  }

  Widget _bar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = AppColors.of(context);
    final elapsed = ref.watch(walkElapsedProvider).value ?? Duration.zero;
    final timer = formatWalkTimer(elapsed);
    return Padding(
      key: const ValueKey('walk-mini-bar'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Material(
        color: colors.primary,
        borderRadius: BorderRadius.circular(18),
        elevation: 2,
        shadowColor: colors.primary.withValues(alpha: .4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
            child: Row(
              children: [
                Icon(Icons.directions_walk_rounded, color: colors.onPrimary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Semantics(
                    liveRegion: false,
                    label: '正在遛狗，已进行 $timer',
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '正在遛狗',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onPrimary.withValues(alpha: .8),
                          ),
                        ),
                        Text(
                          timer,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent.apricot,
                    foregroundColor: accent.onApricot,
                    minimumSize: const Size(64, 40),
                  ),
                  onPressed: _finishing ? null : _finish,
                  child: const Text('结束遛狗'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _finish() async {
    setState(() => _finishing = true);
    try {
      await showFinishWalkSheet(context);
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }
}
