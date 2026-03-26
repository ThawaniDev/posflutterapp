import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';

enum DeliveryOrderStatus {
  pending('pending'),
  accepted('accepted'),
  preparing('preparing'),
  ready('ready'),
  dispatched('dispatched'),
  delivered('delivered'),
  rejected('rejected'),
  cancelled('cancelled'),
  failed('failed');

  const DeliveryOrderStatus(this.value);
  final String value;

  String get label => switch (this) {
    pending => 'Pending',
    accepted => 'Accepted',
    preparing => 'Preparing',
    ready => 'Ready',
    dispatched => 'Dispatched',
    delivered => 'Delivered',
    rejected => 'Rejected',
    cancelled => 'Cancelled',
    failed => 'Failed',
  };

  Color get color => switch (this) {
    pending => AppColors.warning,
    accepted => AppColors.info,
    preparing => AppColors.primary,
    ready => AppColors.info,
    dispatched => AppColors.purple,
    delivered => AppColors.success,
    rejected => AppColors.error,
    cancelled => AppColors.error,
    failed => AppColors.error,
  };

  IconData get icon => switch (this) {
    pending => Icons.schedule,
    accepted => Icons.thumb_up_outlined,
    preparing => Icons.restaurant,
    ready => Icons.check_circle_outline,
    dispatched => Icons.delivery_dining,
    delivered => Icons.done_all,
    rejected => Icons.cancel_outlined,
    cancelled => Icons.block,
    failed => Icons.error_outline,
  };

  bool get isTerminal => switch (this) {
    delivered || rejected || cancelled || failed => true,
    _ => false,
  };

  bool get isActionable => switch (this) {
    pending || accepted || preparing || ready => true,
    _ => false,
  };

  /// Next allowed statuses for store-side workflow
  List<DeliveryOrderStatus> get allowedTransitions => switch (this) {
    pending => [accepted, rejected],
    accepted => [preparing, cancelled],
    preparing => [ready, cancelled],
    ready => [dispatched],
    dispatched => [delivered],
    _ => [],
  };

  static DeliveryOrderStatus fromValue(String value) {
    return DeliveryOrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryOrderStatus: $value'),
    );
  }

  static DeliveryOrderStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
