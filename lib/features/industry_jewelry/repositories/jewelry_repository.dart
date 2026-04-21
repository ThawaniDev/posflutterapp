import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_jewelry/data/remote/jewelry_api_service.dart';
import 'package:wameedpos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:wameedpos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:wameedpos/features/industry_jewelry/models/buyback_transaction.dart';

final jewelryRepositoryProvider = Provider<JewelryRepository>((ref) {
  return JewelryRepository(apiService: ref.watch(jewelryApiServiceProvider));
});

class JewelryRepository {
  JewelryRepository({required JewelryApiService apiService}) : _apiService = apiService;
  final JewelryApiService _apiService;

  Future<List<DailyMetalRate>> listMetalRates({String? metalType, int perPage = 20}) =>
      _apiService.listMetalRates(metalType: metalType, perPage: perPage);
  Future<DailyMetalRate> upsertMetalRate(Map<String, dynamic> data) => _apiService.upsertMetalRate(data);

  Future<List<JewelryProductDetail>> listProductDetails({String? metalType, String? productId, int perPage = 20}) =>
      _apiService.listProductDetails(metalType: metalType, productId: productId, perPage: perPage);
  Future<JewelryProductDetail> createProductDetail(Map<String, dynamic> data) => _apiService.createProductDetail(data);
  Future<JewelryProductDetail> updateProductDetail(String id, Map<String, dynamic> data) =>
      _apiService.updateProductDetail(id, data);

  Future<List<BuybackTransaction>> listBuybacks({String? metalType, String? customerId, int perPage = 20}) =>
      _apiService.listBuybacks(metalType: metalType, customerId: customerId, perPage: perPage);
  Future<BuybackTransaction> createBuyback(Map<String, dynamic> data) => _apiService.createBuyback(data);
}
