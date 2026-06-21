import 'package:flutter/material.dart';

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 360);
  static const slow = Duration(milliseconds: 560);
  static const emphasized = Curves.easeOutCubic;
}

class EntranceAnimation extends StatelessWidget {
  const EntranceAnimation({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 18),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final total = AppMotion.slow + delay;
    final delayFraction = delay.inMilliseconds / total.inMilliseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(delayFraction, 1, curve: AppMotion.emphasized),
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(offset.dx * (1 - value), offset.dy * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}

class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, super.key});

  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  var _scale = 1.0;

  void _setScale(double value) {
    if (_scale == value) return;
    setState(() => _scale = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setScale(.985),
      onExit: (_) => _setScale(1),
      child: Listener(
        onPointerDown: (_) => _setScale(.97),
        onPointerUp: (_) => _setScale(1),
        onPointerCancel: (_) => _setScale(1),
        child: AnimatedScale(
          scale: _scale,
          duration: AppMotion.fast,
          curve: AppMotion.emphasized,
          child: widget.child,
        ),
      ),
    );
  }
}
