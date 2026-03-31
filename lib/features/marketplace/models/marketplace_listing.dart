class MarketplaceListing {
  final String id;
  final String name;
  final String? description;
  final String categoryId;
  final String? categoryName;
  final String status;
  final String pricingType;
  final double? price;
  final double? subscriptionPrice;
  final String? subscriptionInterval;
  final String? previewImageUrl;
  final List<String> screenshotUrls;
  final Map<String, dynamic> templateData;
  final double averageRating;
  final int reviewCount;
  final int downloadCount;
  final String? publishedBy;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MarketplaceListing({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.categoryName,
    required this.status,
    required this.pricingType,
    this.price,
    this.subscriptionPrice,
    this.subscriptionInterval,
    this.previewImageUrl,
    this.screenshotUrls = const [],
    this.templateData = const {},
    this.averageRating = 0,
    this.reviewCount = 0,
    this.downloadCount = 0,
    this.publishedBy,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isFree => pricingType == 'free';
  bool get isSubscription => pricingType == 'subscription';

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    return MarketplaceListing(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String?,
      status: json['status'] as String? ?? 'draft',
      pricingType: json['pricing_type'] as String? ?? 'free',
      price: (json['price'] as num?)?.toDouble(),
      subscriptionPrice: (json['subscription_price'] as num?)?.toDouble(),
      subscriptionInterval: json['subscription_interval'] as String?,
      previewImageUrl: json['preview_image_url'] as String?,
      screenshotUrls: (json['screenshot_urls'] as List?)?.cast<String>() ?? [],
      templateData: Map<String, dynamic>.from(json['template_data'] as Map? ?? {}),
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
      publishedBy: json['published_by'] as String?,
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_id': categoryId,
      'category_name': categoryName,
      'status': status,
      'pricing_type': pricingType,
      'price': price,
      'subscription_price': subscriptionPrice,
      'subscription_interval': subscriptionInterval,
      'preview_image_url': previewImageUrl,
      'screenshot_urls': screenshotUrls,
      'template_data': templateData,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'download_count': downloadCount,
      'published_by': publishedBy,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is MarketplaceListing && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
