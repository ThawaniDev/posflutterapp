class MarketplaceListing {

  const MarketplaceListing({
    required this.id,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.shortDescription,
    this.shortDescriptionAr,
    this.categoryId,
    this.categoryName,
    this.status = 'draft',
    this.pricingType = 'free',
    this.priceAmount,
    this.priceCurrency,
    this.subscriptionInterval,
    this.previewImages = const [],
    this.demoVideoUrl,
    this.tags = const [],
    this.version,
    this.averageRating = 0,
    this.reviewCount = 0,
    this.downloadCount = 0,
    this.isFeatured = false,
    this.isVerified = false,
    this.publisherName,
    this.publisherAvatarUrl,
    this.posLayoutTemplateId,
    this.themeId,
    this.syncVersion,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    // Return full demo data for now for all fei
    // return
    // Extract category name from nested relation or flat field
    final category = json['category'] as Map<String, dynamic>?;
    final categoryName = json['category_name'] as String? ?? category?['name'] as String?;

    return MarketplaceListing(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      shortDescription: json['short_description'] as String?,
      shortDescriptionAr: json['short_description_ar'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: categoryName,
      status: json['status'] as String? ?? 'draft',
      pricingType: json['pricing_type'] as String? ?? 'free',
      priceAmount: json['price_amount'] != null ? double.tryParse(json['price_amount'].toString()) : null,
      priceCurrency: json['price_currency'] as String?,
      subscriptionInterval: json['subscription_interval'] as String?,
      previewImages: (json['preview_images'] as List?)?.cast<String>() ?? [],
      demoVideoUrl: json['demo_video_url'] as String?,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      version: json['version'] as String?,
      averageRating: json['average_rating'] != null ? double.tryParse(json['average_rating'].toString()) ?? 0 : 0,
      reviewCount: json['review_count'] != null ? int.tryParse(json['review_count'].toString()) ?? 0 : 0,
      downloadCount: json['download_count'] != null ? int.tryParse(json['download_count'].toString()) ?? 0 : 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      publisherName: json['publisher_name'] as String?,
      publisherAvatarUrl: json['publisher_avatar_url'] as String?,
      posLayoutTemplateId: json['pos_layout_template_id'] as String?,
      themeId: json['theme_id'] as String?,
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      publishedAt: json['published_at'] != null ? DateTime.tryParse(json['published_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
  final String id;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final String? shortDescription;
  final String? shortDescriptionAr;
  final String? categoryId;
  final String? categoryName;
  final String status;
  final String pricingType;
  final double? priceAmount;
  final String? priceCurrency;
  final String? subscriptionInterval;
  final List<String> previewImages;
  final String? demoVideoUrl;
  final List<String> tags;
  final String? version;
  final double averageRating;
  final int reviewCount;
  final int downloadCount;
  final bool isFeatured;
  final bool isVerified;
  final String? publisherName;
  final String? publisherAvatarUrl;
  final String? posLayoutTemplateId;
  final String? themeId;
  final int? syncVersion;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isFree => pricingType == 'free';
  bool get isSubscription => pricingType == 'subscription';

  /// First preview image URL, or null.
  String? get previewImageUrl => previewImages.isNotEmpty ? previewImages.first : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'description': description,
      'description_ar': descriptionAr,
      'short_description': shortDescription,
      'short_description_ar': shortDescriptionAr,
      'category_id': categoryId,
      'status': status,
      'pricing_type': pricingType,
      'price_amount': priceAmount,
      'price_currency': priceCurrency,
      'subscription_interval': subscriptionInterval,
      'preview_images': previewImages,
      'demo_video_url': demoVideoUrl,
      'tags': tags,
      'version': version,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'download_count': downloadCount,
      'is_featured': isFeatured,
      'is_verified': isVerified,
      'publisher_name': publisherName,
      'publisher_avatar_url': publisherAvatarUrl,
      'pos_layout_template_id': posLayoutTemplateId,
      'theme_id': themeId,
      'sync_version': syncVersion,
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
