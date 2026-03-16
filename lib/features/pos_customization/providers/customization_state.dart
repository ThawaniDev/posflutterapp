import 'package:flutter/foundation.dart';

// ─── Settings State ────────────────────────────────
@immutable
sealed class CustomizationSettingsState {
  const CustomizationSettingsState();
}

class SettingsInitial extends CustomizationSettingsState {
  const SettingsInitial();
}

class SettingsLoading extends CustomizationSettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends CustomizationSettingsState {
  final String theme;
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;
  final double fontScale;
  final String handedness;
  final int gridColumns;
  final bool showProductImages;
  final bool showPriceOnGrid;
  final String cartDisplayMode;
  final String layoutDirection;
  final int syncVersion;
  final Map<String, dynamic> raw;

  const SettingsLoaded({
    required this.theme,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.fontScale,
    required this.handedness,
    required this.gridColumns,
    required this.showProductImages,
    required this.showPriceOnGrid,
    required this.cartDisplayMode,
    required this.layoutDirection,
    required this.syncVersion,
    required this.raw,
  });
}

class SettingsError extends CustomizationSettingsState {
  final String message;
  const SettingsError(this.message);
}

// ─── Receipt Template State ────────────────────────
@immutable
sealed class ReceiptTemplateState {
  const ReceiptTemplateState();
}

class ReceiptInitial extends ReceiptTemplateState {
  const ReceiptInitial();
}

class ReceiptLoading extends ReceiptTemplateState {
  const ReceiptLoading();
}

class ReceiptLoaded extends ReceiptTemplateState {
  final String? logoUrl;
  final String? headerLine1;
  final String? headerLine2;
  final String? footerText;
  final bool showVatNumber;
  final bool showLoyaltyPoints;
  final bool showBarcode;
  final int paperWidthMm;
  final int syncVersion;
  final Map<String, dynamic> raw;

  const ReceiptLoaded({
    this.logoUrl,
    this.headerLine1,
    this.headerLine2,
    this.footerText,
    required this.showVatNumber,
    required this.showLoyaltyPoints,
    required this.showBarcode,
    required this.paperWidthMm,
    required this.syncVersion,
    required this.raw,
  });
}

class ReceiptError extends ReceiptTemplateState {
  final String message;
  const ReceiptError(this.message);
}

// ─── Quick Access State ────────────────────────────
@immutable
sealed class QuickAccessState {
  const QuickAccessState();
}

class QuickAccessInitial extends QuickAccessState {
  const QuickAccessInitial();
}

class QuickAccessLoading extends QuickAccessState {
  const QuickAccessLoading();
}

class QuickAccessLoaded extends QuickAccessState {
  final int gridRows;
  final int gridCols;
  final List<Map<String, dynamic>> buttons;
  final int syncVersion;
  final Map<String, dynamic> raw;

  const QuickAccessLoaded({
    required this.gridRows,
    required this.gridCols,
    required this.buttons,
    required this.syncVersion,
    required this.raw,
  });
}

class QuickAccessError extends QuickAccessState {
  final String message;
  const QuickAccessError(this.message);
}
