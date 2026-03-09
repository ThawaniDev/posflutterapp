class LabelTemplateBusinessType {
  final String labelLayoutTemplateId;
  final String businessTypeId;

  const LabelTemplateBusinessType({
    required this.labelLayoutTemplateId,
    required this.businessTypeId,
  });

  factory LabelTemplateBusinessType.fromJson(Map<String, dynamic> json) {
    return LabelTemplateBusinessType(
      labelLayoutTemplateId: json['label_layout_template_id'] as String,
      businessTypeId: json['business_type_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label_layout_template_id': labelLayoutTemplateId,
      'business_type_id': businessTypeId,
    };
  }

  LabelTemplateBusinessType copyWith({
    String? labelLayoutTemplateId,
    String? businessTypeId,
  }) {
    return LabelTemplateBusinessType(
      labelLayoutTemplateId: labelLayoutTemplateId ?? this.labelLayoutTemplateId,
      businessTypeId: businessTypeId ?? this.businessTypeId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelTemplateBusinessType && other.labelLayoutTemplateId == labelLayoutTemplateId && other.businessTypeId == businessTypeId;

  @override
  int get hashCode => labelLayoutTemplateId.hashCode ^ businessTypeId.hashCode;

  @override
  String toString() => 'LabelTemplateBusinessType(labelLayoutTemplateId: $labelLayoutTemplateId, businessTypeId: $businessTypeId)';
}
