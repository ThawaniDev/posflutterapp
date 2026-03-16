import 'package:thawani_pos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:thawani_pos/features/industry_bakery/models/production_schedule.dart';
import 'package:thawani_pos/features/industry_bakery/models/custom_cake_order.dart';

sealed class BakeryState {
  const BakeryState();
}

class BakeryInitial extends BakeryState {
  const BakeryInitial();
}

class BakeryLoading extends BakeryState {
  const BakeryLoading();
}

class BakeryLoaded extends BakeryState {
  final List<BakeryRecipe> recipes;
  final List<ProductionSchedule> productionSchedules;
  final List<CustomCakeOrder> cakeOrders;

  const BakeryLoaded({required this.recipes, required this.productionSchedules, required this.cakeOrders});

  BakeryLoaded copyWith({
    List<BakeryRecipe>? recipes,
    List<ProductionSchedule>? productionSchedules,
    List<CustomCakeOrder>? cakeOrders,
  }) => BakeryLoaded(
    recipes: recipes ?? this.recipes,
    productionSchedules: productionSchedules ?? this.productionSchedules,
    cakeOrders: cakeOrders ?? this.cakeOrders,
  );
}

class BakeryError extends BakeryState {
  final String message;
  const BakeryError({required this.message});
}
