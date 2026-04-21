/// Represents a provider option available at POS checkout.
class CheckoutProviderOption {

  const CheckoutProviderOption({
    required this.provider,
    required this.name,
    this.nameAr,
    this.logoUrl,
    this.description,
    this.descriptionAr,
    this.installmentCounts = const [],
    this.installmentAmount = 0,
  });

  factory CheckoutProviderOption.fromJson(Map<String, dynamic> json) {
    return CheckoutProviderOption(
      provider: json['provider'] as String,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      installmentCounts:
          (json['installment_counts'] as List<dynamic>?)?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).toList() ??
          [],
      installmentAmount: double.tryParse(json['installment_amount']?.toString() ?? '0') ?? 0.0,
    );
  }
  final String provider;
  final String name;
  final String? nameAr;
  final String? logoUrl;
  final String? description;
  final String? descriptionAr;
  final List<int> installmentCounts;
  final double installmentAmount;
}
