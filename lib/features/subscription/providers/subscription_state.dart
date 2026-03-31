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
  final int currentPage;
  final int lastPage;
  final int total;
  const InvoicesLoaded({required this.invoices, this.currentPage = 1, this.lastPage = 1, this.total = 0});
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

// ─── Invoice Detail State ────────────────────────────────────────

sealed class InvoiceDetailState {
  const InvoiceDetailState();
}

class InvoiceDetailInitial extends InvoiceDetailState {
  const InvoiceDetailInitial();
}

class InvoiceDetailLoading extends InvoiceDetailState {
  const InvoiceDetailLoading();
}

class InvoiceDetailLoaded extends InvoiceDetailState {
  final Invoice invoice;
  const InvoiceDetailLoaded({required this.invoice});
}

class InvoiceDetailError extends InvoiceDetailState {
  final String message;
  const InvoiceDetailError({required this.message});
}

// ─── Add-Ons State ───────────────────────────────────────────────

sealed class AddOnsState {
  const AddOnsState();
}

class AddOnsInitial extends AddOnsState {
  const AddOnsInitial();
}

class AddOnsLoading extends AddOnsState {
  const AddOnsLoading();
}

class AddOnsLoaded extends AddOnsState {
  final List<Map<String, dynamic>> availableAddOns;
  final List<Map<String, dynamic>> storeAddOns;
  const AddOnsLoaded({required this.availableAddOns, required this.storeAddOns});
}

class AddOnsError extends AddOnsState {
  final String message;
  const AddOnsError({required this.message});
}

// ─── Plan Comparison State ───────────────────────────────────────

sealed class PlanComparisonState {
  const PlanComparisonState();
}

class PlanComparisonInitial extends PlanComparisonState {
  const PlanComparisonInitial();
}

class PlanComparisonLoading extends PlanComparisonState {
  const PlanComparisonLoading();
}

class PlanComparisonLoaded extends PlanComparisonState {
  final Map<String, dynamic> comparison;
  const PlanComparisonLoaded({required this.comparison});
}

class PlanComparisonError extends PlanComparisonState {
  final String message;
  const PlanComparisonError({required this.message});
}
