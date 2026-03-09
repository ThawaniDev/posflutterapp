class SignageTemplateBusinessType {
  final String signageTemplateId;
  final String businessTypeId;

  const SignageTemplateBusinessType({
    required this.signageTemplateId,
    required this.businessTypeId,
  });

  factory SignageTemplateBusinessType.fromJson(Map<String, dynamic> json) {
    return SignageTemplateBusinessType(
      signageTemplateId: json['signage_template_id'] as String,
      businessTypeId: json['business_type_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signage_template_id': signageTemplateId,
      'business_type_id': businessTypeId,
    };
  }

  SignageTemplateBusinessType copyWith({
    String? signageTemplateId,
    String? businessTypeId,
  }) {
    return SignageTemplateBusinessType(
      signageTemplateId: signageTemplateId ?? this.signageTemplateId,
      businessTypeId: businessTypeId ?? this.businessTypeId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignageTemplateBusinessType && other.signageTemplateId == signageTemplateId && other.businessTypeId == businessTypeId;

  @override
  int get hashCode => signageTemplateId.hashCode ^ businessTypeId.hashCode;

  @override
  String toString() => 'SignageTemplateBusinessType(signageTemplateId: $signageTemplateId, businessTypeId: $businessTypeId)';
}
