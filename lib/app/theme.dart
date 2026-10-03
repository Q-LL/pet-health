import 'package:flutter/material.dart';

import '../core/ui/tokens.dart';

/// The single theme for the whole app: warm paper ground with forest green.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ColorScheme scheme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return ColorScheme.fromSeed(
      seedColor: AppPalette.forest,
      brightness: brightness,
    ).copyWith(
      primary: dark ? AppPalette.nightForest : AppPalette.forest,
      onPrimary: dark ? AppPalette.forestDeep : Colors.white,
      primaryContainer: dark ? AppPalette.nightMint : AppPalette.mint,
      onPrimaryContainer: dark ? AppPalette.nightInk : AppPalette.forest,
      secondaryContainer: dark ? AppPalette.nightMint : AppPalette.mint,
      onSecondaryContainer: dark ? AppPalette.nightInk : AppPalette.forest,
      tertiary: dark ? const Color(0xFFF0B48F) : AppPalette.overdue,
      onTertiary: dark ? const Color(0xFF3F2210) : Colors.white,
      tertiaryContainer: dark ? const Color(0xFF5C3B27) : AppPalette.apricot,
      onTertiaryContainer: dark
          ? const Color(0xFFF6DCCB)
          : AppPalette.apricotInk,
      surface: dark ? AppPalette.nightPaper : AppPalette.paper,
      onSurface: dark ? AppPalette.nightInk : AppPalette.ink,
      onSurfaceVariant: dark ? AppPalette.nightInkMuted : AppPalette.inkMuted,
      surfaceContainerLowest: dark ? AppPalette.nightPaper : AppPalette.card,
      surfaceContainerLow: dark ? AppPalette.nightCard : AppPalette.card,
      surfaceContainer: dark ? AppPalette.nightMist : AppPalette.mist,
      surfaceContainerHigh: dark ? AppPalette.nightMist : AppPalette.mist,
      surfaceContainerHighest: dark ? AppPalette.nightMint : AppPalette.line,
      outline: dark ? AppPalette.nightInkMuted : AppPalette.lineStrong,
      outlineVariant: dark ? AppPalette.nightLine : AppPalette.line,
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final colors = scheme(brightness);
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    const serif = TextStyle(fontFamilyFallback: appSerifFallback);

    final textTheme = base.textTheme
        .copyWith(
          displaySmall: serif.copyWith(
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: serif.copyWith(
            fontSize: 30,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: serif.copyWith(
            fontSize: 28,
            height: 1.3,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: serif.copyWith(
            fontSize: 22,
            height: 1.3,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: const TextStyle(fontSize: 16, height: 1.55),
          bodyMedium: const TextStyle(fontSize: 15, height: 1.5),
          bodySmall: const TextStyle(fontSize: 12, height: 1.45),
          labelLarge: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        )
        .apply(bodyColor: colors.onSurface, displayColor: colors.onSurface);

    final buttonShape = RoundedRectangleBorder(
      borderRadius: AppRadius.buttonAll,
    );
    const buttonSize = Size(AppSpacing.minTouchTarget, 48);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      splashFactory: InkSparkle.splashFactory,
      extensions: [
        brightness == Brightness.dark ? AppColors.dark : AppColors.light,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.primary,
        minVerticalPadding: 10,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : colors.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 23,
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : colors.onSurfaceVariant,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 3,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: buttonShape,
          side: BorderSide(color: colors.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, 40),
          shape: buttonShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSpacing.minTouchTarget),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, 40),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.chipAll),
          side: BorderSide(color: colors.outline),
          selectedBackgroundColor: colors.primary,
          selectedForegroundColor: colors.onPrimary,
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colors.outline),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipAll),
        backgroundColor: colors.surfaceContainerLow,
        selectedColor: colors.primary,
        secondarySelectedColor: colors.primary,
        checkmarkColor: colors.onPrimary,
        labelStyle: textTheme.bodyMedium,
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onPrimary,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.buttonAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonAll,
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: colors.surfaceContainerLow,
        modalBackgroundColor: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainer,
      ),
    );
  }
}
