class StoreWorkingHour {

  const StoreWorkingHour({
    required this.id,
    required this.dayOfWeek,
    required this.dayName,
    this.isOpen = true,
    this.openTime,
    this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  factory StoreWorkingHour.fromJson(Map<String, dynamic> json) {
    return StoreWorkingHour(
      id: json['id'] as String,
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      dayName: json['day_name'] as String? ?? dayNames[(json['day_of_week'] as num).toInt()],
      isOpen: json['is_open'] as bool? ?? true,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      breakStart: json['break_start'] as String?,
      breakEnd: json['break_end'] as String?,
    );
  }
  final String id;
  final int dayOfWeek;
  final String dayName;
  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final String? breakStart;
  final String? breakEnd;

  static const List<String> dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  static const List<String> dayNamesAr = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
      'break_start': breakStart,
      'break_end': breakEnd,
    };
  }

  StoreWorkingHour copyWith({
    String? id,
    int? dayOfWeek,
    String? dayName,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    String? breakStart,
    String? breakEnd,
  }) {
    return StoreWorkingHour(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayName: dayName ?? this.dayName,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreWorkingHour && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
