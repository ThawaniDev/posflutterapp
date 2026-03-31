import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/payments/data/remote/payment_api_service.dart';
import 'package:thawani_pos/features/payments/models/cash_event.dart';
import 'package:thawani_pos/features/payments/models/cash_session.dart';
import 'package:thawani_pos/features/payments/models/expense.dart';
import 'package:thawani_pos/features/payments/models/gift_card.dart';
import 'package:thawani_pos/features/payments/models/payment.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(apiService: ref.watch(paymentApiServiceProvider));
});

class PaymentRepository {
  final PaymentApiService _apiService;

  PaymentRepository({required PaymentApiService apiService}) : _apiService = apiService;

  // Payments
  Future<PaginatedResult<Payment>> listPayments({int page = 1, int perPage = 20, String? method, String? transactionId}) =>
      _apiService.listPayments(page: page, perPage: perPage, method: method, transactionId: transactionId);
  Future<Payment> createPayment(Map<String, dynamic> data) => _apiService.createPayment(data);

  // Cash Sessions
  Future<PaginatedResult<CashSession>> listCashSessions({int page = 1, int perPage = 20}) =>
      _apiService.listCashSessions(page: page, perPage: perPage);
  Future<CashSession> openCashSession(Map<String, dynamic> data) => _apiService.openCashSession(data);
  Future<CashSession> getCashSession(String id) => _apiService.getCashSession(id);
  Future<CashSession> closeCashSession(String id, Map<String, dynamic> data) => _apiService.closeCashSession(id, data);

  // Cash Events
  Future<CashEvent> createCashEvent(Map<String, dynamic> data) => _apiService.createCashEvent(data);

  // Expenses
  Future<PaginatedResult<Expense>> listExpenses({int page = 1, int perPage = 20}) =>
      _apiService.listExpenses(page: page, perPage: perPage);
  Future<Expense> createExpense(Map<String, dynamic> data) => _apiService.createExpense(data);

  // Gift Cards
  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) => _apiService.issueGiftCard(data);
  Future<Map<String, dynamic>> checkGiftCardBalance(String code) => _apiService.checkGiftCardBalance(code);
  Future<GiftCard> redeemGiftCard(String code, double amount) => _apiService.redeemGiftCard(code, amount);

  // Financial Reports
  Future<Map<String, dynamic>> dailySummary({String? date}) => _apiService.dailySummary(date: date);
  Future<Map<String, dynamic>> reconciliation({String? startDate, String? endDate}) =>
      _apiService.reconciliation(startDate: startDate, endDate: endDate);
}
