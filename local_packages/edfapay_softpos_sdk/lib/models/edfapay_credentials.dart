import 'package:edfapay_softpos_sdk/models/edfapay_credentials.dart' as prefix0;

import '../enums/env.dart';

/// Credentials for SDK initialization.
/// Matches: EdfaPayCredentials in native SDK.
class EdfaPayCredentials {
  final Env environment;
  String? token;
  String? email;
  String? password;

  EdfaPayCredentials({
    required this.environment,
    this.token,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() => {
        'environment': environment.name,
        'token': token,
        'email': email,
        'password': password,
      };

  EdfaPayCredentials.withToken({required  this.environment, required this.token});
  EdfaPayCredentials.withEmailPassword({required this.environment, required email, required password});
  EdfaPayCredentials.withInput({required this.environment});
  EdfaPayCredentials.withEmail({required this.environment, required String email});
}
