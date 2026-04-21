class PredefinedProductImage {

  const PredefinedProductImage({required this.id, required this.imageUrl, this.sortOrder});

  factory PredefinedProductImage.fromJson(Map<String, dynamic> json) {
    return PredefinedProductImage(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String imageUrl;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {'id': id, 'image_url': imageUrl, 'sort_order': sortOrder};
  }
}
