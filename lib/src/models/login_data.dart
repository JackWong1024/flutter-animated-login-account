import 'package:animated_login/src/utils/hasher.dart';
import 'package:flutter/foundation.dart';

@immutable

/// [LoginData] model is to store/transfer login mode data.
class LoginData {
  /// Contains [account] and [password] fields.
  /// Overrides [toString], [hashCode] methods and [==] operator.
  const LoginData({
    required this.account,
    required this.password,
  });

  /// account of the user
  final String account;

  /// Password of the user
  final String password;

  /// Overrides the [toString] method.
  @override
  String toString() => 'LoginData($account, $password)';

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LoginData &&
        other.account == account &&
        other.password == password;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[account, password]);
}
