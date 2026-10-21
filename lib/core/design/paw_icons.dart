import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/entries/domain/entry_codes.dart';

/// 线条图标，28×28 画布，颜色跟随 [PawIcon.color]。
enum PawGlyph {
  meal(
    '<path d="M3 14h22a11 9 0 0 1-22 0Z"/><circle cx="10" cy="10.5" r="1.4" fill="currentColor"/><circle cx="14" cy="8.5" r="1.4" fill="currentColor"/><circle cx="18" cy="10.5" r="1.4" fill="currentColor"/>',
  ),
  water(
    '<path d="M14 3c4 5 7.5 9 7.5 13a7.5 7.5 0 0 1-15 0c0-4 3.5-8 7.5-13Z"/><path d="M10.5 16.5a3.5 3.5 0 0 0 3.5 3.5"/>',
  ),
  potty(
    '<path d="M7.5 23h13a3.2 3.2 0 0 0 .4-6.4 3 3 0 0 0-2.6-4.6h-.6a2.8 2.8 0 0 0-2.4-4.3c.6-1.6-.4-3.2-1.8-3.7.2 1.6-1.2 2.6-2.6 3a3 3 0 0 0-1.3 5H9.4a3 3 0 0 0-2.3 4.7A3.2 3.2 0 0 0 7.5 23Z"/>',
  ),
  brushing(
    '<rect x="4" y="5" width="20" height="7" rx="3.5"/><path d="M7.5 12v9M11.2 12v9M14.9 12v9M18.6 12v9M22 12v6"/>',
  ),
  walk(
    '<path d="M6 22c2-4 4-6 8-6s6 2 8 6"/><circle cx="9" cy="9" r="2"/><circle cx="14" cy="6.5" r="2"/><circle cx="19" cy="9" r="2"/>',
  ),
  bath(
    '<path d="M4 15h20v2a7 7 0 0 1-7 7h-6a7 7 0 0 1-7-7Z"/><path d="M7 15V7a3 3 0 0 1 6 0"/><circle cx="18" cy="8" r="1.5"/><circle cx="22" cy="11" r="1.2"/>',
  ),
  grooming(
    '<circle cx="8" cy="20" r="3.5"/><circle cx="20" cy="20" r="3.5"/><path d="M10.5 17.5 21 4M17.5 17.5 7 4"/>',
  ),
  parasite(
    '<path d="M14 4 6 7v6c0 5 3.4 9 8 11 4.6-2 8-6 8-11V7Z"/><path d="m10.5 14 2.5 2.5 4.5-5"/>',
  ),
  weight(
    '<rect x="4" y="5" width="20" height="18" rx="6"/><path d="M10 11a5 5 0 0 1 8 0l-3 4"/>',
  ),
  ear(
    '<path d="M9 11a6 6 0 1 1 10.5 4c-1.5 1.8-2.5 2.8-2.5 5a3.5 3.5 0 0 1-6.5 1.8"/><path d="M12.5 11.5a2.5 2.5 0 1 1 4 2"/>',
  ),
  sparkle(
    '<path d="M14 4v6M14 18v6M4 14h6M18 14h6"/><path d="m8 8 2.5 2.5M17.5 17.5 20 20M20 8l-2.5 2.5M10.5 17.5 8 20"/>',
  ),
  symptom(
    '<path d="M14 24s-9-5.5-9-12a5 5 0 0 1 9-3 5 5 0 0 1 9 3c0 6.5-9 12-9 12Z"/><path d="M8 14h3l2-3 2 5 2-2h3"/>',
  ),
  pill(
    '<rect x="4" y="9" width="20" height="10" rx="5" transform="rotate(-35 14 14)"/><path d="m11 10 6 8"/>',
  ),
  syringe(
    '<path d="m18 4 6 6M21 7l-11 11-4 1 1-4 11-11M13 9l2 2M10 12l2 2M4 24l3-3"/>',
  ),
  flask(
    '<path d="M10 4h8M11 4v6l-5 10a2.5 2.5 0 0 0 2.2 3.6h11.6A2.5 2.5 0 0 0 22 20l-5-10V4"/><path d="M8.5 16h11"/>',
  ),
  star(
    '<path d="m14 4 3 6.2 6.8 1-4.9 4.8 1.2 6.8L14 19.6l-6.1 3.2 1.2-6.8-4.9-4.8 6.8-1Z"/>',
  ),
  today(
    '<circle cx="14" cy="14" r="5"/><path d="M14 3v2.5M14 22.5V25M3 14h2.5M22.5 14H25M6.2 6.2 8 8M20 20l1.8 1.8M21.8 6.2 20 8M8 20l-1.8 1.8"/>',
  ),
  timeline(
    '<circle cx="7" cy="7" r="2"/><circle cx="7" cy="21" r="2"/><path d="M7 9v10M12 7h11M12 21h11M12 14h8"/>',
  ),
  plans(
    '<rect x="4" y="6" width="20" height="18" rx="5"/><path d="M9 3.5v5M19 3.5v5M10 16l3 3 5.5-6"/>',
  ),
  paw(
    '<circle cx="8" cy="9" r="2.6" fill="currentColor"/><circle cx="14" cy="6.2" r="2.6" fill="currentColor"/><circle cx="20" cy="9" r="2.6" fill="currentColor"/><path fill="currentColor" d="M14 12.5c-4.2 0-7.5 4.3-7.5 7.4 0 2.2 2.1 3.3 4.2 2.6 1.6-.5 5-.5 6.6 0 2.1.7 4.2-.4 4.2-2.6 0-3.1-3.3-7.4-7.5-7.4Z"/>',
  ),
  plus('<path d="M14 6v16M6 14h16"/>'),
  check('<path d="m6 14.5 5 5 11-11.5"/>'),
  close('<path d="M7 7l14 14M21 7 7 21"/>'),
  chevronRight('<path d="m11 7 7 7-7 7"/>'),
  chevronDown('<path d="m7 11 7 7 7-7"/>');

  const PawGlyph(this.paths);

  final String paths;

  static PawGlyph forEntry(EntryType type) => switch (type) {
    EntryType.meal => meal,
    EntryType.water => water,
    EntryType.potty => potty,
    EntryType.brushing => brushing,
    EntryType.walk => walk,
    EntryType.bath => bath,
    EntryType.grooming => grooming,
    EntryType.parasitePrevention => parasite,
    EntryType.weight => weight,
    EntryType.earCheck => ear,
    EntryType.otherCare => sparkle,
    EntryType.symptom => symptom,
    EntryType.medication => pill,
    EntryType.vaccine => syringe,
    EntryType.vetTest => flask,
    EntryType.custom => star,
  };
}

/// 装饰性图标默认不读出；需要读出时传 [semanticLabel]。
class PawIcon extends StatelessWidget {
  const PawIcon(
    this.glyph, {
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.2,
    this.semanticLabel,
  });

  final PawGlyph glyph;
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? DefaultTextStyle.of(context).style.color;
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 28" '
        'fill="none" stroke="currentColor" stroke-width="$strokeWidth" '
        'stroke-linecap="round" stroke-linejoin="round">${glyph.paths}</svg>';
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      theme: SvgTheme(currentColor: color ?? const Color(0xFF2E2A35)),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
