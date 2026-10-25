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

  TextStyle bodyStyle(double size, FontWeight weight, {double height = 1.5}) {
    // 英文用粗体 Fredoka 的地方（列表标题、按钮、记录名称），中文换成
    // ZCOOL KuaiLe；它只有一个字重，不再加粗，免得发糊。
    final bold = isZh && weight.value >= 600;
    return TextStyle(
      fontFamily: PawFonts.latin,
      // 拉丁字母和数字用 Fredoka，Fredoka 没有的中文字回退到中文字体。
      fontFamilyFallback: isZh ? [bold ? PawFonts.zh : PawFonts.zhText] : null,
      fontSize: size,
      height: height,
      fontWeight: bold ? FontWeight.w400 : weight,
      // 数字和字母的粗细由可变字重决定，不受上面的影响。
      fontVariations: PawFonts.weight(weight),
      color: PawColors.ink,
    );
  }

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
    fontFamilyFallback: isZh ? const [PawFonts.zhText] : null,
    extensions: [
      PawTextStyles(
        note: bodyStyle(15, FontWeight.w400, height: 1.55),
        // 中文小标签用标题字体；它只有一个字重，不加粗。
        tag: isZh
            ? headingStyle(12, height: 1.3)
            : bodyStyle(12, FontWeight.w600, height: 1.2),
      ),
    ],
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

/// TextTheme 之外的两种文字：App 对你说的话，和胶囊小标签。
@immutable
class PawTextStyles extends ThemeExtension<PawTextStyles> {
  const PawTextStyles({required this.note, required this.tag});

  /// 卡片正文、页面引导语：像朋友写的便签。
  final TextStyle note;

  /// 类别标签之类的小胶囊。
  final TextStyle tag;

  static PawTextStyles of(BuildContext context) =>
      Theme.of(context).extension<PawTextStyles>()!;

  @override
  PawTextStyles copyWith({TextStyle? note, TextStyle? tag}) =>
      PawTextStyles(note: note ?? this.note, tag: tag ?? this.tag);

  @override
  PawTextStyles lerp(PawTextStyles? other, double t) => other == null
      ? this
      : PawTextStyles(
          note: TextStyle.lerp(note, other.note, t)!,
          tag: TextStyle.lerp(tag, other.tag, t)!,
        );
}
