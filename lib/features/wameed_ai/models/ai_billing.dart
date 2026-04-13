class AIBillingSummary {
  final AIBillingConfig config;
  final AIBillingCurrentMonth currentMonth;
  final List<AIBillingInvoicePreview> recentInvoices;

  const AIBillingSummary({required this.config, required this.currentMonth, this.recentInvoices = const []});

  factory AIBillingSummary.fromJson(Map<String, dynamic> json) {
    return AIBillingSummary(
      config: AIBillingConfig.fromJson(json['config'] as Map<String, dynamic>),
      currentMonth: AIBillingCurrentMonth.fromJson(json['current_month'] as Map<String, dynamic>),
      recentInvoices: json['recent_invoices'] != null
          ? (json['recent_invoices'] as List).map((e) => AIBillingInvoicePreview.fromJson(e as Map<String, dynamic>)).toList()
          : const [],
    );
  }
}

class AIBillingConfig {
  final bool isAiEnabled;
  final double monthlyLimitUsd;
  final double effectiveLimitUsd;
  final double marginPercentage;
  final String? disabledReason;
  final String? disabledAt;

  const AIBillingConfig({
    this.isAiEnabled = true,
    this.monthlyLimitUsd = 0,
    this.effectiveLimitUsd = 0,
    this.marginPercentage = 20,
    this.disabledReason,
    this.disabledAt,
  });

  factory AIBillingConfig.fromJson(Map<String, dynamic> json) {
    return AIBillingConfig(
      isAiEnabled: json['is_ai_enabled'] as bool? ?? true,
      monthlyLimitUsd: (json['monthly_limit_usd'] as num?)?.toDouble() ?? 0,
      effectiveLimitUsd: (json['effective_limit_usd'] as num?)?.toDouble() ?? 0,
      marginPercentage: (json['margin_percentage'] as num?)?.toDouble() ?? 20,
      disabledReason: json['disabled_reason'] as String?,
      disabledAt: json['disabled_at'] as String?,
    );
  }
}

class AIBillingCurrentMonth {
  final int year;
  final int month;
  final int totalRequests;
  final int totalTokens;
  final double rawCostUsd;
  final double marginPercentage;
  final double marginAmountUsd;
  final double billedCostUsd;
  final double limitUsd;
  final double limitPercentage;
  final List<AIBillingFeatureUsage> byFeature;

  const AIBillingCurrentMonth({
    required this.year,
    required this.month,
    this.totalRequests = 0,
    this.totalTokens = 0,
    this.rawCostUsd = 0,
    this.marginPercentage = 20,
    this.marginAmountUsd = 0,
    this.billedCostUsd = 0,
    this.limitUsd = 0,
    this.limitPercentage = 0,
    this.byFeature = const [],
  });

  factory AIBillingCurrentMonth.fromJson(Map<String, dynamic> json) {
    return AIBillingCurrentMonth(
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
      month: (json['month'] as num?)?.toInt() ?? DateTime.now().month,
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
      rawCostUsd: (json['raw_cost_usd'] as num?)?.toDouble() ?? 0,
      marginPercentage: (json['margin_percentage'] as num?)?.toDouble() ?? 20,
      marginAmountUsd: (json['margin_amount_usd'] as num?)?.toDouble() ?? 0,
      billedCostUsd: (json['billed_cost_usd'] as num?)?.toDouble() ?? 0,
      limitUsd: (json['limit_usd'] as num?)?.toDouble() ?? 0,
      limitPercentage: (json['limit_percentage'] as num?)?.toDouble() ?? 0,
      byFeature: json['by_feature'] != null
          ? (json['by_feature'] as List).map((e) => AIBillingFeatureUsage.fromJson(e as Map<String, dynamic>)).toList()
          : const [],
    );
  }
}

class AIBillingFeatureUsage {
  final String featureSlug;
  final int requestCount;
  final int totalTokens;
  final double rawCostUsd;
  final double billedCostUsd;

  const AIBillingFeatureUsage({
    required this.featureSlug,
    this.requestCount = 0,
    this.totalTokens = 0,
    this.rawCostUsd = 0,
    this.billedCostUsd = 0,
  });

