import 'package:flutter/material.dart';

/// Raw palette. Widgets read colors through [ColorScheme] or [AppColors];
/// only the theme builder touches these values directly.
abstract final class AppPalette {
  static const forest = Color(0xFF254D43);
  static const forestDeep = Color(0xFF173B30);
  static const sage = Color(0xFFBDCDB8);
  static const apricot = Color(0xFFF2D4BF);
  static const apricotInk = Color(0xFF5A2E14);
  static const overdue = Color(0xFF8A4A24);
  static const overdueMark = Color(0xFFC4632F);

  static const paper = Color(0xFFF7F6F2);
  static const card = Color(0xFFFFFFFF);
  static const mist = Color(0xFFEEEFE7);
  static const mint = Color(0xFFE7EDE3);
  static const line = Color(0xFFE2E5DB);
  static const lineStrong = Color(0xFFD6DBCF);
  static const ink = Color(0xFF252B28);
  static const inkMuted = Color(0xFF5F695F);

  static const nightPaper = Color(0xFF171E1B);
  static const nightCard = Color(0xFF202A24);
  static const nightMist = Color(0xFF27332C);
  static const nightMint = Color(0xFF33483A);
  static const nightLine = Color(0xFF3C493F);
  static const nightInk = Color(0xFFE8EDE6);
  static const nightInkMuted = Color(0xFFB5C0B7);
  static const nightForest = Color(0xFFB4D3BE);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;

  /// Horizontal page gutter.
  static const page = 20.0;

  /// Vertical gap between page sections.
  static const section = 24.0;

  /// Bottom padding that keeps content clear of the navigation bar.
  static const navClearance = 112.0;

  static const maxContentWidth = 680.0;
  static const minTouchTarget = 44.0;
}

abstract final class AppRadius {
  static const chip = 12.0;
  static const button = 16.0;
  static const card = 20.0;
  static const sheet = 28.0;

  static final chipAll = BorderRadius.circular(chip);
  static final buttonAll = BorderRadius.circular(button);
  static final cardAll = BorderRadius.circular(card);
}

/// Serif stack for page titles and greetings. Resolves to the system CJK
/// serif (Songti on Apple platforms, Noto Serif CJK on Android).
const appSerifFallback = ['Songti SC', 'Noto Serif CJK SC', 'Noto Serif SC'];

/// Colors that have no slot in [ColorScheme].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.sage,
    required this.onSage,
    required this.apricot,
    required this.onApricot,
    required this.overdue,
    required this.overdueMark,
  });

  static const light = AppColors(
    sage: AppPalette.sage,
    onSage: AppPalette.forest,
    apricot: AppPalette.apricot,
    onApricot: AppPalette.apricotInk,
    overdue: AppPalette.overdue,
    overdueMark: AppPalette.overdueMark,
  );

  static const dark = AppColors(
    sage: Color(0xFF3F5A4A),
    onSage: AppPalette.nightForest,
    apricot: Color(0xFF5C3B27),
    onApricot: Color(0xFFF6DCCB),
    overdue: Color(0xFFF0B48F),
    overdueMark: Color(0xFFE08A5C),
  );

  final Color sage;
  final Color onSage;
  final Color apricot;
  final Color onApricot;

  /// Text color for overdue or needs-attention states.
  final Color overdue;

  /// Stroke color for overdue checkmarks and dots.
  final Color overdueMark;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({
    Color? sage,
    Color? onSage,
    Color? apricot,
    Color? onApricot,
    Color? overdue,
    Color? overdueMark,
  }) => AppColors(
    sage: sage ?? this.sage,
    onSage: onSage ?? this.onSage,
    apricot: apricot ?? this.apricot,
    onApricot: onApricot ?? this.onApricot,
    overdue: overdue ?? this.overdue,
    overdueMark: overdueMark ?? this.overdueMark,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      sage: Color.lerp(sage, other.sage, t)!,
      onSage: Color.lerp(onSage, other.onSage, t)!,
      apricot: Color.lerp(apricot, other.apricot, t)!,
      onApricot: Color.lerp(onApricot, other.onApricot, t)!,
      overdue: Color.lerp(overdue, other.overdue, t)!,
      overdueMark: Color.lerp(overdueMark, other.overdueMark, t)!,
    );
  }
}
