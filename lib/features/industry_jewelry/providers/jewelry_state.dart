import 'package:wameedpos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:wameedpos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:wameedpos/features/industry_jewelry/models/buyback_transaction.dart';

sealed class JewelryState {
  const JewelryState();
}

class JewelryInitial extends JewelryState {
  const JewelryInitial();
}

class JewelryLoading extends JewelryState {
  const JewelryLoading();
}

class JewelryLoaded extends JewelryState {

  const JewelryLoaded({required this.metalRates, required this.productDetails, required this.buybacks});
  final List<DailyMetalRate> metalRates;
  final List<JewelryProductDetail> productDetails;
  final List<BuybackTransaction> buybacks;

  JewelryLoaded copyWith({
    List<DailyMetalRate>? metalRates,
    List<JewelryProductDetail>? productDetails,
    List<BuybackTransaction>? buybacks,
  }) => JewelryLoaded(
    metalRates: metalRates ?? this.metalRates,
    productDetails: productDetails ?? this.productDetails,
    buybacks: buybacks ?? this.buybacks,
  );
}

class JewelryError extends JewelryState {
  const JewelryError({required this.message});
  final String message;
}
