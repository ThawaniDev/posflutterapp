import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/pos_customization/repositories/customization_repository.dart';
import 'package:thawani_pos/features/pos_customization/providers/customization_state.dart';

// ─── Settings Provider ──────────────────────────────
final customizationSettingsProvider = StateNotifierProvider<CustomizationSettingsNotifier, CustomizationSettingsState>((ref) {
  return CustomizationSettingsNotifier(ref.watch(customizationRepositoryProvider));
});

class CustomizationSettingsNotifier extends StateNotifier<CustomizationSettingsState> {
  final CustomizationRepository _repo;

  CustomizationSettingsNotifier(this._repo) : super(const SettingsInitial());

  Future<void> load() async {
    state = const SettingsLoading();
    try {
      final res = await _repo.getSettings();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = SettingsLoaded(
        theme: d['theme'] as String? ?? 'light',
        primaryColor: d['primary_color'] as String? ?? '#FD8209',
        secondaryColor: d['secondary_color'] as String? ?? '#1A1A2E',
        accentColor: d['accent_color'] as String? ?? '#16213E',
        fontScale: double.tryParse(d['font_scale'] as String? ?? '') ?? 1.0,
        handedness: d['handedness'] as String? ?? 'right',
        gridColumns: d['grid_columns'] as int? ?? 4,
        showProductImages: d['show_product_images'] as bool? ?? true,
        showPriceOnGrid: d['show_price_on_grid'] as bool? ?? true,
        cartDisplayMode: d['cart_display_mode'] as String? ?? 'detailed',
        layoutDirection: d['layout_direction'] as String? ?? 'auto',
        syncVersion: d['sync_version'] as int? ?? 0,
        raw: d,
      );
    } catch (e) {
      state = SettingsError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    state = const SettingsLoading();
    try {
      await _repo.updateSettings(data);
      await load();
    } catch (e) {
      state = SettingsError(e.toString());
    }
  }

  Future<void> reset() async {
    state = const SettingsLoading();
    try {
      await _repo.resetSettings();
      await load();
    } catch (e) {
      state = SettingsError(e.toString());
    }
  }
}

// ─── Receipt Provider ──────────────────────────────
final receiptTemplateProvider = StateNotifierProvider<ReceiptTemplateNotifier, ReceiptTemplateState>((ref) {
  return ReceiptTemplateNotifier(ref.watch(customizationRepositoryProvider));
});

class ReceiptTemplateNotifier extends StateNotifier<ReceiptTemplateState> {
  final CustomizationRepository _repo;

  ReceiptTemplateNotifier(this._repo) : super(const ReceiptInitial());

  Future<void> load() async {
    state = const ReceiptLoading();
    try {
      final res = await _repo.getReceiptTemplate();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = ReceiptLoaded(
        logoUrl: d['logo_url'] as String?,
        headerLine1: d['header_line_1'] as String?,
        headerLine2: d['header_line_2'] as String?,
        footerText: d['footer_text'] as String?,
        showVatNumber: d['show_vat_number'] as bool? ?? true,
        showLoyaltyPoints: d['show_loyalty_points'] as bool? ?? false,
        showBarcode: d['show_barcode'] as bool? ?? true,
        paperWidthMm: d['paper_width_mm'] as int? ?? 80,
        syncVersion: d['sync_version'] as int? ?? 0,
        raw: d,
      );
    } catch (e) {
      state = ReceiptError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    state = const ReceiptLoading();
    try {
      await _repo.updateReceiptTemplate(data);
      await load();
    } catch (e) {
      state = ReceiptError(e.toString());
    }
  }

  Future<void> reset() async {
    state = const ReceiptLoading();
    try {
      await _repo.resetReceiptTemplate();
      await load();
    } catch (e) {
      state = ReceiptError(e.toString());
    }
  }
}

// ─── Quick Access Provider ──────────────────────────
final quickAccessProvider = StateNotifierProvider<QuickAccessNotifier, QuickAccessState>((ref) {
  return QuickAccessNotifier(ref.watch(customizationRepositoryProvider));
});

class QuickAccessNotifier extends StateNotifier<QuickAccessState> {
  final CustomizationRepository _repo;

  QuickAccessNotifier(this._repo) : super(const QuickAccessInitial());

  Future<void> load() async {
    state = const QuickAccessLoading();
    try {
      final res = await _repo.getQuickAccess();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final buttons = (d['buttons_json'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = QuickAccessLoaded(
        gridRows: d['grid_rows'] as int? ?? 2,
        gridCols: d['grid_cols'] as int? ?? 4,
        buttons: buttons,
        syncVersion: d['sync_version'] as int? ?? 0,
        raw: d,
      );
    } catch (e) {
      state = QuickAccessError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    state = const QuickAccessLoading();
    try {
      await _repo.updateQuickAccess(data);
      await load();
    } catch (e) {
      state = QuickAccessError(e.toString());
    }
  }

  Future<void> reset() async {
    state = const QuickAccessLoading();
    try {
      await _repo.resetQuickAccess();
      await load();
    } catch (e) {
      state = QuickAccessError(e.toString());
    }
  }
}
