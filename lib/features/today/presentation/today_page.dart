import 'package:flutter/widgets.dart';

import '../../../app/shell.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderPage(
    title: AppLocalizations.of(context).navToday,
    sticker: StickerArt.golden,
  );
}