  factory AIBillingFeatureUsage.fromJson(Map<String, dynamic> json) {
    return AIBillingFeatureUsage(
      featureSlug: json['feature_slug'] as String,
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
      rawCostUsd: (json['raw_cost_usd'] as num?)?.toDouble() ?? 0,
      billedCostUsd: (json['billed_cost_usd'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AIBillingInvoicePreview {
  final String id;
  final String invoiceNumber;
  final int year;
  final int month;
  final double billedAmountUsd;
  final String status;
  final String dueDate;
  final String? paidAt;

  const AIBillingInvoicePreview({
    required this.id,
    required this.invoiceNumber,
    required this.year,
    required this.month,
    required this.billedAmountUsd,
    required this.status,
    required this.dueDate,
    this.paidAt,
  });

  factory AIBillingInvoicePreview.fromJson(Map<String, dynamic> json) {
    return AIBillingInvoicePreview(
      id: json['id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      billedAmountUsd: (json['billed_amount_usd'] as num).toDouble(),
      status: json['status'] as String,
      dueDate: json['due_date'] as String,
      paidAt: json['paid_at'] as String?,
    );
  }
}

class AIBillingInvoiceDetail {
  final String id;
  final String invoiceNumber;
  final int year;
  final int month;
  final String periodStart;
  final String periodEnd;
  final int totalRequests;
  final int totalTokens;
  final double rawCostUsd;
  final double marginPercentage;
  final double marginAmountUsd;
  final double billedAmountUsd;
  final String status;
  final String dueDate;
  final String? paidAt;
  final String? paymentReference;
  final List<AIBillingInvoiceItem> items;
  final List<AIBillingPayment> payments;

  const AIBillingInvoiceDetail({
    required this.id,
    required this.invoiceNumber,
    required this.year,
    required this.month,
    required this.periodStart,
    required this.periodEnd,
    this.totalRequests = 0,
    this.totalTokens = 0,
    this.rawCostUsd = 0,
    this.marginPercentage = 20,
    this.marginAmountUsd = 0,
    this.billedAmountUsd = 0,
    this.status = 'pending',
    required this.dueDate,
    this.paidAt,
    this.paymentReference,
    this.items = const [],
    this.payments = const [],
  });

  factory AIBillingInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return AIBillingInvoiceDetail(
      id: json['id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      periodStart: json['period_start'] as String,
      periodEnd: json['period_end'] as String,
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
      rawCostUsd: (json['raw_cost_usd'] as num?)?.toDouble() ?? 0,
      marginPercentage: (json['margin_percentage'] as num?)?.toDouble() ?? 20,
      marginAmountUsd: (json['margin_amount_usd'] as num?)?.toDouble() ?? 0,
      billedAmountUsd: (json['billed_amount_usd'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'pending',
      dueDate: json['due_date'] as String,
      paidAt: json['paid_at'] as String?,
      paymentReference: json['payment_reference'] as String?,
      items: json['items'] != null
          ? (json['items'] as List).map((e) => AIBillingInvoiceItem.fromJson(e as Map<String, dynamic>)).toList()
          : const [],
      payments: json['payments'] != null
          ? (json['payments'] as List).map((e) => AIBillingPayment.fromJson(e as Map<String, dynamic>)).toList()
          : const [],
    );
  }
}

class AIBillingInvoiceItem {
  final String featureSlug;
  final String featureName;
  final String featureNameAr;
  final int requestCount;
  final int totalTokens;
  final double rawCostUsd;
  final double billedCostUsd;

  const AIBillingInvoiceItem({
    required this.featureSlug,
    required this.featureName,
    required this.featureNameAr,
    this.requestCount = 0,
    this.totalTokens = 0,
    this.rawCostUsd = 0,
    this.billedCostUsd = 0,
  });

  factory AIBillingInvoiceItem.fromJson(Map<String, dynamic> json) {
    return AIBillingInvoiceItem(
      featureSlug: json['feature_slug'] as String,
      featureName: json['feature_name'] as String? ?? '',
      featureNameAr: json['feature_name_ar'] as String? ?? '',
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
      rawCostUsd: (json['raw_cost_usd'] as num?)?.toDouble() ?? 0,
      billedCostUsd: (json['billed_cost_usd'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AIBillingPayment {
  final String id;
  final double amountUsd;
  final String paymentMethod;
  final String? reference;
  final String? notes;
  final String createdAt;

  const AIBillingPayment({
    required this.id,
    required this.amountUsd,
    required this.paymentMethod,
    this.reference,
    this.notes,
    required this.createdAt,
  });

  factory AIBillingPayment.fromJson(Map<String, dynamic> json) {
    return AIBillingPayment(
      id: json['id'] as String,
      amountUsd: (json['amount_usd'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
