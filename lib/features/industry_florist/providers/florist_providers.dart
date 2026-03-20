import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_florist/providers/florist_state.dart';
import 'package:thawani_pos/features/industry_florist/repositories/florist_repository.dart';

final floristProvider = StateNotifierProvider<FloristNotifier, FloristState>((ref) {
  return FloristNotifier(ref.watch(floristRepositoryProvider));
});

class FloristNotifier extends StateNotifier<FloristState> {
  final FloristRepository _repo;
  FloristNotifier(this._repo) : super(const FloristInitial());

  Future<void> load() async {
    state = const FloristLoading();
    try {
      final arrangements = await _repo.listArrangements();
      final logs = await _repo.listFreshnessLogs();
      final subs = await _repo.listSubscriptions();
      state = FloristLoaded(arrangements: arrangements, freshnessLogs: logs, subscriptions: subs);
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    } catch (e) {
      state = FloristError(message: e.toString());
    }
  }

  Future<void> createArrangement(Map<String, dynamic> data) async {
    try {
      await _repo.createArrangement(data);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> updateArrangement(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateArrangement(id, data);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> deleteArrangement(String id) async {
    try {
      await _repo.deleteArrangement(id);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> createFreshnessLog(Map<String, dynamic> data) async {
    try {
      await _repo.createFreshnessLog(data);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> updateFreshnessLogStatus(String id, String status) async {
    try {
      await _repo.updateFreshnessLogStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> createSubscription(Map<String, dynamic> data) async {
    try {
      await _repo.createSubscription(data);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> updateSubscription(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateSubscription(id, data);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
    }
  }

  Future<void> toggleSubscription(String id) async {
    try {
      await _repo.toggleSubscription(id);
      await load();
    } on DioException catch (e) {
      state = FloristError(message: _extractError(e));
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
