import 'package:thawani_pos/features/subscription/models/invoice.dart';
import 'package:thawani_pos/features/subscription/models/store_subscription.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';

// ─── Plans State ─────────────────────────────────────────────────

sealed class PlansState {
  const PlansState();
}

class PlansInitial extends PlansState {
  const PlansInitial();
}

class PlansLoading extends PlansState {
  const PlansLoading();
}

class PlansLoaded extends PlansState {
  final List<SubscriptionPlan> plans;
  const PlansLoaded({required this.plans});
}

class PlansError extends PlansState {
  final String message;
  const PlansError({required this.message});
}

// ─── Subscription State ──────────────────────────────────────────

sealed class SubscriptionState {
  const SubscriptionState();
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionLoaded extends SubscriptionState {
  final StoreSubscription? subscription;
  const SubscriptionLoaded({this.subscription});
}

class SubscriptionActionSuccess extends SubscriptionState {
  final StoreSubscription subscription;
  final String message;
  const SubscriptionActionSuccess({required this.subscription, required this.message});
}

class SubscriptionError extends SubscriptionState {
  final String message;
  const SubscriptionError({required this.message});
}

// ─── Invoices State ──────────────────────────────────────────────

sealed class InvoicesState {
  const InvoicesState();
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

class InvoicesLoaded extends InvoicesState {
  final List<Invoice> invoices;
  const InvoicesLoaded({required this.invoices});
}

class InvoicesError extends InvoicesState {
  final String message;
  const InvoicesError({required this.message});
}

// ─── Usage State ─────────────────────────────────────────────────

sealed class UsageState {
  const UsageState();
}

class UsageInitial extends UsageState {
  const UsageInitial();
}

class UsageLoading extends UsageState {
  const UsageLoading();
}

class UsageLoaded extends UsageState {
  final List<Map<String, dynamic>> usageItems;
  const UsageLoaded({required this.usageItems});
}

class UsageError extends UsageState {
  final String message;
  const UsageError({required this.message});
}
