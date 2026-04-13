import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/wameed_ai/data/wameed_ai_repository.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}

// ─── Features Provider ──────────────────────────────────────────

final aiFeaturesProvider = StateNotifierProvider<AIFeaturesNotifier, AIFeaturesState>((ref) {
  return AIFeaturesNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIFeaturesNotifier extends StateNotifier<AIFeaturesState> {
  final WameedAIRepository _repo;

  AIFeaturesNotifier(this._repo) : super(const AIFeaturesInitial());

  Future<void> load() async {
    state = const AIFeaturesLoading();
    try {
      final features = await _repo.getFeatures();
      state = AIFeaturesLoaded(features: features);
    } on DioException catch (e) {
      state = AIFeaturesError(message: _extractError(e));
    } catch (e) {
      state = AIFeaturesError(message: e.toString());
    }
  }

  Future<void> updateFeatureConfig(String featureId, {required bool isEnabled}) async {
    try {
      await _repo.updateStoreConfig(featureId, {'is_enabled': isEnabled});
      await load();
    } on DioException catch (e) {
      state = AIFeaturesError(message: _extractError(e));
    }
  }
}

// ─── Feature Result Provider ────────────────────────────────────

final aiFeatureResultProvider = StateNotifierProvider<AIFeatureResultNotifier, AIFeatureResultState>((ref) {
  return AIFeatureResultNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIFeatureResultNotifier extends StateNotifier<AIFeatureResultState> {
  final WameedAIRepository _repo;

  AIFeatureResultNotifier(this._repo) : super(const AIFeatureResultInitial());

  Future<void> invoke(String slug, {Map<String, dynamic>? params}) async {
    state = const AIFeatureResultLoading();
    try {
      final result = await _repo.invokeFeature(slug, params: params);
      state = AIFeatureResultLoaded(result: result);
    } on DioException catch (e) {
      state = AIFeatureResultError(message: _extractError(e));
    } catch (e) {
      state = AIFeatureResultError(message: e.toString());
    }
  }

  void reset() => state = const AIFeatureResultInitial();
}

// ─── Suggestions Provider ───────────────────────────────────────

final aiSuggestionsProvider = StateNotifierProvider<AISuggestionsNotifier, AISuggestionsState>((ref) {
  return AISuggestionsNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AISuggestionsNotifier extends StateNotifier<AISuggestionsState> {
  final WameedAIRepository _repo;

  AISuggestionsNotifier(this._repo) : super(const AISuggestionsInitial());

  Future<void> load({int page = 1, String? featureSlug, String? status}) async {
    state = const AISuggestionsLoading();
    try {
      final result = await _repo.getSuggestions(page: page, featureSlug: featureSlug, status: status);
      state = AISuggestionsLoaded(
        suggestions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        featureFilter: featureSlug,
      );
    } on DioException catch (e) {
      state = AISuggestionsError(message: _extractError(e));
    } catch (e) {
      state = AISuggestionsError(message: e.toString());
    }
  }

  Future<void> updateStatus(String suggestionId, String status) async {
    try {
      await _repo.updateSuggestionStatus(suggestionId, status);
      await load();
    } on DioException catch (e) {
      state = AISuggestionsError(message: _extractError(e));
    }
  }
}

// ─── Usage Provider ─────────────────────────────────────────────

final aiUsageProvider = StateNotifierProvider<AIUsageNotifier, AIUsageState>((ref) {
  return AIUsageNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIUsageNotifier extends StateNotifier<AIUsageState> {
  final WameedAIRepository _repo;

  AIUsageNotifier(this._repo) : super(const AIUsageInitial());

  Future<void> load() async {
    state = const AIUsageLoading();
    try {
      final summary = await _repo.getUsage();
      state = AIUsageLoaded(summary: summary);
    } on DioException catch (e) {
      state = AIUsageError(message: _extractError(e));
    } catch (e) {
      state = AIUsageError(message: e.toString());
    }
  }
}

// ─── Smart Search Provider ──────────────────────────────────────

final aiSmartSearchProvider = StateNotifierProvider<AISmartSearchNotifier, AISmartSearchState>((ref) {
  return AISmartSearchNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AISmartSearchNotifier extends StateNotifier<AISmartSearchState> {
  final WameedAIRepository _repo;

  AISmartSearchNotifier(this._repo) : super(const AISmartSearchInitial());

  Future<void> search(String query) async {
    state = const AISmartSearchLoading();
    try {
      final result = await _repo.invokeFeature('smart_search', params: {'query': query});
      state = AISmartSearchLoaded(result: result, query: query);
    } on DioException catch (e) {
      state = AISmartSearchError(message: _extractError(e));
    } catch (e) {
      state = AISmartSearchError(message: e.toString());
    }
  }

  void reset() => state = const AISmartSearchInitial();
}

// ─── Billing Summary Provider ───────────────────────────────────

final aiBillingSummaryProvider = StateNotifierProvider<AIBillingSummaryNotifier, AIBillingSummaryState>((ref) {
  return AIBillingSummaryNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIBillingSummaryNotifier extends StateNotifier<AIBillingSummaryState> {
  final WameedAIRepository _repo;

  AIBillingSummaryNotifier(this._repo) : super(const AIBillingSummaryInitial());

  Future<void> load() async {
    state = const AIBillingSummaryLoading();
    try {
      final summary = await _repo.getBillingSummary();
      state = AIBillingSummaryLoaded(summary: summary);
    } on DioException catch (e) {
      state = AIBillingSummaryError(message: _extractError(e));
    } catch (e) {
      state = AIBillingSummaryError(message: e.toString());
    }
  }
}

// ─── Billing Invoices Provider ──────────────────────────────────

final aiBillingInvoicesProvider = StateNotifierProvider<AIBillingInvoicesNotifier, AIBillingInvoicesState>((ref) {
  return AIBillingInvoicesNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIBillingInvoicesNotifier extends StateNotifier<AIBillingInvoicesState> {
  final WameedAIRepository _repo;

  AIBillingInvoicesNotifier(this._repo) : super(const AIBillingInvoicesInitial());

  Future<void> load({int page = 1}) async {
    state = const AIBillingInvoicesLoading();
    try {
      final result = await _repo.getBillingInvoices(page: page);
      state = AIBillingInvoicesLoaded(
        invoices: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = AIBillingInvoicesError(message: _extractError(e));
    } catch (e) {
      state = AIBillingInvoicesError(message: e.toString());
    }
  }
}

// ─── Billing Invoice Detail Provider ────────────────────────────

final aiBillingInvoiceDetailProvider = StateNotifierProvider<AIBillingInvoiceDetailNotifier, AIBillingInvoiceDetailState>((ref) {
  return AIBillingInvoiceDetailNotifier(ref.watch(wameedAIRepositoryProvider));
});

class AIBillingInvoiceDetailNotifier extends StateNotifier<AIBillingInvoiceDetailState> {
  final WameedAIRepository _repo;

  AIBillingInvoiceDetailNotifier(this._repo) : super(const AIBillingInvoiceDetailInitial());

  Future<void> load(String invoiceId) async {
    state = const AIBillingInvoiceDetailLoading();
    try {
      final invoice = await _repo.getBillingInvoiceDetail(invoiceId);
      state = AIBillingInvoiceDetailLoaded(invoice: invoice);
    } on DioException catch (e) {
      state = AIBillingInvoiceDetailError(message: _extractError(e));
    } catch (e) {
      state = AIBillingInvoiceDetailError(message: e.toString());
    }
  }

  void reset() => state = const AIBillingInvoiceDetailInitial();
}
