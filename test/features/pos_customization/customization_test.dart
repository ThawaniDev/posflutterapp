import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_state.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';

void main() {
  // ═══════════════ Settings State Tests ═══════════════

  group('CustomizationSettingsState', () {
    test('Initial state', () {
      const state = SettingsInitial();
      expect(state, isA<CustomizationSettingsState>());
    });

    test('Loading state', () {
      const state = SettingsLoading();
      expect(state, isA<CustomizationSettingsState>());
    });

    test('Loaded state holds all fields', () {
      const state = SettingsLoaded(
        theme: 'dark',
        primaryColor: '#FF0000',
        secondaryColor: '#00FF00',
        accentColor: '#0000FF',
        fontScale: 1.25,
        handedness: 'left',
        gridColumns: 3,
        showProductImages: false,
        showPriceOnGrid: true,
        cartDisplayMode: 'compact',
        layoutDirection: 'rtl',
        syncVersion: 42,
        raw: {},
      );
      expect(state.theme, 'dark');
      expect(state.primaryColor, '#FF0000');
      expect(state.secondaryColor, '#00FF00');
      expect(state.accentColor, '#0000FF');
      expect(state.fontScale, 1.25);
      expect(state.handedness, 'left');
      expect(state.gridColumns, 3);
      expect(state.showProductImages, false);
      expect(state.showPriceOnGrid, true);
      expect(state.cartDisplayMode, 'compact');
      expect(state.layoutDirection, 'rtl');
      expect(state.syncVersion, 42);
    });

    test('Error state holds message', () {
      const state = SettingsError('Connection timeout');
      expect(state.message, 'Connection timeout');
    });
  });

  // ═══════════════ Receipt Template State Tests ═══════════════

  group('ReceiptTemplateState', () {
    test('Initial state', () {
      const state = ReceiptInitial();
      expect(state, isA<ReceiptTemplateState>());
    });

    test('Loading state', () {
      const state = ReceiptLoading();
      expect(state, isA<ReceiptTemplateState>());
    });

    test('Loaded state holds all receipt fields', () {
      const state = ReceiptLoaded(
        logoUrl: 'https://example.com/logo.png',
        headerLine1: 'My Store',
        headerLine2: 'Branch #1',
        footerText: 'Thank you!',
        showVatNumber: true,
        showLoyaltyPoints: false,
        showBarcode: true,
        paperWidthMm: 58,
        syncVersion: 5,
        raw: {},
      );
      expect(state.logoUrl, 'https://example.com/logo.png');
      expect(state.headerLine1, 'My Store');
      expect(state.headerLine2, 'Branch #1');
      expect(state.footerText, 'Thank you!');
      expect(state.showVatNumber, true);
      expect(state.showLoyaltyPoints, false);
      expect(state.showBarcode, true);
      expect(state.paperWidthMm, 58);
      expect(state.syncVersion, 5);
    });

    test('Loaded state with null optional fields', () {
      const state = ReceiptLoaded(
        showVatNumber: true,
        showLoyaltyPoints: false,
        showBarcode: true,
        paperWidthMm: 80,
        syncVersion: 0,
        raw: {},
      );
      expect(state.logoUrl, isNull);
      expect(state.headerLine1, isNull);
      expect(state.footerText, isNull);
    });

    test('Error state holds message', () {
      const state = ReceiptError('Failed');
      expect(state.message, 'Failed');
    });
  });

  // ═══════════════ Quick Access State Tests ═══════════════

  group('QuickAccessState', () {
    test('Initial state', () {
      const state = QuickAccessInitial();
      expect(state, isA<QuickAccessState>());
    });

    test('Loading state', () {
      const state = QuickAccessLoading();
      expect(state, isA<QuickAccessState>());
    });

    test('Loaded state holds grid config and buttons', () {
      const state = QuickAccessLoaded(
        gridRows: 3,
        gridCols: 6,
        buttons: [
          {'id': 'btn1', 'label': 'Water', 'color': '#0000FF'},
          {'id': 'btn2', 'label': 'Coffee', 'color': '#8B4513'},
        ],
        syncVersion: 10,
        raw: {},
      );
      expect(state.gridRows, 3);
      expect(state.gridCols, 6);
      expect(state.buttons.length, 2);
      expect(state.buttons[0]['label'], 'Water');
      expect(state.syncVersion, 10);
    });

    test('Loaded state with empty buttons', () {
      const state = QuickAccessLoaded(gridRows: 2, gridCols: 4, buttons: [], syncVersion: 0, raw: {});
      expect(state.buttons, isEmpty);
    });

    test('Error state holds message', () {
      const state = QuickAccessError('Fetch failed');
      expect(state.message, 'Fetch failed');
    });
  });

  // ═══════════════ Endpoint Tests ═══════════════

  group('Customization API Endpoints', () {
    test('settings endpoint', () {
      expect(ApiEndpoints.customizationSettings, '/customization/settings');
    });

    test('receipt endpoint', () {
      expect(ApiEndpoints.customizationReceipt, '/customization/receipt');
    });

    test('quick access endpoint', () {
      expect(ApiEndpoints.customizationQuickAccess, '/customization/quick-access');
    });

    test('export endpoint', () {
      expect(ApiEndpoints.customizationExport, '/customization/export');
    });
  });

  // ═══════════════ Route Tests ═══════════════

  group('Customization Routes', () {
    test('customizationDashboard route is /customization', () {
      expect(Routes.customizationDashboard, '/customization');
    });
  });

  // ═══════════════ Cross-cutting ═══════════════

  group('Cross-cutting', () {
    test('All 3 state hierarchies are sealed', () {
      expect(const SettingsInitial(), isA<CustomizationSettingsState>());
      expect(const SettingsLoading(), isA<CustomizationSettingsState>());
      expect(const SettingsError(''), isA<CustomizationSettingsState>());

      expect(const ReceiptInitial(), isA<ReceiptTemplateState>());
      expect(const ReceiptLoading(), isA<ReceiptTemplateState>());
      expect(const ReceiptError(''), isA<ReceiptTemplateState>());

      expect(const QuickAccessInitial(), isA<QuickAccessState>());
      expect(const QuickAccessLoading(), isA<QuickAccessState>());
      expect(const QuickAccessError(''), isA<QuickAccessState>());
    });

    test('Settings defaults pattern', () {
      const state = SettingsLoaded(
        theme: 'light',
        primaryColor: '#FD8209',
        secondaryColor: '#1A1A2E',
        accentColor: '#16213E',
        fontScale: 1.0,
        handedness: 'right',
        gridColumns: 4,
        showProductImages: true,
        showPriceOnGrid: true,
        cartDisplayMode: 'detailed',
        layoutDirection: 'auto',
        syncVersion: 0,
        raw: {},
      );
      expect(state.theme, 'light');
      expect(state.primaryColor, '#FD8209');
      expect(state.fontScale, 1.0);
    });

    test('Receipt boolean combinations', () {
      const state = ReceiptLoaded(
        showVatNumber: false,
        showLoyaltyPoints: true,
        showBarcode: false,
        paperWidthMm: 80,
        syncVersion: 1,
        raw: {},
      );
      expect(state.showVatNumber, false);
      expect(state.showLoyaltyPoints, true);
      expect(state.showBarcode, false);
    });

    test('QuickAccess button structure', () {
      const state = QuickAccessLoaded(
        gridRows: 2,
        gridCols: 4,
        buttons: [
          {'id': 'btn1', 'label': 'Product A', 'product_id': 'uuid-123', 'color': '#FF0000', 'icon': 'star', 'row': 0, 'col': 0},
        ],
        syncVersion: 1,
        raw: {},
      );
      expect(state.buttons[0]['id'], 'btn1');
      expect(state.buttons[0]['product_id'], 'uuid-123');
      expect(state.buttons[0]['row'], 0);
      expect(state.buttons[0]['col'], 0);
    });
  });
}
