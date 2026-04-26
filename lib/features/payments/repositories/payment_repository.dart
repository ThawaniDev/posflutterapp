import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/payments/data/remote/payment_api_service.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(apiService: ref.watch(paymentApiServiceProvider));
});

class PaymentRepository {
  PaymentRepository({required PaymentApiService apiService}) : _apiService = apiService;
  final PaymentApiService _apiService;

  // ─── Payments ─────────────────────────────────────────────────

  Future<PaginatedResult<Payment>> listPayments({
    int page = 1,
    int perPage = 20,
    String? method,
    String? transactionId,
    String? status,
    String? startDate,
    String? endDate,
    String? search,
  }) => _apiService.listPayments(
    page: page,
    perPage: perPage,
    method: method,
    transactionId: transactionId,
    status: status,
    startDate: startDate,
    endDate: endDate,
    search: search,
  );

  Future<Payment> createPayment(Map<String, dynamic> data) => _apiService.createPayment(data);

  // ─── Refunds ──────────────────────────────────────────────────

  Future<PaginatedResult<Refund>> listRefunds({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? status,
    String? method,
  }) => _apiService.listRefunds(
    page: page,
    perPage: perPage,
    startDate: startDate,
    endDate: endDate,
    status: status,
    method: method,
  );

  Future<PaginatedResult<Refund>> listPaymentRefunds(String paymentId, {int page = 1}) =>
      _apiService.listPaymentRefunds(paymentId, page: page);

  Future<Refund> createRefund(String paymentId, Map<String, dynamic> data) => _apiService.createRefund(paymentId, data);

  // ─── Cash Sessions ────────────────────────────────────────────

  Future<PaginatedResult<CashSession>> listCashSessions({int page = 1, int perPage = 20}) =>
      _apiService.listCashSessions(page: page, perPage: perPage);

  Future<CashSession> openCashSession(Map<String, dynamic> data) => _apiService.openCashSession(data);

  Future<CashSession> getCashSession(String id) => _apiService.getCashSession(id);

  Future<CashSession> closeCashSession(String id, Map<String, dynamic> data) => _apiService.closeCashSession(id, data);

  // ─── Cash Events ──────────────────────────────────────────────

  Future<CashEvent> createCashEvent(Map<String, dynamic> data) => _apiService.createCashEvent(data);

  // ─── Expenses ─────────────────────────────────────────────────

  Future<PaginatedResult<Expense>> listExpenses({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? category,
  }) => _apiService.listExpenses(page: page, perPage: perPage, startDate: startDate, endDate: endDate, category: category);

  Future<Expense> createExpense(Map<String, dynamic> data) => _apiService.createExpense(data);

  Future<Expense> updateExpense(String id, Map<String, dynamic> data) => _apiService.updateExpense(id, data);

  Future<void> deleteExpense(String id) => _apiService.deleteExpense(id);

  // ─── Gift Cards ───────────────────────────────────────────────

  Future<PaginatedResult<GiftCard>> listGiftCards({int page = 1, int perPage = 20, String? status}) =>
      _apiService.listGiftCards(page: page, perPage: perPage, status: status);

  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) => _apiService.issueGiftCard(data);

  Future<Map<String, dynamic>> checkGiftCardBalance(String code) => _apiService.checkGiftCardBalance(code);

  Future<GiftCard> redeemGiftCard(String code, double amount) => _apiService.redeemGiftCard(code, amount);

  Future<GiftCard> deactivateGiftCard(String code) => _apiService.deactivateGiftCard(code);

  // ─── Financial Reports ────────────────────────────────────────

  Future<Map<String, dynamic>> getDailySummary({String? date}) => _apiService.dailySummary(date: date);

  Future<Map<String, dynamic>> getReconciliation({String? startDate, String? endDate}) =>
      _apiService.reconciliation(startDate: startDate, endDate: endDate);
}
