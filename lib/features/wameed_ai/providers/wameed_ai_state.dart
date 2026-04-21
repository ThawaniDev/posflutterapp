import 'package:wameedpos/features/wameed_ai/models/ai_billing.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_usage.dart';

// ─── Features State ─────────────────────────────────────────────

sealed class AIFeaturesState {
  const AIFeaturesState();
}

class AIFeaturesInitial extends AIFeaturesState {
  const AIFeaturesInitial();
}

class AIFeaturesLoading extends AIFeaturesState {
  const AIFeaturesLoading();
}

class AIFeaturesLoaded extends AIFeaturesState {
  const AIFeaturesLoaded({required this.features});
  final List<AIFeatureDefinition> features;
}

class AIFeaturesError extends AIFeaturesState {
  const AIFeaturesError({required this.message});
  final String message;
}

// ─── Feature Result State ───────────────────────────────────────

sealed class AIFeatureResultState {
  const AIFeatureResultState();
}

class AIFeatureResultInitial extends AIFeatureResultState {
  const AIFeatureResultInitial();
}

class AIFeatureResultLoading extends AIFeatureResultState {
  const AIFeatureResultLoading();
}

class AIFeatureResultLoaded extends AIFeatureResultState {
  const AIFeatureResultLoaded({required this.result});
  final AIFeatureResult result;
}

class AIFeatureResultError extends AIFeatureResultState {
  const AIFeatureResultError({required this.message});
  final String message;
}

// ─── Suggestions State ──────────────────────────────────────────

sealed class AISuggestionsState {
  const AISuggestionsState();
}

class AISuggestionsInitial extends AISuggestionsState {
  const AISuggestionsInitial();
}

class AISuggestionsLoading extends AISuggestionsState {
  const AISuggestionsLoading();
}

class AISuggestionsLoaded extends AISuggestionsState {

  const AISuggestionsLoaded({
    required this.suggestions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.featureFilter,
  });
  final List<AISuggestion> suggestions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? featureFilter;

  bool get hasMore => currentPage < lastPage;
}

class AISuggestionsError extends AISuggestionsState {
  const AISuggestionsError({required this.message});
  final String message;
}

// ─── Usage State ────────────────────────────────────────────────

sealed class AIUsageState {
  const AIUsageState();
}

class AIUsageInitial extends AIUsageState {
  const AIUsageInitial();
}

class AIUsageLoading extends AIUsageState {
  const AIUsageLoading();
}

class AIUsageLoaded extends AIUsageState {
  const AIUsageLoaded({required this.summary});
  final AIUsageSummary summary;
}

class AIUsageError extends AIUsageState {
  const AIUsageError({required this.message});
  final String message;
}

// ─── Smart Search State ─────────────────────────────────────────

sealed class AISmartSearchState {
  const AISmartSearchState();
}

class AISmartSearchInitial extends AISmartSearchState {
  const AISmartSearchInitial();
}

class AISmartSearchLoading extends AISmartSearchState {
  const AISmartSearchLoading();
}

class AISmartSearchLoaded extends AISmartSearchState {
  const AISmartSearchLoaded({required this.result, required this.query});
  final AIFeatureResult result;
  final String query;
}

class AISmartSearchError extends AISmartSearchState {
  const AISmartSearchError({required this.message});
  final String message;
}

// ─── Billing Summary State ──────────────────────────────────────

sealed class AIBillingSummaryState {
  const AIBillingSummaryState();
}

class AIBillingSummaryInitial extends AIBillingSummaryState {
  const AIBillingSummaryInitial();
}

class AIBillingSummaryLoading extends AIBillingSummaryState {
  const AIBillingSummaryLoading();
}

class AIBillingSummaryLoaded extends AIBillingSummaryState {
  const AIBillingSummaryLoaded({required this.summary});
  final AIBillingSummary summary;
}

class AIBillingSummaryError extends AIBillingSummaryState {
  const AIBillingSummaryError({required this.message});
  final String message;
}

// ─── Billing Invoices State ─────────────────────────────────────

sealed class AIBillingInvoicesState {
  const AIBillingInvoicesState();
}

class AIBillingInvoicesInitial extends AIBillingInvoicesState {
  const AIBillingInvoicesInitial();
}

class AIBillingInvoicesLoading extends AIBillingInvoicesState {
  const AIBillingInvoicesLoading();
}

class AIBillingInvoicesLoaded extends AIBillingInvoicesState {

  const AIBillingInvoicesLoaded({
    required this.invoices,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<AIBillingInvoicePreview> invoices;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class AIBillingInvoicesError extends AIBillingInvoicesState {
  const AIBillingInvoicesError({required this.message});
  final String message;
}

// ─── Billing Invoice Detail State ───────────────────────────────

sealed class AIBillingInvoiceDetailState {
  const AIBillingInvoiceDetailState();
}

class AIBillingInvoiceDetailInitial extends AIBillingInvoiceDetailState {
  const AIBillingInvoiceDetailInitial();
}

class AIBillingInvoiceDetailLoading extends AIBillingInvoiceDetailState {
  const AIBillingInvoiceDetailLoading();
}

class AIBillingInvoiceDetailLoaded extends AIBillingInvoiceDetailState {
  const AIBillingInvoiceDetailLoaded({required this.invoice});
  final AIBillingInvoiceDetail invoice;
}

class AIBillingInvoiceDetailError extends AIBillingInvoiceDetailState {
  const AIBillingInvoiceDetailError({required this.message});
  final String message;
}
