import 'package:wameedpos/features/pos_customization/enums/cart_display_mode.dart';
import 'package:wameedpos/features/pos_customization/enums/handedness.dart';
import 'package:wameedpos/features/pos_customization/enums/layout_direction.dart';
import 'package:wameedpos/features/pos_customization/enums/pos_theme.dart';

class PosCustomizationSetting {

  const PosCustomizationSetting({
    required this.id,
    required this.storeId,
    this.theme,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.fontScale,
    this.handedness,
    this.gridColumns,
    this.showProductImages,
    this.showPriceOnGrid,
    this.cartDisplayMode,
    this.layoutDirection,
    this.syncVersion,
    this.updatedAt,
  });

  factory PosCustomizationSetting.fromJson(Map<String, dynamic> json) {
    return PosCustomizationSetting(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      theme: PosTheme.tryFromValue(json['theme'] as String?),
      primaryColor: json['primary_color'] as String?,
      secondaryColor: json['secondary_color'] as String?,
      accentColor: json['accent_color'] as String?,
      fontScale: json['font_scale'] != null ? double.tryParse(json['font_scale'].toString()) : null,
      handedness: Handedness.tryFromValue(json['handedness'] as String?),
      gridColumns: (json['grid_columns'] as num?)?.toInt(),
      showProductImages: json['show_product_images'] as bool?,
      showPriceOnGrid: json['show_price_on_grid'] as bool?,
      cartDisplayMode: CartDisplayMode.tryFromValue(json['cart_display_mode'] as String?),
      layoutDirection: LayoutDirection.tryFromValue(json['layout_direction'] as String?),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final PosTheme? theme;
  final String? primaryColor;
  final String? secondaryColor;
  final String? accentColor;
  final double? fontScale;
  final Handedness? handedness;
  final int? gridColumns;
  final bool? showProductImages;
  final bool? showPriceOnGrid;
  final CartDisplayMode? cartDisplayMode;
  final LayoutDirection? layoutDirection;
  final int? syncVersion;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'theme': theme?.value,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'accent_color': accentColor,
      'font_scale': fontScale,
      'handedness': handedness?.value,
      'grid_columns': gridColumns,
      'show_product_images': showProductImages,
      'show_price_on_grid': showPriceOnGrid,
      'cart_display_mode': cartDisplayMode?.value,
      'layout_direction': layoutDirection?.value,
      'sync_version': syncVersion,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PosCustomizationSetting copyWith({
    String? id,
    String? storeId,
    PosTheme? theme,
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
    double? fontScale,
    Handedness? handedness,
    int? gridColumns,
    bool? showProductImages,
    bool? showPriceOnGrid,
    CartDisplayMode? cartDisplayMode,
    LayoutDirection? layoutDirection,
    int? syncVersion,
    DateTime? updatedAt,
  }) {
    return PosCustomizationSetting(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      theme: theme ?? this.theme,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      fontScale: fontScale ?? this.fontScale,
      handedness: handedness ?? this.handedness,
      gridColumns: gridColumns ?? this.gridColumns,
      showProductImages: showProductImages ?? this.showProductImages,
      showPriceOnGrid: showPriceOnGrid ?? this.showPriceOnGrid,
      cartDisplayMode: cartDisplayMode ?? this.cartDisplayMode,
      layoutDirection: layoutDirection ?? this.layoutDirection,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PosCustomizationSetting && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PosCustomizationSetting(id: $id, storeId: $storeId, theme: $theme, primaryColor: $primaryColor, secondaryColor: $secondaryColor, accentColor: $accentColor, ...)';
}
