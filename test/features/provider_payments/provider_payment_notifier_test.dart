// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/provider_payments/data/remote/provider_payment_api_service.dart';
import 'package:wameedpos/features/provider_payments/enums/provider_payment_status.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_providers.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_state.dart';
import 'package:wameedpos/features/provider_payments/repositories/provider_payment_repository.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

ProviderPayment _stubPayment({String id = 'pay-1', String status = 'pending', String? redirectUrl}) {
  return ProviderPayment(
    id: id,
    amount: 100,
    totalAmount: 115,
    status: _statusFromString(status),
    redirectUrl: redirectUrl,
  );
}

ProviderPaymentStatus _statusFromString(String s) {
  switch (s) {
    case 'completed':
      return ProviderPaymentStatus.completed;
    case 'failed':
      return ProviderPaymentStatus.failed;
    default:
      return ProviderPaymentStatus.pending;
  }
}

// ─── Fake Repository ──────────────────────────────────────────────────────────

class _FakeRepository extends ProviderPaymentRepository {
  _FakeRepository() : super(_noopApiService());

  Future<List<ProviderPayment>> Function({String? status, String? purpose})? onListPayments;
  Future<ProviderPayment> Function(String id)? onGetPayment;
  Future<ProviderPayment> Function({
    required String purpose,
    required String purposeLabel,
    required double amount,
    String? billingCycle,
    String? discountCode,
    String? subscriptionPlanId,
    String? addOnId,
    String? purposeReferenceId,
    String? currency,
    String? notes,
    double? taxAmount,
  })? onInitiatePayment;
  Future<void> Function(String paymentId)? onResendEmail;

  @override
  Future<List<ProviderPayment>> listPayments({int? page, int? perPage, String? status, String? purpose}) =>
      onListPayments?.call(status: status, purpose: purpose) ?? super.listPayments();

  @override
  Future<ProviderPayment> getPayment(String id) => onGetPayment?.call(id) ?? super.getPayment(id);

  @override
  Future<ProviderPayment> initiatePayment({
    required String purpose,
    required String purposeLabel,
    required double amount,
    double? taxAmount,
    String? subscriptionPlanId,
    String? addOnId,
    String? purposeReferenceId,
    String? currency,
    String? billingCycle,
    String? discountCode,
    String? notes,
  }) =>
      onInitiatePayment?.call(
        purpose: purpose,
        purposeLabel: purposeLabel,
        amount: amount,
        billingCycle: billingCycle,
        discountCode: discountCode,
        subscriptionPlanId: subscriptionPlanId,
        addOnId: addOnId,
        purposeReferenceId: purposeReferenceId,
        currency: currency,
        notes: notes,
        taxAmount: taxAmount,
      ) ??
          super.initiatePayment(purpose: purpose, purposeLabel: purposeLabel, amount: amount);

  @override
  Future<void> resendEmail(String paymentId) => onResendEmail?.call(paymentId) ?? super.resendEmail(paymentId);
}

ProviderPaymentApiService _noopApiService() => ProviderPaymentApiService(
      Dio(BaseOptions(baseUrl: 'http://noop')),
    );

ProviderContainer _container(_FakeRepository repo) => ProviderContainer(
      overrides: [providerPaymentRepositoryProvider.overrideWithValue(repo)],
    );

// ─── Fake AppLocalizations ────────────────────────────────────────────────────

class _FakeL10n extends AppLocalizations {
  _FakeL10n() : super('en');
  @override
  String get providerPaymentInitiated => 'Payment initiated';
  @override
  String get providerEmailResent => 'Email resent';
  // Unused overrides required by the abstract class
  @override
  dynamic noSuchMethod(Invocation invocation) => '';
}

