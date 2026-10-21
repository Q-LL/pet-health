import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 白边贴纸风的插画。每张贴纸自带白色描边，[Sticker] 再加一层柔和阴影。
enum StickerArt {
  /// 金毛头像（贴纸版，眯眼笑）。
  golden(132, '''
<g stroke="#FFFFFF" stroke-width="10" stroke-linejoin="round">
<ellipse cx="34" cy="64" rx="17" ry="31" fill="#FFFFFF" transform="rotate(16 34 64)"/>
<ellipse cx="98" cy="64" rx="17" ry="31" fill="#FFFFFF" transform="rotate(-16 98 64)"/>
<ellipse cx="66" cy="66" rx="37" ry="39" fill="#FFFFFF"/>
</g>
<ellipse cx="34" cy="64" rx="17" ry="31" fill="#D9934A" transform="rotate(16 34 64)"/>
<ellipse cx="98" cy="64" rx="17" ry="31" fill="#D9934A" transform="rotate(-16 98 64)"/>
<ellipse cx="66" cy="66" rx="37" ry="39" fill="#F6BE6B"/>
<ellipse cx="66" cy="86" rx="22" ry="16" fill="#FFEBC9"/>
<path d="M49 58 q4 -5 8 0" stroke="#2E2A35" stroke-width="3.4" fill="none" stroke-linecap="round"/>
<path d="M75 58 q4 -5 8 0" stroke="#2E2A35" stroke-width="3.4" fill="none" stroke-linecap="round"/>
<path d="M59 76 Q66 71 73 76 Q70 83 66 83 Q62 83 59 76Z" fill="#2E2A35"/>
<path d="M60 88 Q66 98 72 88" fill="#F27C7C"/>
<path d="M66 83 V87 M66 87 Q60 92 55 89 M66 87 Q72 92 77 89" stroke="#2E2A35" stroke-width="2.4" fill="none" stroke-linecap="round"/>
<circle cx="43" cy="76" r="6" fill="#FF8F80" fill-opacity=".55"/>
<circle cx="89" cy="76" r="6" fill="#FF8F80" fill-opacity=".55"/>
'''),

  /// 梳子。
  comb(72, '''
<rect x="10" y="14" width="52" height="20" rx="10" fill="#FFFFFF"/>
<rect x="15" y="18" width="42" height="12" rx="6" fill="#F0785A"/>
<g stroke="#FFFFFF" stroke-width="8" stroke-linecap="round"><path d="M20 34v22M28 34v22M36 34v22M44 34v22M52 34v16"/></g>
<g stroke="#9C7BD6" stroke-width="3.4" stroke-linecap="round"><path d="M20 34v22M28 34v22M36 34v22M44 34v22M52 34v16"/></g>
'''),

  /// 笑脸星星，用于陪伴时刻。
  star(76, '''
<path d="M38 6l8.5 17.2 19 2.8-13.7 13.4 3.2 18.9L38 49.4 21 58.3l3.2-18.9L10.5 26l19-2.8Z" fill="#FFFFFF" stroke="#FFFFFF" stroke-width="8" stroke-linejoin="round"/>
<path d="M38 6l8.5 17.2 19 2.8-13.7 13.4 3.2 18.9L38 49.4 21 58.3l3.2-18.9L10.5 26l19-2.8Z" fill="#FFC53D"/>
<circle cx="31" cy="33" r="2.4" fill="#2E2A35"/><circle cx="45" cy="33" r="2.4" fill="#2E2A35"/>
<path d="M33 40 q5 5 10 0" stroke="#2E2A35" stroke-width="2.2" fill="none" stroke-linecap="round"/>
'''),

  /// 笑脸便便，用于排泄的补充面板。
  potty(64, '''
<circle cx="32" cy="32" r="30" fill="#FFFFFF"/>
<circle cx="32" cy="32" r="25" fill="#F2DDB8"/>
<path d="M21 44h22a5 5 0 0 0 .7-10 4.6 4.6 0 0 0-4-7h-1a4.3 4.3 0 0 0-3.7-6.6c1-2.4-.6-5-2.8-5.7.3 2.5-1.8 4-4 4.6a4.6 4.6 0 0 0-2 7.7h-2.4a4.6 4.6 0 0 0-3.6 7.2A5 5 0 0 0 21 44Z" fill="#B98A4F"/>
<circle cx="27.5" cy="35" r="1.8" fill="#2E2A35"/><circle cx="36.5" cy="35" r="1.8" fill="#2E2A35"/>
<path d="M29.5 39.5q2.5 2.2 5 0" stroke="#2E2A35" stroke-width="1.8" fill="none" stroke-linecap="round"/>
'''),

  /// 太阳，用于天气贴士。
  sun(44, '''
<circle cx="22" cy="22" r="22" fill="#FFFFFF"/>
<circle cx="22" cy="22" r="8" fill="#FFB54A"/>
<path d="M22 7v4M22 33v4M7 22h4M33 22h4M11.5 11.5l2.8 2.8M29.7 29.7l2.8 2.8M32.5 11.5l-2.8 2.8M14.3 29.7l-2.8 2.8" stroke="#FFB54A" stroke-width="2.6" stroke-linecap="round"/>
''');

  const StickerArt(this.viewBox, this.body);

  final double viewBox;
  final String body;

  String get svg =>
      '<svg xmlns="http://www.w3.org/2000/svg" '
      'viewBox="0 0 $viewBox $viewBox">$body</svg>';
}

/// 一张贴纸：略微歪着，带柔和阴影。装饰用时不读出。
class Sticker extends StatelessWidget {
  const Sticker(
    this.art, {
    super.key,
    this.size = 72,
    this.turns = 0,
    this.shadowColor = const Color(0x38964628),
    this.semanticLabel,
  });

  final StickerArt art;
  final double size;

  /// 旋转角度，单位是整圈；-0.017 约等于 -6°。
  final double turns;
  final Color shadowColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final picture = SvgPicture.string(art.svg, width: size, height: size);
    final sticker = RotationTransition(
      turns: AlwaysStoppedAnimation(turns),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: size * 0.05,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: size * 0.05,
                sigmaY: size * 0.05,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(shadowColor, BlendMode.srcIn),
                child: picture,
              ),
            ),
          ),
          picture,
        ],
      ),
    );
    final label = semanticLabel;
    return label == null
        ? ExcludeSemantics(child: sticker)
        : Semantics(image: true, label: label, child: sticker);
  }
}
