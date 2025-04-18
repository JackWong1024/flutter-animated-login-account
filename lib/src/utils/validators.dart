import 'package:animated_login/src/models/validator_model.dart';

/// Should return the error message for the given value.
typedef ValidatorMessageCallback = String Function(String? text);

/// [Validators] gather all validation functions, regex in one file.
class Validators {
  /// Provides specific validations by also using common functions
  /// such as [_lengthCheck], [_upperCaseCheck] and so on.
  const Validators({this.validator});

  /// Validator.
  final ValidatorModel? validator;

  /// Regex for name input, also considers international chars.
  static const String _nameRegex =
      r"""^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ðıİşŞÜüĞğÇçÖö ,.'-]+$""";

  /// Regex for email input.
  static const String _emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  /// Regex for account input.
  static const String _accountRegex =
      r'^\S[a-zA-Z0-9\s]*\S$';

  /// Regex for phone input.
  static const String _phoneRegex =
      r'^(?:\+86|86)?1[3-9]\d{9}$|^(?:\+44|44)?7\d{9}$';

  /// Validation for email, checks firstly the length and then the content.
  String? email(String? email) {
    var errorMessage = _lengthCheck(email, validator?.length ?? 3);
    if (errorMessage != null) return errorMessage;
    errorMessage = _runValidations(email);
    // ignore: invariant_booleans
    if (errorMessage != null) return errorMessage;
    final isValid = RegExp(_emailRegex).hasMatch(email!);
    if (!isValid) {
      const defaultMessage = 'Please enter a valid email';
      return validator?.validatorCallback?.call(email) ?? defaultMessage;
    }
    return null;
  }
  String? phone(String? phone) {
    var errorMessage = _lengthCheck(phone, validator?.length ?? 10); // 根据需要调整长度
    if (errorMessage != null) return errorMessage;
    errorMessage = _runValidations(phone);
    if (errorMessage != null) return errorMessage;
    final isValid = RegExp(_phoneRegex).hasMatch(phone!);
    if (!isValid) {
      const defaultMessage = 'Please enter a valid phone number';
      return validator?.validatorCallback?.call(phone) ?? defaultMessage;
    }
    return null;
  }
  String? account(String? account) {
    var errorMessage = _lengthCheck(account, validator?.length ?? 1); // 根据需要调整长度
    if (errorMessage != null) return errorMessage;
    errorMessage = _runValidations(account);
    if (errorMessage != null) return errorMessage;
    final isValid = RegExp(_accountRegex).hasMatch(account!);
    if (!isValid) {
      const defaultMessage = 'Please enter a valid account';
      return validator?.validatorCallback?.call(account) ?? defaultMessage;
    }
    return null;
  }
  /// Validation for password, checks firstly the length and then the content.
  /// Uses [_spaceCheck], [_upperCaseCheck], [_lowerCaseCheck], and
  /// [_numberCheck] and returns corresponding error message.
  String? password(String? password) {
    var errorMessage = _lengthCheck(password, validator?.length ?? 6);
    return errorMessage ??= _runValidations(password);
  }

  /// Validation for name, checks firstly the length and then the content.
  String? name(String? name) {
    var errorMessage = _lengthCheck(name, validator?.length ?? 2);
    if (errorMessage != null) return errorMessage;
    errorMessage = _runValidations(name);
    // ignore: invariant_booleans
    if (errorMessage == null) {
      final isValid = RegExp(_nameRegex).hasMatch(name!);
      if (!isValid) {
        const defaultMessage = 'Please enter a valid name';
        return validator?.validatorCallback?.call(name) ?? defaultMessage;
      }
    }
    return errorMessage;
  }

  String? _runValidations(String? text) {
    final validations = <String? Function(String)>[
      if (true == validator?.checkSpace) _spaceCheck,
      if (true == validator?.checkUpperCase) _upperCaseCheck,
      if (true == validator?.checkLowerCase) _lowerCaseCheck,
      if (true == validator?.checkNumber) _numberCheck,
    ];
    for (var i = 0; i < validations.length; i++) {
      if (validations[i](text!) != null) {
        return validations[i](text);
      }
    }
    return null;
  }

  /// Checks whether the given [text] is longer than or equal to the [length].
  String? _lengthCheck(String? text, int length) {
    final lengthError = 'Must be longer than or equal to $length characters';
    if (text == null || text.length < length) {
      return validator?.validatorCallback?.call(text) ?? lengthError;
    }
    return null;
  }

  /// Checks whether the given [text] contains at least one upper case char.
  String? _upperCaseCheck(String text) {
    final containsUpperCase = RegExp(r'^(?=.*?[A-Z]).{1,}$').hasMatch(text);
    if (!containsUpperCase) {
      const defaultMessage = 'Must contain upper case character.';
      return validator?.validatorCallback?.call(text) ?? defaultMessage;
    }
    return null;
  }

  /// Checks whether the given [text] contains at least one lower case char.
  String? _lowerCaseCheck(String text) {
    final containsLowerCase = RegExp(r'^(?=.*?[a-z]).{1,}$').hasMatch(text);
    if (!containsLowerCase) {
      const defaultMessage = 'Must contain lower case character.';
      return validator?.validatorCallback?.call(text) ?? defaultMessage;
    }
    return null;
  }

  /// Checks whether the given [text] contains at least one number.
  String? _numberCheck(String text) {
    final containsNumber = RegExp(r'^(?=.*?[0-9]).{1,}$').hasMatch(text);
    if (!containsNumber) {
      const defaultMessage = 'Must contain at least one number.';
      return validator?.validatorCallback?.call(text) ?? defaultMessage;
    }
    return null;
  }

  /// Checks whether the given [text] contains any space.
  String? _spaceCheck(String text) {
    final containsSpace = RegExp(r'\s\b|\b\s').hasMatch(text);
    if (containsSpace) {
      const defaultMessage = 'Must not contain any white space.';
      return validator?.validatorCallback?.call(text) ?? defaultMessage;
    }
    return null;
  }
}
