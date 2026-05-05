class LabelPrintStats {
  const LabelPrintStats({required this.jobsLast30Days, required this.productsLast30Days, required this.labelsLast30Days});

  factory LabelPrintStats.fromJson(Map<String, dynamic> json) {
    return LabelPrintStats(
      jobsLast30Days: (json['jobs_last_30_days'] as num).toInt(),
      productsLast30Days: (json['products_last_30_days'] as num).toInt(),
      labelsLast30Days: (json['labels_last_30_days'] as num).toInt(),
    );
  }

  factory LabelPrintStats.empty() => const LabelPrintStats(jobsLast30Days: 0, productsLast30Days: 0, labelsLast30Days: 0);

  final int jobsLast30Days;
  final int productsLast30Days;
  final int labelsLast30Days;

  Map<String, dynamic> toJson() => {
    'jobs_last_30_days': jobsLast30Days,
    'products_last_30_days': productsLast30Days,
    'labels_last_30_days': labelsLast30Days,
  };
}
