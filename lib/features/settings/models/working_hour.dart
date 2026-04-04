/// Single day entry in the store working-hours schedule.
class WorkingHour {
  final String id;
  final String? storeId;
  final int dayOfWeek; // 0=Sunday … 6=Saturday
  final bool isOpen;
  final String? openTime; // "HH:mm:ss"
  final String? closeTime;
  final String? breakStart;
  final String? breakEnd;

  const WorkingHour({
    required this.id,
    this.storeId,
    required this.dayOfWeek,
    this.isOpen = true,
    this.openTime,
    this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      id: json['id'] as String,
      storeId: json['store_id'] as String?,
      dayOfWeek: json['day_of_week'] as int,
      isOpen: json['is_open'] as bool? ?? true,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      breakStart: json['break_start'] as String?,
      breakEnd: json['break_end'] as String?,
    );
  }

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

  WorkingHour copyWith({bool? isOpen, String? openTime, String? closeTime, String? breakStart, String? breakEnd}) {
    return WorkingHour(
      id: id,
      storeId: storeId,
      dayOfWeek: dayOfWeek,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }

  static const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  static const dayNamesAr = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

  String get dayName => dayNames[dayOfWeek];
  String get dayNameAr => dayNamesAr[dayOfWeek];
}
