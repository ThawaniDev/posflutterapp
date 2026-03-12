/// Auth token response model.
class AuthToken {
  final String token;
  final String tokenType;

  const AuthToken({required this.token, this.tokenType = 'Bearer'});

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(token: json['token'] as String, tokenType: json['token_type'] as String? ?? 'Bearer');
  }

  String get headerValue => '$tokenType $token';
}
