import 'package:wameedpos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:wameedpos/features/industry_bakery/models/production_schedule.dart';
import 'package:wameedpos/features/industry_bakery/models/custom_cake_order.dart';

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

  const BakeryLoaded({required this.recipes, required this.productionSchedules, required this.cakeOrders});
  final List<BakeryRecipe> recipes;
  final List<ProductionSchedule> productionSchedules;
  final List<CustomCakeOrder> cakeOrders;

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
  const BakeryError({required this.message});
  final String message;
}
