import 'package:thawani_pos/features/subscription/enums/billing_cycle.dart';
import 'package:thawani_pos/features/payments/enums/subscription_payment_method.dart';
import 'package:thawani_pos/features/subscription/enums/subscription_status.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';

class StoreSubscription {
  final String id;
  final String organizationId;
  final String subscriptionPlanId;
  final SubscriptionStatus status;
  final BillingCycle? billingCycle;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? trialEndsAt;
  final SubscriptionPaymentMethod? paymentMethod;
  final DateTime? cancelledAt;
  final DateTime? gracePeriodEndsAt;
  final SubscriptionPlan? plan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreSubscription({
    required this.id,
    required this.organizationId,
    required this.subscriptionPlanId,
    required this.status,
    this.billingCycle,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.trialEndsAt,
    this.paymentMethod,
    this.cancelledAt,
    this.gracePeriodEndsAt,
    this.plan,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreSubscription.fromJson(Map<String, dynamic> json) {
    return StoreSubscription(
      id: json['id'] as String,
      organizationId: (json['organization_id'] ?? json['store_id']) as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      status: SubscriptionStatus.fromValue(json['status'] as String),
      billingCycle: BillingCycle.tryFromValue(json['billing_cycle'] as String?),
      currentPeriodStart: json['current_period_start'] != null ? DateTime.parse(json['current_period_start'] as String) : null,
      currentPeriodEnd: json['current_period_end'] != null ? DateTime.parse(json['current_period_end'] as String) : null,
      trialEndsAt: json['trial_ends_at'] != null ? DateTime.parse(json['trial_ends_at'] as String) : null,
      paymentMethod: SubscriptionPaymentMethod.tryFromValue(json['payment_method'] as String?),
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
      gracePeriodEndsAt: json['grace_period_ends_at'] != null ? DateTime.parse(json['grace_period_ends_at'] as String) : null,
      plan: json['plan'] != null ? SubscriptionPlan.fromJson(Map<String, dynamic>.from(json['plan'] as Map)) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'subscription_plan_id': subscriptionPlanId,
      'status': status.value,
      'billing_cycle': billingCycle?.value,
      'current_period_start': currentPeriodStart?.toIso8601String(),
      'current_period_end': currentPeriodEnd?.toIso8601String(),
      'trial_ends_at': trialEndsAt?.toIso8601String(),
      'payment_method': paymentMethod?.value,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'grace_period_ends_at': gracePeriodEndsAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StoreSubscription copyWith({
    String? id,
    String? organizationId,
    String? subscriptionPlanId,
    SubscriptionStatus? status,
    BillingCycle? billingCycle,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
    DateTime? trialEndsAt,
    SubscriptionPaymentMethod? paymentMethod,
    DateTime? cancelledAt,
    DateTime? gracePeriodEndsAt,
    SubscriptionPlan? plan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreSubscription(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      status: status ?? this.status,
      billingCycle: billingCycle ?? this.billingCycle,
      currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      gracePeriodEndsAt: gracePeriodEndsAt ?? this.gracePeriodEndsAt,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreSubscription && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// Whether the subscription is currently active (active or trial status)
  bool get isActive => status == SubscriptionStatus.active || status == SubscriptionStatus.trial;

  @override
  String toString() => 'StoreSubscription(id: $id, organizationId: $organizationId, status: $status)';
}
