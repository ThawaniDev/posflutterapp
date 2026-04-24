import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/customers/data/remote/customer_api_service.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/models/digital_receipt_log.dart';
import 'package:wameedpos/features/customers/models/loyalty_config.dart';
import 'package:wameedpos/features/customers/models/loyalty_transaction.dart';
import 'package:wameedpos/features/customers/models/store_credit_transaction.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(api: ref.watch(customerApiServiceProvider));
});

/// Thin facade over [CustomerApiService] so providers depend on a single port.
class CustomerRepository {
  CustomerRepository({required CustomerApiService api}) : _api = api;
  final CustomerApiService _api;

  // Customers
  Future<PaginatedResult<Customer>> listCustomers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? groupId,
  }) =>
      _api.listCustomers(page: page, perPage: perPage, search: search, groupId: groupId);

  Future<Customer> getCustomer(String id) => _api.getCustomer(id);
  Future<Customer> createCustomer(Map<String, dynamic> data) => _api.createCustomer(data);
  Future<Customer> updateCustomer(String id, Map<String, dynamic> data) => _api.updateCustomer(id, data);
  Future<void> deleteCustomer(String id) => _api.deleteCustomer(id);
  Future<List<Customer>> searchCustomers(String q, {int limit = 10}) => _api.searchCustomers(q, limit: limit);
  Future<({List<Customer> data, String serverTime, int count})> syncDelta({String? since, int limit = 500}) =>
      _api.syncDelta(since: since, limit: limit);

  // History & receipts
  Future<Map<String, dynamic>> getCustomerOrders(String id, {int perPage = 20}) =>
      _api.getCustomerOrders(id, perPage: perPage);
  Future<DigitalReceiptLog> sendReceipt(String customerId,
          {required String orderId, required String channel, String? destination}) =>
      _api.sendReceipt(customerId, orderId: orderId, channel: channel, destination: destination);

  // Groups
  Future<List<CustomerGroup>> listGroups() => _api.listGroups();
  Future<CustomerGroup> createGroup(Map<String, dynamic> data) => _api.createGroup(data);
  Future<CustomerGroup> updateGroup(String id, Map<String, dynamic> data) => _api.updateGroup(id, data);
  Future<void> deleteGroup(String id) => _api.deleteGroup(id);

  // Loyalty
  Future<LoyaltyConfig?> getLoyaltyConfig() => _api.getLoyaltyConfig();
  Future<LoyaltyConfig> saveLoyaltyConfig(Map<String, dynamic> data) => _api.saveLoyaltyConfig(data);
  Future<List<LoyaltyTransaction>> getLoyaltyLog(String customerId) => _api.getLoyaltyLog(customerId);
  Future<LoyaltyTransaction> adjustLoyalty(String customerId,
          {required int points, required String type, String? notes, String? orderId}) =>
      _api.adjustLoyalty(customerId, points: points, type: type, notes: notes, orderId: orderId);
  Future<LoyaltyTransaction> redeemLoyalty(String customerId, {required int points, String? orderId}) =>
      _api.redeemLoyalty(customerId, points: points, orderId: orderId);

  // Store credit
  Future<List<StoreCreditTransaction>> getStoreCreditLog(String customerId) => _api.getStoreCreditLog(customerId);
  Future<StoreCreditTransaction> topUpCredit(String customerId, {required double amount, String? notes}) =>
      _api.topUpCredit(customerId, amount: amount, notes: notes);
  Future<StoreCreditTransaction> adjustCredit(String customerId, {required double amount, String? notes}) =>
      _api.adjustCredit(customerId, amount: amount, notes: notes);
}
