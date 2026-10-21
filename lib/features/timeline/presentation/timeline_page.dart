import 'package:flutter/widgets.dart';

import '../../../app/shell.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderPage(
    title: AppLocalizations.of(context).navTimeline,
    sticker: StickerArt.comb,
  );
}
