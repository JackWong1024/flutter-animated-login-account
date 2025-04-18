import 'package:animated_login/src/constants/enums/auth_mode.dart';
import 'package:animated_login/src/constants/enums/sign_up_modes.dart';
import 'package:animated_login/src/models/models_shelf.dart';
import 'package:animated_login/src/utils/validators.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

/// It is called on auth mode changes,
/// triggered by [Auth.switchAuth] method.
typedef AuthModeChangeCallback = void Function(AuthMode authMode);

/// [Auth] is the provider for auth related data, functions.
class Auth extends ChangeNotifier {
  /// Manages the state related to the authentication modes.
  Auth({
    required GlobalKey<FormState> formKey,
    this.socialLogins = const <SocialLogin>[],
    this.onAuthModeChange,
    this.validateName = true,
    this.validatePhone = false,
    this.validateAccount = true,
    this.validateEmail = true,
    this.validatePassword = true,
    this.validateCheckbox = true,
    this.showPasswordVisibility = true,
    this.checkboxCallback,
    bool hasPrivacyPolicy = false,
    ValidatorModel? nameValidator,
    ValidatorModel? phoneValidator,
    ValidatorModel? accountValidator,
    ValidatorModel? emailValidator,
    ValidatorModel? passwordValidator,
    TextEditingController? nameController,
    TextEditingController? phoneController,
    TextEditingController? accountController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    AuthMode? initialMode,
    LoginCallback? onLogin,
    SignupCallback? onSignup,
    ForgotPasswordCallback? onForgotPassword,
    SignUpModes? signUpMode,
  })  : _formKey = formKey,
        _signUpMode = signUpMode ?? SignUpModes.both,
        _nameController = nameController ?? TextEditingController(text: ''),
        _phoneController = phoneController ?? TextEditingController(text: ''),
        _accountController = accountController ?? TextEditingController(text: ''),
        _emailController = emailController ?? TextEditingController(text: ''),
        _passwordController =
            passwordController ?? TextEditingController(text: ''),
        _confirmPasswordController =
            confirmPasswordController ?? TextEditingController(text: ''),
        _nameValidator = nameValidator,
        _phoneValidator = phoneValidator,
        _accountValidator = accountValidator,
        _emailValidator = emailValidator,
        _passwordValidator = passwordValidator,
        _hasPrivacyPolicy = hasPrivacyPolicy {
    _onLogin = onLogin ?? _defaultLoginFunc;
    _onSignup = onSignup ?? _defaultSignupFunc;
    _onForgotPassword = onForgotPassword ?? _defaultForgotPassFunc;
    _mode = initialMode ?? AuthMode.login;
    _initialMode = initialMode ?? AuthMode.login;
  }

  /// Default login, signup and forgot password functions to be
  /// called in case any custom functions are not provided.
  Future<String?> _defaultLoginFunc(LoginData a) async => null;
  Future<String?> _defaultSignupFunc(SignUpData a) async => null;
  Future<String?> _defaultForgotPassFunc(String e) async => null;

  /// checkboxCallback
  ValueChanged<bool?>? checkboxCallback;

  /// Callback to use auth mode changes.
  final AuthModeChangeCallback? onAuthModeChange;

  late final LoginCallback _onLogin;

  /// Function to be called on login action.
  LoginCallback get onLogin => _onLogin;

  late final SignupCallback _onSignup;

  /// Function to be called on signup action.
  SignupCallback get onSignup => _onSignup;

  late final ForgotPasswordCallback _onForgotPassword;

  /// Function to be called on click to forgot password text.
  ForgotPasswordCallback get onForgotPassword => _onForgotPassword;

  /// List of social login options.
  final List<SocialLogin>? socialLogins;

  bool _checkedPrivacyBox = false;
  bool _showCheckboxError = false;
  final bool _hasPrivacyPolicy;

  late AuthMode _mode;
  late AuthMode _initialMode;

  /// Current authentication mode of the screen.
  AuthMode get mode => _mode;

  /// Uses [AuthMode] enum's values.
  void notifySetMode(AuthMode value) {
    if (value.index != mode.index) {
      _mode = value;
      notifyListeners();
    }
  }

  /// Returns whether the current [_mode] is login or signup mode.
  bool get isLogin => _mode == AuthMode.login;

  /// Returns whether the current [_mode] is login or signup mode.
  bool get isSignup => _mode == AuthMode.signup;

  /// Switches the authentication mode and notify the listeners.
  AuthMode switchAuth() {
    notifySetMode(isLogin ? AuthMode.signup : AuthMode.login);
    onAuthModeChange?.call(mode);
    return mode;
  }

  bool _isReverse = true;

  /// Indicates whether the screen animation is reverse mode.
  bool get isReverse => _isReverse;

  /// Indicates whether the box is checked.
  bool get checkedPrivacyBox => _checkedPrivacyBox;

  /// Indicates whether to show checkbox error.
  bool get showCheckboxError => _showCheckboxError;

  /// Combination of isReverse and initial mode values.
  bool get isAnimatedLogin => !_isReverse ^ (_initialMode == AuthMode.login);


  String? username;
  String? phone;
  String? accout;

  /// Email user entered in the text controller.
  String? email;

  /// Password text in the text controller.
  String? password;

  /// Confirm password text in the text controller.
  String? confirmPassword;


  void setUsername(String? newUsername) => username = newUsername;
  void setPhone(String? newPhone) => phone = newPhone;
  void setAccount(String? newAccount) => accout = newAccount;

