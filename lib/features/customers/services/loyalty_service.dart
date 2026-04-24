import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/models/loyalty_config.dart';
import 'package:wameedpos/features/customers/models/loyalty_transaction.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

/// Wraps remote loyalty endpoints. POS code only depends on this façade.
class LoyaltyService {
  LoyaltyService(this._repo);
  final CustomerRepository _repo;

  Future<LoyaltyConfig?> getConfig() => _repo.getLoyaltyConfig();
  Future<LoyaltyConfig> saveConfig(Map<String, dynamic> data) => _repo.saveLoyaltyConfig(data);

  Future<List<LoyaltyTransaction>> log(String customerId) => _repo.getLoyaltyLog(customerId);

  Future<LoyaltyTransaction> adjust(
    String customerId, {
    required int points,
    required String type, // ManualAdjustment | Earn | Redeem | VoidReversal
    String? notes,
    String? orderId,
  }) => _repo.adjustLoyalty(customerId, points: points, type: type, notes: notes, orderId: orderId);

  Future<LoyaltyTransaction> redeem(String customerId, {required int points, String? orderId}) =>
      _repo.redeemLoyalty(customerId, points: points, orderId: orderId);

  /// Convenience: convert points to monetary value using the active config.
  double pointsToCash(LoyaltyConfig? config, int points) {
    if (config == null || points <= 0) return 0;
    final sarPerPoint = config.sarPerPoint ?? 0;
    return points * sarPerPoint;
  }
}

final loyaltyServiceProvider = Provider<LoyaltyService>((ref) {
  return LoyaltyService(ref.watch(customerRepositoryProvider));
});
