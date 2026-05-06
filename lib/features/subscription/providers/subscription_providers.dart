import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/repositories/subscription_repository.dart';

// ─── Plans Provider ──────────────────────────────────────────────

final plansProvider = StateNotifierProvider<PlansNotifier, PlansState>((ref) {
  return PlansNotifier(ref.watch(subscriptionRepositoryProvider));
});

class PlansNotifier extends StateNotifier<PlansState> {
  PlansNotifier(this._repository) : super(const PlansInitial());
  final SubscriptionRepository _repository;

  Future<void> loadPlans({bool activeOnly = true}) async {
    state = const PlansLoading();
    try {
      final plans = await _repository.listPlans(activeOnly: activeOnly);
      state = PlansLoaded(plans: plans);
    } catch (e) {
      state = PlansError(message: _extractMessage(e));
    }
  }
}

// ─── Subscription Provider ───────────────────────────────────────

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier(ref.watch(subscriptionRepositoryProvider));
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier(this._repository) : super(const SubscriptionInitial());
  final SubscriptionRepository _repository;

  Future<void> loadCurrent() async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.getCurrentSubscription();
      state = SubscriptionLoaded(subscription: subscription);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> subscribe(
    AppLocalizations l10n, {
    required String planId,
    String billingCycle = 'monthly',
    String? paymentMethod,
  }) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.subscribe(planId: planId, billingCycle: billingCycle, paymentMethod: paymentMethod);
      state = SubscriptionActionSuccess(subscription: subscription, message: l10n.subscriptionSubscribed);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> changePlan(AppLocalizations l10n, {required String planId, String billingCycle = 'monthly'}) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.changePlan(planId: planId, billingCycle: billingCycle);
      state = SubscriptionActionSuccess(subscription: subscription, message: l10n.subscriptionPlanChanged);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> cancel(AppLocalizations l10n, {String? reason, String? reasonCategory}) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.cancelSubscription(reason: reason, reasonCategory: reasonCategory);
      state = SubscriptionActionSuccess(subscription: subscription, message: l10n.subscriptionCancelled);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> resume(AppLocalizations l10n) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.resumeSubscription();
      state = SubscriptionActionSuccess(subscription: subscription, message: l10n.subscriptionResumed);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }
}

// ─── Invoices Provider ───────────────────────────────────────────

final invoicesProvider = StateNotifierProvider<InvoicesNotifier, InvoicesState>((ref) {
  return InvoicesNotifier(ref.watch(subscriptionRepositoryProvider));
});

class InvoicesNotifier extends StateNotifier<InvoicesState> {
  InvoicesNotifier(this._repository) : super(const InvoicesInitial());
  final SubscriptionRepository _repository;

  Future<void> loadInvoices({int page = 1}) async {
    state = const InvoicesLoading();
    try {
      final invoices = await _repository.getInvoices(page: page);
      state = InvoicesLoaded(invoices: invoices);
    } catch (e) {
      state = InvoicesError(message: _extractMessage(e));
    }
  }
}

// ─── Invoice Detail Provider ─────────────────────────────────────

final invoiceDetailProvider = StateNotifierProvider.family<InvoiceDetailNotifier, InvoiceDetailState, String>((ref, invoiceId) {
  return InvoiceDetailNotifier(ref.watch(subscriptionRepositoryProvider), invoiceId);
});

class InvoiceDetailNotifier extends StateNotifier<InvoiceDetailState> {
  InvoiceDetailNotifier(this._repository, this._invoiceId) : super(const InvoiceDetailInitial());
  final SubscriptionRepository _repository;
  final String _invoiceId;

  Future<void> loadInvoice() async {
    state = const InvoiceDetailLoading();
    try {
      final invoice = await _repository.getInvoice(_invoiceId);
      state = InvoiceDetailLoaded(invoice: invoice);
    } catch (e) {
      state = InvoiceDetailError(message: _extractMessage(e));
    }
  }

  Future<String?> getInvoicePdfUrl() async {
    try {
      return await _repository.getInvoicePdfUrl(_invoiceId);
    } catch (e) {
      return null;
    }
  }
}

// ─── Usage Provider ──────────────────────────────────────────────

final usageProvider = StateNotifierProvider<UsageNotifier, UsageState>((ref) {
  return UsageNotifier(ref.watch(subscriptionRepositoryProvider));
});

class UsageNotifier extends StateNotifier<UsageState> {
  UsageNotifier(this._repository) : super(const UsageInitial());
  final SubscriptionRepository _repository;

  Future<void> loadUsage() async {
    state = const UsageLoading();
    try {
      final items = await _repository.getUsageSummary();
      state = UsageLoaded(usageItems: items);
    } catch (e) {
      state = UsageError(message: _extractMessage(e));
    }
  }
}

// ─── Add-Ons Provider ────────────────────────────────────────────

final addOnsProvider = StateNotifierProvider<AddOnsNotifier, AddOnsState>((ref) {
  return AddOnsNotifier(ref.watch(subscriptionRepositoryProvider));
});

class AddOnsNotifier extends StateNotifier<AddOnsState> {
  AddOnsNotifier(this._repository) : super(const AddOnsInitial());
  final SubscriptionRepository _repository;

  Future<void> loadAddOns() async {
    state = const AddOnsLoading();
    try {
      final results = await Future.wait([_repository.listAddOns(), _repository.getStoreAddOns()]);
      state = AddOnsLoaded(availableAddOns: results[0], storeAddOns: results[1]);
    } catch (e) {
      state = AddOnsError(message: _extractMessage(e));
    }
  }
}

// ─── Plan Comparison Provider ────────────────────────────────────

final planComparisonProvider = StateNotifierProvider<PlanComparisonNotifier, PlanComparisonState>((ref) {
  return PlanComparisonNotifier(ref.watch(subscriptionRepositoryProvider));
});

class PlanComparisonNotifier extends StateNotifier<PlanComparisonState> {
  PlanComparisonNotifier(this._repository) : super(const PlanComparisonInitial());
  final SubscriptionRepository _repository;

  Future<void> loadComparison(List<String> planIds) async {
    state = const PlanComparisonLoading();
    try {
      final comparison = await _repository.comparePlans(planIds);
      state = PlanComparisonLoaded(comparison: comparison);
    } catch (e) {
      state = PlanComparisonError(message: _extractMessage(e));
    }
  }
}

// ─── Entitlements Provider ───────────────────────────────────────

final entitlementsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.syncEntitlements();
});

// ─── Feature Check Provider ──────────────────────────────────────

final featureEnabledProvider = FutureProvider.family<bool, String>((ref, featureKey) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.checkFeature(featureKey);
});

// ─── Limit Check Provider ────────────────────────────────────────

final limitCheckProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, limitKey) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.checkLimit(limitKey);
});

// ─── Invoice PDF URL Provider ────────────────────────────────────

final invoicePdfUrlProvider = FutureProvider.family<String?, String>((ref, invoiceId) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  try {
    return await repo.getInvoicePdfUrl(invoiceId);
  } catch (_) {
    return null;
  }
});

// ─── Helpers ─────────────────────────────────────────────────────

String _extractMessage(dynamic error) {
  if (error is SubscriptionException) return error.message;
  return error.toString();
}
