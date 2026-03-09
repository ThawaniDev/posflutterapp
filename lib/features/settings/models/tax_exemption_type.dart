class TaxExemptionType {
  final String id;
  final String code;
  final String name;
  final String nameAr;
  final String? requiredDocuments;
  final bool? isActive;

  const TaxExemptionType({
    required this.id,
    required this.code,
    required this.name,
    required this.nameAr,
    this.requiredDocuments,
    this.isActive,
  });

  factory TaxExemptionType.fromJson(Map<String, dynamic> json) {
    return TaxExemptionType(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      requiredDocuments: json['required_documents'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_ar': nameAr,
      'required_documents': requiredDocuments,
      'is_active': isActive,
    };
  }

  TaxExemptionType copyWith({
    String? id,
    String? code,
    String? name,
    String? nameAr,
    String? requiredDocuments,
    bool? isActive,
  }) {
    return TaxExemptionType(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxExemptionType && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TaxExemptionType(id: $id, code: $code, name: $name, nameAr: $nameAr, requiredDocuments: $requiredDocuments, isActive: $isActive)';
}
