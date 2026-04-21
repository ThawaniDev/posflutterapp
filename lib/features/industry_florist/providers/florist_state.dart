import 'package:wameedpos/features/industry_florist/models/flower_arrangement.dart';
import 'package:wameedpos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:wameedpos/features/industry_florist/models/flower_subscription.dart';

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

  const FloristLoaded({required this.arrangements, required this.freshnessLogs, required this.subscriptions});
  final List<FlowerArrangement> arrangements;
  final List<FlowerFreshnessLog> freshnessLogs;
  final List<FlowerSubscription> subscriptions;

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
  const FloristError({required this.message});
  final String message;
}
