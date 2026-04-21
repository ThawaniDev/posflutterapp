import 'package:wameedpos/features/pos_customization/enums/font_size.dart';
import 'package:wameedpos/features/pos_customization/enums/handedness.dart';
import 'package:wameedpos/features/auth/enums/user_theme.dart';

class UserPreference {

  const UserPreference({required this.id, required this.userId, this.posHandedness, this.fontSize, this.theme, this.posLayoutId});

  factory UserPreference.fromJson(Map<String, dynamic> json) {
    return UserPreference(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      posHandedness: Handedness.tryFromValue(json['pos_handedness'] as String?),
      fontSize: FontSize.tryFromValue(json['font_size'] as String?),
      theme: UserTheme.tryFromValue(json['theme'] as String?),
      posLayoutId: json['pos_layout_id'] as String?,
    );
  }
  final String id;
  final String userId;
  final Handedness? posHandedness;
  final FontSize? fontSize;
  final UserTheme? theme;
  final String? posLayoutId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pos_handedness': posHandedness?.value,
      'font_size': fontSize?.value,
      'theme': theme?.value,
      'pos_layout_id': posLayoutId,
    };
  }

  UserPreference copyWith({
    String? id,
    String? userId,
    Handedness? posHandedness,
    FontSize? fontSize,
    UserTheme? theme,
    String? posLayoutId,
  }) {
    return UserPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      posHandedness: posHandedness ?? this.posHandedness,
      fontSize: fontSize ?? this.fontSize,
      theme: theme ?? this.theme,
      posLayoutId: posLayoutId ?? this.posLayoutId,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserPreference && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UserPreference(id: $id, userId: $userId, posHandedness: $posHandedness, fontSize: $fontSize, theme: $theme, posLayoutId: $posLayoutId)';
}
