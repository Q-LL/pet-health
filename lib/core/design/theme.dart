import 'package:flutter/material.dart';

import 'tokens.dart';

/// 按界面语言生成主题：标题字体随语言切换，其余一致。
ThemeData buildPawTheme(Locale locale) {
  final heading = PawFonts.headingFor(locale);
  // ZCOOL KuaiLe 只有一个字重，加粗反而发糊；Fredoka 用 600–700。
  final isZh = heading == PawFonts.zh;

  TextStyle headingStyle(double size, {double height = 1.15}) => TextStyle(
    fontFamily: heading,
    fontSize: size,
    height: height,
    fontWeight: isZh ? FontWeight.w400 : FontWeight.w700,
    fontVariations: isZh ? null : PawFonts.weight(FontWeight.w700),
    color: PawColors.ink,
  );

  TextStyle bodyStyle(double size, FontWeight weight, {double height = 1.5}) =>
      TextStyle(
        fontFamily: PawFonts.latin,
        fontSize: size,
        height: height,
        fontWeight: weight,
        fontVariations: PawFonts.weight(weight),
        color: PawColors.ink,
      );

  final textTheme = TextTheme(
    displaySmall: headingStyle(32),
    headlineMedium: headingStyle(30),
    headlineSmall: headingStyle(24),
    titleLarge: headingStyle(20),
    titleMedium: bodyStyle(16, FontWeight.w600, height: 1.3),
    titleSmall: bodyStyle(14, FontWeight.w600, height: 1.3),
    bodyLarge: bodyStyle(16, FontWeight.w400),
    bodyMedium: bodyStyle(15, FontWeight.w400),
    bodySmall: bodyStyle(
      13,
      FontWeight.w400,
    ).copyWith(color: PawColors.inkMuted),
    labelLarge: bodyStyle(15, FontWeight.w600, height: 1.2),
    labelMedium: bodyStyle(12, FontWeight.w600, height: 1.2),
    labelSmall: bodyStyle(11, FontWeight.w500, height: 1.2),
  );

  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: PawColors.coral,
    onPrimary: PawColors.ink,
    secondary: PawColors.success,
    onSecondary: Colors.white,
    error: PawColors.coralText,
    onError: Colors.white,
    surface: PawColors.surface,
    onSurface: PawColors.ink,
    onSurfaceVariant: PawColors.inkMuted,
    surfaceContainerHighest: PawColors.subtle,
    outline: PawColors.hairline,
  );

  final pill = WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(PawRadii.chip)),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PawColors.ground,
    textTheme: textTheme,
    fontFamily: PawFonts.latin,
    splashFactory: InkSparkle.splashFactory,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: pill,
        minimumSize: const WidgetStatePropertyAll(Size(64, PawSpace.touch)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20),
        ),
        textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: pill,
        minimumSize: const WidgetStatePropertyAll(Size(48, PawSpace.touch)),
        foregroundColor: const WidgetStatePropertyAll(PawColors.coralText),
        textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PawColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PawRadii.tile),
        borderSide: const BorderSide(color: Color(0xFFEDE6F0), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PawRadii.tile),
        borderSide: const BorderSide(color: Color(0xFFEDE6F0), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PawRadii.tile),
        borderSide: const BorderSide(color: PawColors.coral, width: 2),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: PawColors.surface,
      modalBarrierColor: PawColors.scrim,
      showDragHandle: true,
      dragHandleColor: Color(0xFFE3DCE8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PawRadii.sheet),
        ),
      ),
    ),
  );
}