  /// Sets the email.
  // ignore: use_setters_to_change_properties
  void setEmail(String? newEmail) => email = newEmail;

  /// Sets the password.
  // ignore: use_setters_to_change_properties
  void setPassword(String? newPassword) => password = newPassword;

  /// Sets the checkbox.
  void setCheckedPrivacyPolicy({bool? newValue}) {
    checkboxCallback?.call(newValue);
    if (newValue == null || newValue == _checkedPrivacyBox) return;
    _checkedPrivacyBox = newValue;
    notifyListeners();
  }

  /// Sets whether to show checkbox error.
  void setShowCheckboxError({bool? newValue}) {
    if (newValue == null || newValue == _showCheckboxError) return;
    _showCheckboxError = newValue;
    notifyListeners();
  }

  /// Sets the confirm password.
  // ignore: use_setters_to_change_properties
  void setConfirmPassword(String? newConfirmPassword) =>
      confirmPassword = newConfirmPassword;

  /// Sets the confirm password.
  void setIsReverse({required bool newValue}) {
    if (newValue != _isReverse) {
      _isReverse = newValue;
      notifyListeners();
    }
  }

  /// Cancelable operation for auth operations.
  CancelableOperation<dynamic>? cancelableOperation;

  final TextEditingController _nameController;
  final TextEditingController _phoneController;
  final TextEditingController _accountController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;


  final ValidatorModel? _nameValidator;
  final ValidatorModel? _phoneValidator;
  final ValidatorModel? _accountValidator;

  /// Custom input validator for email field.
  final ValidatorModel? _emailValidator;

  /// Custom input validator for password field.
  final ValidatorModel? _passwordValidator;


  final bool validateName;
  final bool validatePhone;
  final bool validateAccount;

  /// Indicates whether the email field should be validated.
  final bool validateEmail;

  /// Indicates whether the password fields should be validated.
  final bool validatePassword;

  /// Indicates whether the checkbox should be validated.
  final bool validateCheckbox;

  /// Indicates whether the user can show the password text without obscuring.
  final bool showPasswordVisibility;

  final SignUpModes _signUpMode;

  /// Sets the email value.
  void setEmailValue(String? value) =>
      _emailController.value = TextEditingValue(text: value ?? '');

  /// Sets the password value.
  void setPasswordValue(String? value) =>
      _passwordController.value = TextEditingValue(text: value ?? '');


  void setUsernameValue(String? value) =>
      _nameController.value = TextEditingValue(text: value ?? '');

  void setPhoneValue(String? value) =>
      _phoneController.value = TextEditingValue(text: value ?? '');

  void setAccountValue(String? value) =>
      _accountController.value = TextEditingValue(text: value ?? '');

  /// Sets the confirm password value.
  void setConfirmPasswordValue(String? value) =>
      _confirmPasswordController.value = TextEditingValue(text: value ?? '');


  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get accountController => _accountController;

  /// Optional TextEditingController for email input field.
  TextEditingController get emailController => _emailController;

  /// Optional TextEditingController for password input field.
  TextEditingController get passwordController => _passwordController;

  /// Optional TextEditingController for confirm password input field.
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;


  SignUpModes get signUpMode => _signUpMode;

  final GlobalKey<FormState> _formKey;

  /// The form key that will be assigned to the form.
  GlobalKey<FormState> get formKey => _formKey;

  /// Callback for the social login actions.
  Future<void> socialLoginCallback(int index) async {
    await socialLogins![index].callback();
  }

  /// Any login or signup action.
  Future<void> action() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      if (isLogin) {
        await _loginResult();
      } else if (isSignup) {
        await _signupResult();
      }
    }
  }

  Future<String?> _loginResult() async {
    final loginData = LoginData(
      account: _accountController.text,
      password: _passwordController.text,
    );
    return onLogin(loginData);
  }

  Future<String?> _signupResult() async {
    final signupData = SignUpData(
      name: _nameController.text,
      phone: _phoneController.text,
      account: _accountController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (validateCheckbox && _hasPrivacyPolicy) {
      if (!_checkedPrivacyBox) {
        setShowCheckboxError(newValue: true);
        return 'Please agree to the Privacy Policy and Terms & Conditions';
      } else {
        setShowCheckboxError(newValue: false);
      }
    }
    return onSignup(signupData);
  }


  FormFieldValidator<String?>? get nameValidator => validateName
      ? (_nameValidator?.customValidator ??
          Validators(validator: _nameValidator).name)
      : null;


  FormFieldValidator<String?>? get phoneValidator => validatePhone
      ? (_phoneValidator?.customValidator ??
      Validators(validator: _phoneValidator).phone)
      : null;


  FormFieldValidator<String?>? get accountValidator => validateAccount
      ? (_accountValidator?.customValidator ??
      Validators(validator: _accountValidator).account)
      : null;

  /// Email validator.
  FormFieldValidator<String?>? get emailValidator => validateEmail
      ? (_emailValidator?.customValidator ??
          Validators(validator: _emailValidator).email)
      : null;

  /// Password validator.
  FormFieldValidator<String?>? get passwordValidator => validatePassword
      ? (_passwordValidator?.customValidator ??
          Validators(
            validator: _passwordValidator ??
                const ValidatorModel(
                  checkLowerCase: false,
                  checkUpperCase: false,
                  checkNumber: true,
                  checkSpace: true,
                ),
          ).password)
      : null;
}