final _l10n = _FakeL10n();

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ─── ProviderPaymentsListNotifier ─────────────────────────────

  group('ProviderPaymentsListNotifier', () {
    test('initial state is ProviderPaymentsListInitial', () {
      final container = _container(_FakeRepository());
      addTearDown(container.dispose);

      expect(
        container.read(providerPaymentsListProvider),
        isA<ProviderPaymentsListInitial>(),
      );
    });

    test('loadPayments transitions to loaded on success', () async {
      final repo = _FakeRepository()
        ..onListPayments = ({status, purpose}) async => [_stubPayment(), _stubPayment(id: 'pay-2')];
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentsListProvider.notifier).loadPayments();

      final state = container.read(providerPaymentsListProvider);
      expect(state, isA<ProviderPaymentsListLoaded>());
      expect((state as ProviderPaymentsListLoaded).payments, hasLength(2));
    });

    test('loadPayments transitions to error on failure', () async {
      final repo = _FakeRepository()..onListPayments = ({status, purpose}) async => throw Exception('Network error');
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentsListProvider.notifier).loadPayments();

      final state = container.read(providerPaymentsListProvider);
      expect(state, isA<ProviderPaymentsListError>());
      expect((state as ProviderPaymentsListError).message, contains('Network error'));
    });

    test('loadPayments passes status filter to repository', () async {
      String? capturedStatus;
      final repo = _FakeRepository()
        ..onListPayments = ({status, purpose}) async {
          capturedStatus = status;
          return [];
        };
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentsListProvider.notifier).loadPayments(status: 'completed');

      expect(capturedStatus, 'completed');
    });
  });

  // ─── ProviderPaymentDetailNotifier ───────────────────────────

  group('ProviderPaymentDetailNotifier', () {
    test('initial state is ProviderPaymentDetailInitial', () {
      final container = _container(_FakeRepository());
      addTearDown(container.dispose);

      expect(
        container.read(providerPaymentDetailProvider),
        isA<ProviderPaymentDetailInitial>(),
      );
    });

    test('loadPayment transitions to loaded on success', () async {
      final payment = _stubPayment(id: 'pay-detail-1', status: 'completed');
      final repo = _FakeRepository()..onGetPayment = (id) async => payment;
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentDetailProvider.notifier).loadPayment('pay-detail-1');

      final state = container.read(providerPaymentDetailProvider);
      expect(state, isA<ProviderPaymentDetailLoaded>());
      expect((state as ProviderPaymentDetailLoaded).payment.id, 'pay-detail-1');
    });

    test('loadPayment transitions to error on not-found', () async {
      final repo = _FakeRepository()
        ..onGetPayment = (id) async => throw ProviderPaymentException(message: 'Not found', statusCode: 404);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentDetailProvider.notifier).loadPayment('bad-id');

      final state = container.read(providerPaymentDetailProvider);
      expect(state, isA<ProviderPaymentDetailError>());
      expect((state as ProviderPaymentDetailError).message, contains('Not found'));
    });
  });

  // ─── ProviderPaymentActionNotifier ───────────────────────────

  group('ProviderPaymentActionNotifier', () {
    test('initial state is ProviderPaymentActionIdle', () {
      final container = _container(_FakeRepository());
      addTearDown(container.dispose);

      expect(
        container.read(providerPaymentActionProvider),
        isA<ProviderPaymentActionIdle>(),
      );
    });

    test('initiatePayment transitions to success with payment', () async {
      final stubPayment = _stubPayment(redirectUrl: 'https://pay.example.com/checkout');
      final repo = _FakeRepository()
        ..onInitiatePayment = ({
          required purpose,
          required purposeLabel,
          required amount,
          billingCycle,
          discountCode,
          subscriptionPlanId,
          addOnId,
          purposeReferenceId,
          currency,
          notes,
          taxAmount,
        }) async =>
            stubPayment;
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).initiatePayment(
            _l10n,
            purpose: 'subscription',
            purposeLabel: 'Growth (monthly)',
            amount: 49.99,
            subscriptionPlanId: 'plan-uuid-1',
            billingCycle: 'monthly',
          );

      final state = container.read(providerPaymentActionProvider);
      expect(state, isA<ProviderPaymentActionSuccess>());
      final success = state as ProviderPaymentActionSuccess;
      expect(success.payment?.redirectUrl, 'https://pay.example.com/checkout');
      expect(success.message, 'Payment initiated');
    });

    test('initiatePayment passes billing_cycle and discount_code to repository', () async {
      String? capturedBillingCycle;
      String? capturedDiscountCode;

      final repo = _FakeRepository()
        ..onInitiatePayment = ({
          required purpose,
          required purposeLabel,
          required amount,
          billingCycle,
          discountCode,
          subscriptionPlanId,
          addOnId,
          purposeReferenceId,
          currency,
          notes,
          taxAmount,
        }) async {
          capturedBillingCycle = billingCycle;
          capturedDiscountCode = discountCode;
          return _stubPayment();
        };
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).initiatePayment(
            _l10n,
            purpose: 'subscription',
            purposeLabel: 'Growth (yearly)',
            amount: 499.99,
            subscriptionPlanId: 'plan-uuid-1',
            billingCycle: 'yearly',
            discountCode: 'ANNUAL20',
          );

      expect(capturedBillingCycle, 'yearly');
      expect(capturedDiscountCode, 'ANNUAL20');
    });

    test('initiatePayment transitions to error on failure', () async {
      final repo = _FakeRepository()
        ..onInitiatePayment = ({
          required purpose,
          required purposeLabel,
          required amount,
          billingCycle,
          discountCode,
          subscriptionPlanId,
          addOnId,
          purposeReferenceId,
          currency,
          notes,
          taxAmount,
        }) async =>
            throw ProviderPaymentException(message: 'Plan is inactive', statusCode: 422);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).initiatePayment(
            _l10n,
            purpose: 'subscription',
            purposeLabel: 'Old Plan',
            amount: 9.99,
          );

      final state = container.read(providerPaymentActionProvider);
      expect(state, isA<ProviderPaymentActionError>());
      expect((state as ProviderPaymentActionError).message, contains('Plan is inactive'));
    });

    test('resendEmail transitions to success on completion', () async {
      String? capturedPaymentId;
      final repo = _FakeRepository()
        ..onResendEmail = (id) async {
          capturedPaymentId = id;
        };
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).resendEmail(_l10n, 'pay-uuid-999');

      final state = container.read(providerPaymentActionProvider);
      expect(state, isA<ProviderPaymentActionSuccess>());
      expect((state as ProviderPaymentActionSuccess).message, 'Email resent');
      expect(capturedPaymentId, 'pay-uuid-999');
    });

    test('resendEmail transitions to error on failure', () async {
      final repo = _FakeRepository()
        ..onResendEmail = (id) async => throw ProviderPaymentException(message: 'Payment not found', statusCode: 404);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).resendEmail(_l10n, 'bad-id');

      final state = container.read(providerPaymentActionProvider);
      expect(state, isA<ProviderPaymentActionError>());
      expect((state as ProviderPaymentActionError).message, contains('Payment not found'));
    });

    test('reset returns notifier to idle state', () async {
      final repo = _FakeRepository()
        ..onResendEmail = (_) async => throw ProviderPaymentException(message: 'err');
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(providerPaymentActionProvider.notifier).resendEmail(_l10n, 'x');
      expect(container.read(providerPaymentActionProvider), isA<ProviderPaymentActionError>());

      container.read(providerPaymentActionProvider.notifier).reset();
      expect(container.read(providerPaymentActionProvider), isA<ProviderPaymentActionIdle>());
    });
  });
}
