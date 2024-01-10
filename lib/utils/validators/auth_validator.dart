import '../../l10n/app_localizations.dart';
import 'global_validator.dart';

class AuthValidator {
  AuthValidator._();
  static const _emailRegex =
      '''[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+''';

  static String? validateEmail(
    String email, {
    required AppLocalizations localizations,
  }) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      email,
      errorMessage: localizations.pleaseEnterValidEmailAddress,
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }

    if (!RegExp(_emailRegex).hasMatch(email)) {
      return localizations.pleaseEnterValidEmailAddress;
    }
    return null;
  }

  static String? validatePassword(
    String password, {
    required AppLocalizations localizations,
  }) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      password,
      errorMessage: localizations.passwordShouldNotBeEmpty,
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }
    if (password.length < 8) return localizations.passwordShouldBeAtLeast8Chars;
    if (password.length > 255) {
      return localizations.passwordShouldBeLessThan255Chars;
    }

    final bool hasOneUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigit = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialChar = password.contains(RegExp(r'[#?!@$%^&*-]'));

    if (!hasOneUppercase) {
      return localizations.passwordMustContainAtLeastOneUppercaseCharacter;
    }

    if (!hasLowercase) {
      return localizations.passwordMustContainAtLeastOneLowercaseCharacter;
    }

    if (!hasDigit) {
      return localizations.passwordMustContainAtLeastOneDigit;
    }

    if (!hasSpecialChar) {
      return localizations.passwordMustContainAtLeastOneSpecialCharacter;
    }

    return null;
  }

  static String? validateConfirmPassword({
    required String password,
    required String confirmPassword,
    required AppLocalizations localizations,
  }) {
    if (confirmPassword.trim().isEmpty) {
      return localizations.passwordShouldNotBeEmpty;
    }
    if (password != confirmPassword) {
      return localizations.confirmPasswordDoesNotMatch;
    }
    return null;
  }

  static const phoneNumberPattern = r'^07\d{9}$';
  static String? validateIraqPhoneNumber({
    required String phoneNumber,
    required AppLocalizations localizations,
  }) {
    final value = phoneNumber.trim();
    if (value.isEmpty) {
      return localizations.phoneNumberShouldNotBeEmpty;
    }
    final phoneNumberRegex = RegExp(phoneNumberPattern);
    if (!phoneNumberRegex.hasMatch(value)) {
      return localizations.phoneNumberMustBeValid;
    }
    return null;
  }
}
