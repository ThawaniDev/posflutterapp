// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/security/data/remote/security_api_service.dart';
import 'package:wameedpos/features/security/widgets/pin_override_dialog.dart';

// ─── Fake SecurityApiService ──────────────────────────────────────

class _FakeSecurityApi extends SecurityApiService {
  _FakeSecurityApi({this.respondWith}) : super(Dio());

  /// When set, `requestPinOverride` succeeds and returns this response.
  Map<String, dynamic>? respondWith;

  /// When set, `requestPinOverride` throws this exception.
  Exception? throwError;

  /// When set, `requestPinOverride` will wait for this completer before returning.
  Completer<void>? hangUntil;

  int callCount = 0;
  String? lastPin;

  @override
  Future<Map<String, dynamic>> requestPinOverride({
    required String storeId,
    required String requestingUserId,
    required String pin,
    required String permissionCode,
    Map<String, dynamic>? actionContext,
  }) async {
    callCount++;
    lastPin = pin;
    if (hangUntil != null) await hangUntil!.future;
    if (throwError != null) throw throwError!;
    return respondWith!;
  }
}

// ─── Widget harness ───────────────────────────────────────────────

Widget _harness(Widget child, {required SecurityApiService api}) {
  return ProviderScope(
    overrides: [securityApiServiceProvider.overrideWithValue(api)],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

/// Pumps the PinOverrideDialog as if opened via Navigator.push for pop results.
Widget _dialogHarness({required SecurityApiService api}) {
  return ProviderScope(
    overrides: [securityApiServiceProvider.overrideWithValue(api)],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (ctx) => TextButton(
            onPressed: () => showPinOverrideDialog(
              ctx,
              storeId: 'store-001',
              requestingUserId: 'user-001',
              permissionCode: 'pos.discount',
            ),
            child: const Text('OPEN DIALOG'),
          ),
        ),
      ),
    ),
  );
}

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  group('PinOverrideDialog', () {
    // NOTE: The PinOverrideDialog numpad is taller than the default 504px test
    // surface. Each test calls _enlargeSurface(tester) before pumping widgets.

    // ─ Render ─────────────────────────────────────────────────

    testWidgets('renders dialog with permission code and numpad', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi(respondWith: {
        'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'},
      });

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();

      // Open the dialog
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Permission code label
      expect(find.text('pos.discount'), findsOneWidget);

      // Numpad digits 0–9 should be present
      for (final digit in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) {
        expect(find.text(digit), findsWidgets);
      }

      // Backspace and clear keys
      expect(find.text('⌫'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    // ─ Digit input ────────────────────────────────────────────

    testWidgets('tapping digit keys adds digits without auto-submit until 6', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi(respondWith: {
        'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'},
      });

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Tap 5 digits (less than _pinLength=6) — should not submit
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('2').first);
      await tester.tap(find.text('3').first);
      await tester.tap(find.text('4').first);
      await tester.tap(find.text('5').first);
      await tester.pump();

      // API not called yet
      expect(api.callCount, 0);
    });

    // ─ Auto-submit on 6th digit ───────────────────────────────

    testWidgets('auto-submits when 6th digit is tapped', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi(respondWith: {
        'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'},
      });

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Tap 6 digits — auto-submits
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('2').first);
      await tester.tap(find.text('3').first);
      await tester.tap(find.text('4').first);
      await tester.tap(find.text('5').first);
      await tester.pump();
      expect(api.callCount, 0);
      await tester.tap(find.text('6').first);
      await tester.pumpAndSettle();

      // API was called
      expect(api.callCount, 1);
      expect(api.lastPin, '123456');
    });

    // ─ Backspace ──────────────────────────────────────────────

    testWidgets('backspace removes last digit', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi(respondWith: {
        'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'},
      });

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Tap 3 digits then backspace
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('2').first);
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('⌫'));
      await tester.pump();

      // Now enter 4 more digits to complete PIN — total digits: 1,2, then 4,5,6,7
      // (3 was removed; enter 3 more to get to 5, then 1 more for 6)
      await tester.tap(find.text('4').first);
      await tester.tap(find.text('5').first);
      await tester.tap(find.text('6').first);
      await tester.tap(find.text('7').first);
      await tester.pumpAndSettle();

      // PIN should be 1,2,4,5,6,7
      expect(api.lastPin, '124567');
    });

    // ─ Loading state ──────────────────────────────────────────

    testWidgets('shows loading spinner while awaiting API response', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      // Use a Completer so we can hold the API in-flight without real timers.
      final hang = Completer<void>();
      final api = _FakeSecurityApi(
        respondWith: {'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'}},
      )..hangUntil = hang;

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Tap 6 digits quickly without settling
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('2').first);
      await tester.tap(find.text('3').first);
      await tester.tap(find.text('4').first);
      await tester.tap(find.text('5').first);
      await tester.tap(find.text('6').first);
      // pump one frame so setState(_isLoading=true) is applied but future not yet resolved
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Unblock the API so the test ends cleanly (no pending timers)
      hang.complete();
      await tester.pumpAndSettle();
    });

    // ─ Cancel button ──────────────────────────────────────────

    testWidgets('cancel button closes the dialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi(respondWith: {
        'data': {'id': 'ov-1', 'authorizing_user_id': 'mgr-1'},
      });

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Confirm dialog is open
      expect(find.byType(PinOverrideDialog), findsOneWidget);

      // Press cancel
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.cancel));
      await tester.pumpAndSettle();

      // Dialog dismissed
      expect(find.byType(PinOverrideDialog), findsNothing);
    });

    // ─ Error handling ─────────────────────────────────────────

    testWidgets('shows error message when API throws', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final api = _FakeSecurityApi()
        ..throwError = Exception('Invalid PIN for override');

      await tester.pumpWidget(_dialogHarness(api: api));
      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      // Enter 6 digits to trigger submission
      await tester.tap(find.text('1').first);
      await tester.tap(find.text('2').first);
      await tester.tap(find.text('3').first);
      await tester.tap(find.text('4').first);
      await tester.tap(find.text('5').first);
      await tester.tap(find.text('6').first);
      await tester.pumpAndSettle();

      // Dialog should still be visible with error message
      expect(find.byType(PinOverrideDialog), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
