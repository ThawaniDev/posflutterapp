import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/repositories/subscription_repository.dart';

// ─── Plans Provider ──────────────────────────────────────────────

final plansProvider = StateNotifierProvider<PlansNotifier, PlansState>((ref) {
  return PlansNotifier(ref.watch(subscriptionRepositoryProvider));
});

class PlansNotifier extends StateNotifier<PlansState> {
  final SubscriptionRepository _repository;

  PlansNotifier(this._repository) : super(const PlansInitial());

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
  final SubscriptionRepository _repository;

  SubscriptionNotifier(this._repository) : super(const SubscriptionInitial());

  Future<void> loadCurrent() async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.getCurrentSubscription();
      state = SubscriptionLoaded(subscription: subscription);
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> subscribe({required String planId, String billingCycle = 'monthly', String? paymentMethod}) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.subscribe(planId: planId, billingCycle: billingCycle, paymentMethod: paymentMethod);
      state = SubscriptionActionSuccess(subscription: subscription, message: 'Subscribed successfully!');
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> changePlan({required String planId, String billingCycle = 'monthly'}) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.changePlan(planId: planId, billingCycle: billingCycle);
      state = SubscriptionActionSuccess(subscription: subscription, message: 'Plan changed successfully!');
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> cancel({String? reason}) async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.cancelSubscription(reason: reason);
      state = SubscriptionActionSuccess(subscription: subscription, message: 'Subscription cancelled.');
    } catch (e) {
      state = SubscriptionError(message: _extractMessage(e));
    }
  }

  Future<void> resume() async {
    state = const SubscriptionLoading();
    try {
      final subscription = await _repository.resumeSubscription();
      state = SubscriptionActionSuccess(subscription: subscription, message: 'Subscription resumed!');
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
  final SubscriptionRepository _repository;

  InvoicesNotifier(this._repository) : super(const InvoicesInitial());

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

// ─── Usage Provider ──────────────────────────────────────────────

final usageProvider = StateNotifierProvider<UsageNotifier, UsageState>((ref) {
  return UsageNotifier(ref.watch(subscriptionRepositoryProvider));
});

class UsageNotifier extends StateNotifier<UsageState> {
  final SubscriptionRepository _repository;

  UsageNotifier(this._repository) : super(const UsageInitial());

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

// ─── Helpers ─────────────────────────────────────────────────────

String _extractMessage(dynamic error) {
  if (error is SubscriptionException) return error.message;
  return error.toString();
}
