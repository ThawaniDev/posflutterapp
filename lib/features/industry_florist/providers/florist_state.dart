import 'package:thawani_pos/features/industry_florist/models/flower_arrangement.dart';
import 'package:thawani_pos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:thawani_pos/features/industry_florist/models/flower_subscription.dart';

sealed class FloristState {
  const FloristState();
}

class FloristInitial extends FloristState {
  const FloristInitial();
}

class FloristLoading extends FloristState {
  const FloristLoading();
}

class FloristLoaded extends FloristState {
  final List<FlowerArrangement> arrangements;
  final List<FlowerFreshnessLog> freshnessLogs;
  final List<FlowerSubscription> subscriptions;

  const FloristLoaded({required this.arrangements, required this.freshnessLogs, required this.subscriptions});

  FloristLoaded copyWith({
    List<FlowerArrangement>? arrangements,
    List<FlowerFreshnessLog>? freshnessLogs,
    List<FlowerSubscription>? subscriptions,
  }) => FloristLoaded(
    arrangements: arrangements ?? this.arrangements,
    freshnessLogs: freshnessLogs ?? this.freshnessLogs,
    subscriptions: subscriptions ?? this.subscriptions,
  );
}

class FloristError extends FloristState {
  final String message;
  const FloristError({required this.message});
}
