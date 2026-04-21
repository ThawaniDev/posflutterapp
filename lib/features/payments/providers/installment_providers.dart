import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/payments/models/store_installment_config.dart';
import 'package:wameedpos/features/payments/providers/installment_state.dart';
import 'package:wameedpos/features/payments/repositories/installment_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Platform Admin — Provider Management
// ═══════════════════════════════════════════════════════════════

final installmentAdminProvider = StateNotifierProvider<InstallmentAdminNotifier, InstallmentAdminState>((ref) {
  return InstallmentAdminNotifier(ref.watch(installmentRepositoryProvider));
});

class InstallmentAdminNotifier extends StateNotifier<InstallmentAdminState> {
  InstallmentAdminNotifier(this._repo) : super(const InstallmentAdminInitial());
  final InstallmentRepository _repo;

  Future<void> load() async {
    state = const InstallmentAdminLoading();
    try {
      final providers = await _repo.listProviders();
      state = InstallmentAdminLoaded(providers: providers);
    } on DioException catch (e) {
      state = InstallmentAdminError(message: _extractError(e));
    } catch (e) {
      state = InstallmentAdminError(message: e.toString());
    }
  }

  Future<void> updateProvider(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateProvider(id, data);
      await load();
    } on DioException catch (e) {
      state = InstallmentAdminError(message: _extractError(e));
    } catch (e) {
      state = InstallmentAdminError(message: e.toString());
    }
  }

  Future<void> toggleProvider(String id) async {
    try {
      await _repo.toggleProvider(id);
      await load();
    } on DioException catch (e) {
      state = InstallmentAdminError(message: _extractError(e));
    } catch (e) {
      state = InstallmentAdminError(message: e.toString());
    }
  }

  Future<void> setMaintenance(String id, Map<String, dynamic> data) async {
    try {
      await _repo.setMaintenance(id, data);
      await load();
    } on DioException catch (e) {
      state = InstallmentAdminError(message: _extractError(e));
    } catch (e) {
      state = InstallmentAdminError(message: e.toString());
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? e.message ?? 'Unknown error';
    }
    return e.message ?? 'Network error';
  }
}

// ═══════════════════════════════════════════════════════════════
// Store Admin — Installment Configuration
// ═══════════════════════════════════════════════════════════════

final storeInstallmentConfigProvider = StateNotifierProvider<StoreInstallmentConfigNotifier, StoreInstallmentConfigState>((ref) {
  return StoreInstallmentConfigNotifier(ref.watch(installmentRepositoryProvider));
});

class StoreInstallmentConfigNotifier extends StateNotifier<StoreInstallmentConfigState> {
  StoreInstallmentConfigNotifier(this._repo) : super(const StoreInstallmentConfigInitial());
  final InstallmentRepository _repo;

  Future<void> load() async {
    state = const StoreInstallmentConfigLoading();
    try {
      final results = await Future.wait([_repo.listStoreConfigs(), _repo.getAvailableProviders()]);
      state = StoreInstallmentConfigLoaded(
        configs: (results[0] as List).cast<StoreInstallmentConfig>(),
        availableProviders: (results[1] as List).cast<Map<String, dynamic>>(),
      );
    } on DioException catch (e) {
      state = StoreInstallmentConfigError(message: _extractError(e));
    } catch (e) {
      state = StoreInstallmentConfigError(message: e.toString());
    }
  }

  Future<void> upsertConfig(Map<String, dynamic> data) async {
    try {
      await _repo.upsertStoreConfig(data);
      await load();
    } on DioException catch (e) {
      state = StoreInstallmentConfigError(message: _extractError(e));
    } catch (e) {
      state = StoreInstallmentConfigError(message: e.toString());
    }
  }

  Future<void> toggleConfig(String provider) async {
    try {
      await _repo.toggleStoreConfig(provider);
      await load();
    } on DioException catch (e) {
      state = StoreInstallmentConfigError(message: _extractError(e));
    } catch (e) {
      state = StoreInstallmentConfigError(message: e.toString());
    }
  }

  Future<void> deleteConfig(String provider) async {
    try {
      await _repo.deleteStoreConfig(provider);
      await load();
    } on DioException catch (e) {
      state = StoreInstallmentConfigError(message: _extractError(e));
    } catch (e) {
      state = StoreInstallmentConfigError(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> testConnection(String provider) async {
    try {
      return await _repo.testConnection(provider);
    } on DioException catch (e) {
      return {'success': false, 'message': _extractError(e)};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? e.message ?? 'Unknown error';
    }
    return e.message ?? 'Network error';
  }
}

// ═══════════════════════════════════════════════════════════════
// POS Checkout — Installment Payment Flow
// ═══════════════════════════════════════════════════════════════

final installmentCheckoutProvider = StateNotifierProvider<InstallmentCheckoutNotifier, InstallmentCheckoutState>((ref) {
  return InstallmentCheckoutNotifier(ref.watch(installmentRepositoryProvider));
});

class InstallmentCheckoutNotifier extends StateNotifier<InstallmentCheckoutState> {
  InstallmentCheckoutNotifier(this._repo) : super(const InstallmentCheckoutInitial());
  final InstallmentRepository _repo;

  Future<void> loadProviders({required double amount, String currency = ''}) async {
    state = const InstallmentCheckoutLoading();
    try {
      final providers = await _repo.getCheckoutProviders(amount: amount, currency: currency);
      state = InstallmentCheckoutProvidersLoaded(providers: providers);
    } on DioException catch (e) {
      state = InstallmentCheckoutError(message: _extractError(e));
    } catch (e) {
      state = InstallmentCheckoutError(message: e.toString());
    }
  }

  Future<void> createCheckout(Map<String, dynamic> data) async {
    state = const InstallmentCheckoutLoading();
    try {
      final payment = await _repo.createCheckout(data);
      state = InstallmentCheckoutCreated(payment: payment);
    } on DioException catch (e) {
      state = InstallmentCheckoutFailed(message: _extractError(e));
    } catch (e) {
      state = InstallmentCheckoutFailed(message: e.toString());
    }
  }

  Future<void> confirmPayment(String id, {Map<String, dynamic>? providerData}) async {
    state = const InstallmentCheckoutLoading();
    try {
      final payment = await _repo.confirmPayment(id, providerData: providerData);
      state = InstallmentCheckoutCompleted(payment: payment);
    } on DioException catch (e) {
      state = InstallmentCheckoutFailed(message: _extractError(e));
    } catch (e) {
      state = InstallmentCheckoutFailed(message: e.toString());
    }
  }

  Future<void> cancelPayment(String id) async {
    try {
      await _repo.cancelPayment(id);
      state = const InstallmentCheckoutCancelled();
    } on DioException catch (e) {
      state = InstallmentCheckoutError(message: _extractError(e));
    } catch (e) {
      state = InstallmentCheckoutError(message: e.toString());
    }
  }

  Future<void> failPayment(String id, {String? errorCode, String? errorMessage}) async {
    try {
      await _repo.failPayment(id, errorCode: errorCode, errorMessage: errorMessage);
      state = InstallmentCheckoutFailed(message: errorMessage ?? 'Payment failed');
    } on DioException catch (e) {
      state = InstallmentCheckoutError(message: _extractError(e));
    } catch (e) {
      state = InstallmentCheckoutError(message: e.toString());
    }
  }

  void reset() {
    state = const InstallmentCheckoutInitial();
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? e.message ?? 'Unknown error';
    }
    return e.message ?? 'Network error';
  }
}
