import 'package:flutter/widgets.dart';

import '../../../app/shell.dart';
import '../../../core/design/design.dart';
import '../../../core/l10n/app_locale.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderPage(
    title: AppLocalizations.of(context).navPlans,
    sticker: StickerArt.star,
  );
}
