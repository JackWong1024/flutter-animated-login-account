import 'package:animated_login/src/utils/hasher.dart';
import 'package:flutter/foundation.dart';

@immutable

/// [SignUpData] model is to store/transfer signup mode data.
class SignUpData {
  /// Contains [name], [email], [password] and [confirmPassword] fields.
  /// Overrides [toString], [hashCode] methods and [==] operator.
  const SignUpData({
    required this.account,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });


  final String account;
  /// Name of the user
  final String name;

  final String phone;

  /// Email of the user
  final String email;

  /// Password of the user
  final String password;

  /// Confirm password user entered
  final String confirmPassword;

  /// Overrides the [toString] method.
  @override
  String toString() => 'SignUpData($name,$phone,$account, $email, $password, $confirmPassword)';

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SignUpData &&
        other.name == name &&
        other.phone == phone &&
        other.account == account &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode =>
      Hasher.getHashCode(<String>[email,phone,account, name, password, confirmPassword]);
}
