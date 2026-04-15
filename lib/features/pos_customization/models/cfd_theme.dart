import 'package:wameedpos/features/pos_customization/enums/animation_style.dart';
import 'package:wameedpos/features/pos_customization/enums/cfd_cart_layout.dart';
import 'package:wameedpos/features/pos_customization/enums/cfd_idle_layout.dart';
import 'package:wameedpos/features/onboarding/enums/thank_you_animation.dart';

class CfdTheme {
  final String id;
  final String name;
  final String slug;
  final String backgroundColor;
  final String textColor;
  final String accentColor;
  final String? fontFamily;
  final CfdCartLayout? cartLayout;
  final CfdIdleLayout? idleLayout;
  final AnimationStyle? animationStyle;
  final int? transitionSeconds;
  final bool? showStoreLogo;
  final bool? showRunningTotal;
  final ThankYouAnimation? thankYouAnimation;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CfdTheme({
    required this.id,
    required this.name,
    required this.slug,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    this.fontFamily,
    this.cartLayout,
    this.idleLayout,
    this.animationStyle,
    this.transitionSeconds,
    this.showStoreLogo,
    this.showRunningTotal,
    this.thankYouAnimation,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CfdTheme.fromJson(Map<String, dynamic> json) {
    return CfdTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      backgroundColor: json['background_color'] as String,
      textColor: json['text_color'] as String,
      accentColor: json['accent_color'] as String,
      fontFamily: json['font_family'] as String?,
      cartLayout: CfdCartLayout.tryFromValue(json['cart_layout'] as String?),
      idleLayout: CfdIdleLayout.tryFromValue(json['idle_layout'] as String?),
      animationStyle: AnimationStyle.tryFromValue(json['animation_style'] as String?),
      transitionSeconds: (json['transition_seconds'] as num?)?.toInt(),
      showStoreLogo: json['show_store_logo'] as bool?,
      showRunningTotal: json['show_running_total'] as bool?,
      thankYouAnimation: ThankYouAnimation.tryFromValue(json['thank_you_animation'] as String?),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'background_color': backgroundColor,
      'text_color': textColor,
      'accent_color': accentColor,
      'font_family': fontFamily,
      'cart_layout': cartLayout?.value,
      'idle_layout': idleLayout?.value,
      'animation_style': animationStyle?.value,
      'transition_seconds': transitionSeconds,
      'show_store_logo': showStoreLogo,
      'show_running_total': showRunningTotal,
      'thank_you_animation': thankYouAnimation?.value,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CfdTheme copyWith({
    String? id,
    String? name,
    String? slug,
    String? backgroundColor,
    String? textColor,
    String? accentColor,
    String? fontFamily,
    CfdCartLayout? cartLayout,
    CfdIdleLayout? idleLayout,
    AnimationStyle? animationStyle,
    int? transitionSeconds,
    bool? showStoreLogo,
    bool? showRunningTotal,
    ThankYouAnimation? thankYouAnimation,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CfdTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      fontFamily: fontFamily ?? this.fontFamily,
      cartLayout: cartLayout ?? this.cartLayout,
      idleLayout: idleLayout ?? this.idleLayout,
      animationStyle: animationStyle ?? this.animationStyle,
      transitionSeconds: transitionSeconds ?? this.transitionSeconds,
      showStoreLogo: showStoreLogo ?? this.showStoreLogo,
      showRunningTotal: showRunningTotal ?? this.showRunningTotal,
      thankYouAnimation: thankYouAnimation ?? this.thankYouAnimation,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CfdTheme && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CfdTheme(id: $id, name: $name, slug: $slug, backgroundColor: $backgroundColor, textColor: $textColor, accentColor: $accentColor, ...)';
}
