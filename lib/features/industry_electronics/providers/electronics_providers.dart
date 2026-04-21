import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_state.dart';
import 'package:wameedpos/features/industry_electronics/repositories/electronics_repository.dart';

final electronicsProvider = StateNotifierProvider<ElectronicsNotifier, ElectronicsState>((ref) {
  return ElectronicsNotifier(ref.watch(electronicsRepositoryProvider));
});

class ElectronicsNotifier extends StateNotifier<ElectronicsState> {
  ElectronicsNotifier(this._repo) : super(const ElectronicsInitial());
  final ElectronicsRepository _repo;

  Future<void> load() async {
    state = const ElectronicsLoading();
    try {
      final imei = await _repo.listImeiRecords();
      final repairs = await _repo.listRepairJobs();
      final tradeIns = await _repo.listTradeIns();
      state = ElectronicsLoaded(imeiRecords: imei, repairJobs: repairs, tradeIns: tradeIns);
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    } catch (e) {
      state = ElectronicsError(message: e.toString());
    }
  }

  Future<void> createRepairJob(Map<String, dynamic> data) async {
    try {
      await _repo.createRepairJob(data);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    }
  }

  Future<void> updateRepairJob(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateRepairJob(id, data);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    }
  }

  Future<void> updateRepairJobStatus(String id, String status) async {
    try {
      await _repo.updateRepairJobStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    }
  }

  Future<void> createImeiRecord(Map<String, dynamic> data) async {
    try {
      await _repo.createImeiRecord(data);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    }
  }

  Future<void> updateImeiRecord(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateImeiRecord(id, data);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
    }
  }

  Future<void> createTradeIn(Map<String, dynamic> data) async {
    try {
      await _repo.createTradeIn(data);
      await load();
    } on DioException catch (e) {
      state = ElectronicsError(message: _extractError(e));
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
