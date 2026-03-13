import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/customers/data/remote/customer_api_service.dart';
import 'package:thawani_pos/features/customers/models/customer.dart';
import 'package:thawani_pos/features/customers/models/customer_group.dart';
import 'package:thawani_pos/features/customers/models/loyalty_transaction.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(apiService: ref.watch(customerApiServiceProvider));
});

class CustomerRepository {
  final CustomerApiService _apiService;

  CustomerRepository({required CustomerApiService apiService}) : _apiService = apiService;

  // Customers
  Future<PaginatedResult<Customer>> listCustomers({int page = 1, int perPage = 20, String? search, String? groupId}) =>
      _apiService.listCustomers(page: page, perPage: perPage, search: search, groupId: groupId);
  Future<Customer> getCustomer(String id) => _apiService.getCustomer(id);
  Future<Customer> createCustomer(Map<String, dynamic> data) => _apiService.createCustomer(data);
  Future<Customer> updateCustomer(String id, Map<String, dynamic> data) => _apiService.updateCustomer(id, data);
  Future<void> deleteCustomer(String id) => _apiService.deleteCustomer(id);

  // Groups
  Future<List<CustomerGroup>> listGroups() => _apiService.listGroups();
  Future<CustomerGroup> createGroup(Map<String, dynamic> data) => _apiService.createGroup(data);
  Future<CustomerGroup> updateGroup(String id, Map<String, dynamic> data) => _apiService.updateGroup(id, data);
  Future<void> deleteGroup(String id) => _apiService.deleteGroup(id);

  // Loyalty
  Future<Map<String, dynamic>> getLoyaltyConfig() => _apiService.getLoyaltyConfig();
  Future<void> saveLoyaltyConfig(Map<String, dynamic> data) => _apiService.saveLoyaltyConfig(data);
  Future<void> earnPoints(String customerId, Map<String, dynamic> data) => _apiService.earnPoints(customerId, data);
  Future<void> redeemPoints(String customerId, Map<String, dynamic> data) => _apiService.redeemPoints(customerId, data);
  Future<List<LoyaltyTransaction>> getLoyaltyLog(String customerId) => _apiService.getLoyaltyLog(customerId);
  Future<void> topUpCredit(String customerId, Map<String, dynamic> data) => _apiService.topUpCredit(customerId, data);
}
