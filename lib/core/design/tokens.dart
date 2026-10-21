import 'package:flutter/painting.dart';

import '../../features/cards/domain/card_codes.dart';
import '../../features/entries/domain/entry_codes.dart';

/// v1「软糖贴纸」设计语言的颜色。对应 docs/V1_PLAN.md 选定的方向 B。
///
/// 文字颜色都在对应底色上满足 4.5:1；珊瑚色 [coral] 只做底色，
/// 上面的文字用 [ink]，作文字时用 [coralText]。
abstract final class PawColors {
  static const ground = Color(0xFFFFF4EC);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF2E2A35);
  static const inkMuted = Color(0xFF645B6E);
  static const hairline = Color(0xFFF3ECEF);
  static const subtle = Color(0xFFF5F0F7);

  static const coral = Color(0xFFF0785A);
  static const coralText = Color(0xFFB8432A);
  static const peach = Color(0xFFFFD9C7);
  static const peachDeep = Color(0xFFFFC6AE);

  static const navBar = ink;
  static const navActive = Color(0xFFFFC9B2);
  static const navIdle = Color(0xFFD8D3E0);

  static const success = Color(0xFF2F7A48);
  static const successSoft = Color(0xFFC9EBD2);

  static const scrim = Color(0x732E2A35);
}

/// 一组底色和与之搭配的前景色（图标、文字）。
class PawTone {
  const PawTone(this.fill, this.onFill);

  final Color fill;
  final Color onFill;
}

abstract final class PawTones {
  static const peach = PawTone(Color(0xFFFFC9B2), Color(0xFF8F3220));
  static const sky = PawTone(Color(0xFFBFE3F0), Color(0xFF1F5A6E));
  static const sand = PawTone(Color(0xFFF2DDB8), Color(0xFF6E4A1F));
  static const mint = PawTone(Color(0xFFC9EBD2), Color(0xFF245C36));
  static const lilac = PawTone(Color(0xFFE4E0FA), Color(0xFF4A3F8C));
  static const butter = PawTone(Color(0xFFFFF0BE), Color(0xFF7A560E));
  static const blush = PawTone(Color(0xFFFFE3D6), Color(0xFFA0381F));
  static const mist = PawTone(Color(0xFFF5F0F7), Color(0xFF2E2A35));

  /// 每种记录类型的图标底色。
  static PawTone forEntry(EntryType type) => switch (type) {
    EntryType.meal || EntryType.parasitePrevention => peach,
    EntryType.water || EntryType.bath => sky,
    EntryType.potty || EntryType.weight => sand,
    EntryType.brushing => mint,
    EntryType.walk || EntryType.earCheck => lilac,
    EntryType.otherCare || EntryType.vetTest => butter,
    EntryType.grooming || EntryType.symptom || EntryType.medication => blush,
    EntryType.vaccine || EntryType.custom => mist,
  };
}

/// 每日卡片：底色、类别标签的底色和文字色。
class CardTone {
  const CardTone({required this.fill, required this.tag, required this.onTag});

  final Color fill;
  final Color tag;
  final Color onTag;

  static CardTone of(CardCategory category) => switch (category) {
    CardCategory.observation => const CardTone(
      fill: Color(0xFFD6F0DE),
      tag: Color(0xFF2F7A48),
      onTag: Color(0xFFFFFFFF),
    ),
    CardCategory.comingUp => const CardTone(
      fill: Color(0xFFFFE3D6),
      tag: Color(0xFFB8432A),
      onTag: Color(0xFFFFFFFF),
    ),
    CardCategory.moment => const CardTone(
      fill: Color(0xFFFFF0BE),
      tag: Color(0xFF8A6110),
      onTag: Color(0xFFFFFFFF),
    ),
    CardCategory.tip => const CardTone(
      fill: Color(0xFFE4E0FA),
      tag: Color(0xFF4A3F8C),
      onTag: Color(0xFFFFFFFF),
    ),
  };
}

abstract final class PawRadii {
  static const chip = 999.0;
  static const tile = 20.0;
  static const row = 26.0;
  static const card = 30.0;
  static const hero = 34.0;
  static const sheet = 36.0;
}

abstract final class PawSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 20.0;
  static const xl = 28.0;

  /// 页面左右留白。
  static const page = 20.0;

  /// 可点区域的最小边长。
  static const touch = 48.0;
}

/// 字体。标题在中文界面用 ZCOOL KuaiLe，英文界面用 Fredoka；
/// 正文用 Fredoka 显示拉丁字母和数字，中文自动回退到系统字体。
abstract final class PawFonts {
  static const zh = 'ZCOOLKuaiLe';
  static const latin = 'Fredoka';

  static String headingFor(Locale locale) =>
      locale.languageCode == 'zh' ? zh : latin;

  /// Fredoka 是可变字重字体，需要同时指定 [FontVariation]。
  static List<FontVariation> weight(FontWeight weight) => [
    FontVariation.weight(weight.value.toDouble()),
  ];
}
