import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_bakery/providers/bakery_state.dart';
import 'package:wameedpos/features/industry_bakery/repositories/bakery_repository.dart';

final bakeryProvider = StateNotifierProvider<BakeryNotifier, BakeryState>((ref) {
  return BakeryNotifier(ref.watch(bakeryRepositoryProvider));
});

class BakeryNotifier extends StateNotifier<BakeryState> {
  BakeryNotifier(this._repo) : super(const BakeryInitial());
  final BakeryRepository _repo;

  Future<void> load() async {
    state = const BakeryLoading();
    try {
      final recipes = await _repo.listRecipes();
      final schedules = await _repo.listProductionSchedules();
      final cakes = await _repo.listCakeOrders();
      state = BakeryLoaded(recipes: recipes, productionSchedules: schedules, cakeOrders: cakes);
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    } catch (e) {
      state = BakeryError(message: e.toString());
    }
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {
    try {
      await _repo.createRecipe(data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateRecipe(id, data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _repo.deleteRecipe(id);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> createProductionSchedule(Map<String, dynamic> data) async {
    try {
      await _repo.createProductionSchedule(data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> updateProductionSchedule(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateProductionSchedule(id, data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> updateProductionScheduleStatus(String id, String status) async {
    try {
      await _repo.updateProductionScheduleStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> createCakeOrder(Map<String, dynamic> data) async {
    try {
      await _repo.createCakeOrder(data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> updateCakeOrder(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateCakeOrder(id, data);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
    }
  }

  Future<void> updateCakeOrderStatus(String id, String status) async {
    try {
      await _repo.updateCakeOrderStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = BakeryError(message: _extractError(e));
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
