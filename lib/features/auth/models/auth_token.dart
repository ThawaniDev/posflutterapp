/// Auth token response model.
class AuthToken {

  const AuthToken({required this.token, this.tokenType = 'Bearer'});

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(token: json['token'] as String, tokenType: json['token_type'] as String? ?? 'Bearer');
  }
  final String token;
  final String tokenType;

  String get headerValue => '$tokenType $token';
}
