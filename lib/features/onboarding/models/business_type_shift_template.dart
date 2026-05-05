class BusinessTypeShiftTemplate {

  const BusinessTypeShiftTemplate({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    required this.startTime,
    required this.endTime,
    this.daysOfWeek,
    this.breakDurationMinutes,
    this.isDefault,
    this.sortOrder,
  });

  factory BusinessTypeShiftTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeShiftTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      daysOfWeek: json['days_of_week'] != null ? (json['days_of_week'] as List<dynamic>).map((e) => (e as num).toInt()).toList() : null,
      breakDurationMinutes: (json['break_duration_minutes'] as num?)?.toInt(),
      isDefault: json['is_default'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final String startTime;
  final String endTime;
  final List<int>? daysOfWeek;
  final int? breakDurationMinutes;
  final bool? isDefault;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'start_time': startTime,
      'end_time': endTime,
      'days_of_week': daysOfWeek,
      'break_duration_minutes': breakDurationMinutes,
      'is_default': isDefault,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeShiftTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    String? startTime,
    String? endTime,
    List<int>? daysOfWeek,
    int? breakDurationMinutes,
    bool? isDefault,
    int? sortOrder,
  }) {
    return BusinessTypeShiftTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      breakDurationMinutes: breakDurationMinutes ?? this.breakDurationMinutes,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeShiftTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeShiftTemplate(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, startTime: $startTime, endTime: $endTime, ...)';
}
