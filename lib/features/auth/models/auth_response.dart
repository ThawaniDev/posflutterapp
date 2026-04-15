import 'package:wameedpos/features/auth/models/user.dart';
import 'package:wameedpos/features/auth/models/auth_token.dart';

/// Auth response from login/register APIs.
class AuthResponse {
  final User user;
  final AuthToken token;

  const AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: AuthToken(token: json['token'] as String, tokenType: json['token_type'] as String? ?? 'Bearer'),
    );
  }
}
