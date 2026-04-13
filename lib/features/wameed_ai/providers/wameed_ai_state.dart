import 'package:thawani_pos/features/wameed_ai/models/ai_billing.dart';import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_usage.dart';

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
  final List<AIFeatureDefinition> features;
  const AIFeaturesLoaded({required this.features});
}

class AIFeaturesError extends AIFeaturesState {
  final String message;
  const AIFeaturesError({required this.message});
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
  final AIFeatureResult result;
  const AIFeatureResultLoaded({required this.result});
}

class AIFeatureResultError extends AIFeatureResultState {
  final String message;
  const AIFeatureResultError({required this.message});
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
  final List<AISuggestion> suggestions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? featureFilter;

  const AISuggestionsLoaded({
    required this.suggestions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.featureFilter,
  });

  bool get hasMore => currentPage < lastPage;
}

class AISuggestionsError extends AISuggestionsState {
  final String message;
  const AISuggestionsError({required this.message});
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
  final AIUsageSummary summary;
  const AIUsageLoaded({required this.summary});
}

class AIUsageError extends AIUsageState {
  final String message;
  const AIUsageError({required this.message});
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
  final AIFeatureResult result;
  final String query;
  const AISmartSearchLoaded({required this.result, required this.query});
}

class AISmartSearchError extends AISmartSearchState {
  final String message;
  const AISmartSearchError({required this.message});
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
  final AIBillingSummary summary;
  const AIBillingSummaryLoaded({required this.summary});
}

class AIBillingSummaryError extends AIBillingSummaryState {
  final String message;
  const AIBillingSummaryError({required this.message});
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
  final List<AIBillingInvoicePreview> invoices;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const AIBillingInvoicesLoaded({
    required this.invoices,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;
}

class AIBillingInvoicesError extends AIBillingInvoicesState {
  final String message;
  const AIBillingInvoicesError({required this.message});
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
  final AIBillingInvoiceDetail invoice;
  const AIBillingInvoiceDetailLoaded({required this.invoice});
}

class AIBillingInvoiceDetailError extends AIBillingInvoiceDetailState {
  final String message;
  const AIBillingInvoiceDetailError({required this.message});
}
