import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/shell.dart';
import '../../../core/l10n/app_locale.dart';
import '../application/current_pet.dart';

class PetPage extends ConsumerWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlaceholderPage(
    title:
        ref.watch(currentPetProvider)?.name ??
        AppLocalizations.of(context).navPetFallback,
  );
}
