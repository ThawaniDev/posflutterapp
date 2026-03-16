import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_state.dart';
import 'package:thawani_pos/features/industry_jewelry/repositories/jewelry_repository.dart';

final jewelryProvider = StateNotifierProvider<JewelryNotifier, JewelryState>((ref) {
  return JewelryNotifier(ref.watch(jewelryRepositoryProvider));
});

class JewelryNotifier extends StateNotifier<JewelryState> {
  final JewelryRepository _repo;
  JewelryNotifier(this._repo) : super(const JewelryInitial());

  Future<void> load() async {
    state = const JewelryLoading();
    try {
      final rates = await _repo.listMetalRates();
      final details = await _repo.listProductDetails();
      final buybacks = await _repo.listBuybacks();
      state = JewelryLoaded(metalRates: rates, productDetails: details, buybacks: buybacks);
    } on DioException catch (e) {
      state = JewelryError(message: _extractError(e));
    } catch (e) {
      state = JewelryError(message: e.toString());
    }
  }

  Future<void> upsertMetalRate(Map<String, dynamic> data) async {
    try {
      await _repo.upsertMetalRate(data);
      await load();
    } on DioException catch (e) {
      state = JewelryError(message: _extractError(e));
    }
  }

  Future<void> createBuyback(Map<String, dynamic> data) async {
    try {
      await _repo.createBuyback(data);
      await load();
    } on DioException catch (e) {
      state = JewelryError(message: _extractError(e));
    }
  }
}

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
