import '../../../data/user/models/user.dart';
import '../../../l10n/app_localizations.dart';

class CityPickerUtils {
  const CityPickerUtils._();

  static String getTranslatedCityName({
    required AppLocalizations localizations,
    required IraqGovernorate city,
  }) {
    switch (city) {
      case IraqGovernorate.baghdad:
        return localizations.baghdad;
      case IraqGovernorate.basra:
        return localizations.basra;
      case IraqGovernorate.maysan:
        return localizations.maysan;
      case IraqGovernorate.dhiQar:
        return localizations.dhiQar;
      case IraqGovernorate.diyala:
        return localizations.diyala;
      case IraqGovernorate.karbala:
        return localizations.karbala;
      case IraqGovernorate.kirkuk:
        return localizations.kirkuk;
      case IraqGovernorate.najaf:
        return localizations.najaf;
      case IraqGovernorate.nineveh:
        return localizations.nineveh;
      case IraqGovernorate.wasit:
        return localizations.wasit;
      case IraqGovernorate.anbar:
        return localizations.anbar;
      case IraqGovernorate.salahAlDin:
        return localizations.salahAlDin;
      case IraqGovernorate.babil:
        return localizations.babil;
      case IraqGovernorate.babylon:
        return localizations.babylon;
      case IraqGovernorate.alMuthanna:
        return localizations.alMuthanna;
      case IraqGovernorate.alQadisiyyah:
        return localizations.alQadisiyyah;
      case IraqGovernorate.thiQar:
        return localizations.thiQar;
    }
  }
}
