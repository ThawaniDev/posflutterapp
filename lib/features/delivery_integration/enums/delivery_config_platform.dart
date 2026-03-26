import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';

enum DeliveryConfigPlatform {
  hungerstation('hungerstation'),
  jahez('jahez'),
  marsool('marsool'),
  keeta('keeta'),
  noonFood('noon_food'),
  ninja('ninja'),
  theChefz('the_chefz'),
  talabat('talabat'),
  toyou('toyou'),
  carriage('carriage');

  const DeliveryConfigPlatform(this.value);
  final String value;

  String get label => switch (this) {
    hungerstation => 'HungerStation',
    jahez => 'Jahez',
    marsool => 'Marsool',
    keeta => 'Keeta',
    noonFood => 'Noon Food',
    ninja => 'Ninja',
    theChefz => 'The Chefz',
    talabat => 'Talabat',
    toyou => 'ToYou',
    carriage => 'Carriage',
  };

  Color get color => switch (this) {
    hungerstation => AppColors.primary,
    jahez => AppColors.error,
    marsool => AppColors.info,
    keeta => AppColors.success,
    noonFood => AppColors.warning,
    ninja => AppColors.purple,
    theChefz => AppColors.rose,
    talabat => AppColors.primary,
    toyou => AppColors.info,
    carriage => AppColors.success,
  };

  IconData get icon => switch (this) {
    hungerstation => Icons.restaurant,
    jahez => Icons.fastfood,
    marsool => Icons.delivery_dining,
    keeta => Icons.local_shipping,
    noonFood => Icons.lunch_dining,
    ninja => Icons.flash_on,
    theChefz => Icons.food_bank,
    talabat => Icons.shopping_bag,
    toyou => Icons.local_taxi,
    carriage => Icons.pedal_bike,
  };

  static DeliveryConfigPlatform fromValue(String value) {
    return DeliveryConfigPlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryConfigPlatform: $value'),
    );
  }

  static DeliveryConfigPlatform? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
