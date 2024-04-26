import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this) ??
        (throw StateError(
          'The localizations is required, add it to the app widget.',
        ));
  }
}
