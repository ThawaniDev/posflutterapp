import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';

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
  const PlansLoaded({required this.plans});
  final List<SubscriptionPlan> plans;
}

class PlansError extends PlansState {
  const PlansError({required this.message});
  final String message;
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
  const SubscriptionLoaded({this.subscription});
  final StoreSubscription? subscription;
}

class SubscriptionActionSuccess extends SubscriptionState {
  const SubscriptionActionSuccess({required this.subscription, required this.message});
  final StoreSubscription subscription;
  final String message;
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError({required this.message});
  final String message;
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
  const InvoicesLoaded({required this.invoices, this.currentPage = 1, this.lastPage = 1, this.total = 0});
  final List<Invoice> invoices;
  final int currentPage;
  final int lastPage;
  final int total;
}

class InvoicesError extends InvoicesState {
  const InvoicesError({required this.message});
  final String message;
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
  const UsageLoaded({required this.usageItems});
  final List<Map<String, dynamic>> usageItems;
}

class UsageError extends UsageState {
  const UsageError({required this.message});
  final String message;
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
  const InvoiceDetailLoaded({required this.invoice});
  final Invoice invoice;
}

class InvoiceDetailError extends InvoiceDetailState {
  const InvoiceDetailError({required this.message});
  final String message;
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
  const AddOnsLoaded({required this.availableAddOns, required this.storeAddOns});
  final List<Map<String, dynamic>> availableAddOns;
  final List<Map<String, dynamic>> storeAddOns;
}

class AddOnsError extends AddOnsState {
  const AddOnsError({required this.message});
  final String message;
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
  const PlanComparisonLoaded({required this.comparison});
  final Map<String, dynamic> comparison;
}

class PlanComparisonError extends PlanComparisonState {
  const PlanComparisonError({required this.message});
  final String message;
}
