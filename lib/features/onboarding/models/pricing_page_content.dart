/// Parsed plan object embedded in the pricing API response.
class PricingPlan {
  const PricingPlan({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.monthlyPrice,
    this.annualPrice,
    this.trialDays,
    required this.isHighlighted,
  });

  factory PricingPlan.fromJson(Map<String, dynamic> json) {
    return PricingPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      monthlyPrice: (json['monthly_price'] as num).toDouble(),
      annualPrice: (json['annual_price'] as num?)?.toDouble(),
      trialDays: (json['trial_days'] as num?)?.toInt(),
      isHighlighted: json['is_highlighted'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final double monthlyPrice;
  final double? annualPrice;
  final int? trialDays;
  final bool isHighlighted;
}

class PricingPageContent {
  const PricingPageContent({
    required this.id,
    required this.plan,
    required this.featureBulletList,
    required this.featureCategories,
    required this.faq,
    required this.testimonials,
    required this.comparisonHighlights,
    this.heroTitle,
    this.heroTitleAr,
    this.heroSubtitle,
    this.heroSubtitleAr,
    this.highlightBadge,
    this.highlightBadgeAr,
    this.highlightColor,
    this.isHighlighted,
    this.ctaLabel,
    this.ctaLabelAr,
    this.ctaSecondaryLabel,
    this.ctaSecondaryLabelAr,
    this.ctaUrl,
    this.pricePrefix,
    this.pricePrefixAr,
    this.priceSuffix,
    this.priceSuffixAr,
    this.annualDiscountLabel,
    this.annualDiscountLabelAr,
    this.trialLabel,
    this.trialLabelAr,
    this.moneyBackDays,
    this.metaTitle,
    this.metaTitleAr,
    this.metaDescription,
    this.metaDescriptionAr,
    this.colorTheme,
    this.cardIcon,
    this.cardImageUrl,
    this.isPublished,
    this.sortOrder,
    this.updatedAt,
  });

  factory PricingPageContent.fromJson(Map<String, dynamic> json) {
    return PricingPageContent(
      id: json['id'] as String,
      plan: PricingPlan.fromJson(json['plan'] as Map<String, dynamic>),
      // API returns arrays — cast properly
      featureBulletList: (json['feature_bullet_list'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      featureCategories:
          (json['feature_categories'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
      faq: (json['faq'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
      testimonials: (json['testimonials'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
      comparisonHighlights:
          (json['comparison_highlights'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
      heroTitle: json['hero_title'] as String?,
      heroTitleAr: json['hero_title_ar'] as String?,
      heroSubtitle: json['hero_subtitle'] as String?,
      heroSubtitleAr: json['hero_subtitle_ar'] as String?,
      highlightBadge: json['highlight_badge'] as String?,
      highlightBadgeAr: json['highlight_badge_ar'] as String?,
      highlightColor: json['highlight_color'] as String?,
      isHighlighted: json['is_highlighted'] as bool?,
      ctaLabel: json['cta_label'] as String?,
      ctaLabelAr: json['cta_label_ar'] as String?,
      ctaSecondaryLabel: json['cta_secondary_label'] as String?,
      ctaSecondaryLabelAr: json['cta_secondary_label_ar'] as String?,
      ctaUrl: json['cta_url'] as String?,
      pricePrefix: json['price_prefix'] as String?,
      pricePrefixAr: json['price_prefix_ar'] as String?,
      priceSuffix: json['price_suffix'] as String?,
      priceSuffixAr: json['price_suffix_ar'] as String?,
      annualDiscountLabel: json['annual_discount_label'] as String?,
      annualDiscountLabelAr: json['annual_discount_label_ar'] as String?,
      trialLabel: json['trial_label'] as String?,
      trialLabelAr: json['trial_label_ar'] as String?,
      moneyBackDays: (json['money_back_days'] as num?)?.toInt(),
      metaTitle: json['meta_title'] as String?,
      metaTitleAr: json['meta_title_ar'] as String?,
      metaDescription: json['meta_description'] as String?,
      metaDescriptionAr: json['meta_description_ar'] as String?,
      colorTheme: json['color_theme'] as String?,
      cardIcon: json['card_icon'] as String?,
      cardImageUrl: json['card_image_url'] as String?,
      isPublished: json['is_published'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  final String id;
  final PricingPlan plan;
  final List<String> featureBulletList;
  final List<Map<String, dynamic>> featureCategories;
  final List<Map<String, dynamic>> faq;
  final List<Map<String, dynamic>> testimonials;
  final List<Map<String, dynamic>> comparisonHighlights;
  final String? heroTitle;
  final String? heroTitleAr;
  final String? heroSubtitle;
  final String? heroSubtitleAr;
  final String? highlightBadge;
  final String? highlightBadgeAr;
  final String? highlightColor;
  final bool? isHighlighted;
  final String? ctaLabel;
  final String? ctaLabelAr;
  final String? ctaSecondaryLabel;
  final String? ctaSecondaryLabelAr;
  final String? ctaUrl;
  final String? pricePrefix;
  final String? pricePrefixAr;
  final String? priceSuffix;
  final String? priceSuffixAr;
  final String? annualDiscountLabel;
  final String? annualDiscountLabelAr;
  final String? trialLabel;
  final String? trialLabelAr;
  final int? moneyBackDays;
  final String? metaTitle;
  final String? metaTitleAr;
  final String? metaDescription;
  final String? metaDescriptionAr;
  final String? colorTheme;
  final String? cardIcon;
  final String? cardImageUrl;
  final bool? isPublished;
  final int? sortOrder;
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PricingPageContent && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PricingPageContent(id: $id, plan: ${plan.slug}, heroTitle: $heroTitle)';
}
