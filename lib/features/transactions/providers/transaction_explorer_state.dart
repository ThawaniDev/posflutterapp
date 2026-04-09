import 'package:thawani_pos/features/pos_terminal/models/payment.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';

// ─────────────────────────────────────────────────────────────
// Transaction Explorer States
// ─────────────────────────────────────────────────────────────

sealed class TransactionExplorerState {
  const TransactionExplorerState();
}

class TransactionExplorerInitial extends TransactionExplorerState {
  const TransactionExplorerInitial();
}

class TransactionExplorerLoading extends TransactionExplorerState {
  const TransactionExplorerLoading();
}

class TransactionExplorerLoaded extends TransactionExplorerState {
  const TransactionExplorerLoaded({
    required this.transactions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.typeFilter,
    this.statusFilter,
    this.searchQuery,
    this.branchId,
    this.dateFrom,
    this.dateTo,
  });

  final List<Transaction> transactions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? typeFilter;
  final String? statusFilter;
  final String? searchQuery;
  final String? branchId;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  bool get hasMore => currentPage < lastPage;
}

class TransactionExplorerError extends TransactionExplorerState {
  const TransactionExplorerError(this.message);
  final String message;
}

// ─────────────────────────────────────────────────────────────
// Transaction Detail States
// ─────────────────────────────────────────────────────────────

sealed class TransactionDetailState {
  const TransactionDetailState();
}

class TransactionDetailInitial extends TransactionDetailState {
  const TransactionDetailInitial();
}

class TransactionDetailLoading extends TransactionDetailState {
  const TransactionDetailLoading();
}

class TransactionDetailLoaded extends TransactionDetailState {
  const TransactionDetailLoaded({required this.transaction, this.payments});

  final Transaction transaction;
  final List<Payment>? payments;
}

class TransactionDetailError extends TransactionDetailState {
  const TransactionDetailError(this.message);
  final String message;
}

// ─────────────────────────────────────────────────────────────
// Transaction Stats States
// ─────────────────────────────────────────────────────────────

sealed class TransactionStatsState {
  const TransactionStatsState();
}

class TransactionStatsInitial extends TransactionStatsState {
  const TransactionStatsInitial();
}

class TransactionStatsLoading extends TransactionStatsState {
  const TransactionStatsLoading();
}

class TransactionStatsLoaded extends TransactionStatsState {
  const TransactionStatsLoaded({
    required this.totalSales,
    required this.totalTransactions,
    required this.totalReturns,
    required this.totalVoids,
    required this.avgTransactionValue,
    required this.netRevenue,
    required this.totalTax,
    required this.totalDiscount,
    required this.totalTips,
    this.salesTrend,
    this.transactionsTrend,
    this.avgBasketTrend,
    required this.paymentMethodBreakdown,
    required this.hourlyDistribution,
    required this.dailyTrend,
    this.previousTotalSales,
    this.previousTotalTransactions,
    this.previousAvgTransactionValue,
  });

  final double totalSales;
  final int totalTransactions;
  final int totalReturns;
  final int totalVoids;
  final double avgTransactionValue;
  final double netRevenue;
  final double totalTax;
  final double totalDiscount;
  final double totalTips;
  final double? salesTrend;
  final double? transactionsTrend;
  final double? avgBasketTrend;
  final Map<String, double> paymentMethodBreakdown;
  final Map<int, int> hourlyDistribution;
  final List<DailyTrendPoint> dailyTrend;
  final double? previousTotalSales;
  final int? previousTotalTransactions;
  final double? previousAvgTransactionValue;

  double get salesChangePercent {
    if (previousTotalSales == null || previousTotalSales == 0) return 0;
    return ((totalSales - previousTotalSales!) / previousTotalSales!) * 100;
  }

  double get transactionsChangePercent {
    if (previousTotalTransactions == null || previousTotalTransactions == 0) return 0;
    return ((totalTransactions - previousTotalTransactions!) / previousTotalTransactions!) * 100;
  }

  double get avgBasketChangePercent {
    if (previousAvgTransactionValue == null || previousAvgTransactionValue == 0) return 0;
    return ((avgTransactionValue - previousAvgTransactionValue!) / previousAvgTransactionValue!) * 100;
  }
}

class TransactionStatsError extends TransactionStatsState {
  const TransactionStatsError(this.message);
  final String message;
}

// ─── Helper Models ──────────────────────────────────────────

class DailyTrendPoint {
  const DailyTrendPoint({required this.date, required this.sales, required this.count});

  final DateTime date;
  final double sales;
  final int count;

  factory DailyTrendPoint.fromJson(Map<String, dynamic> json) {
    return DailyTrendPoint(
      date: DateTime.parse(json['date'] as String),
      sales: double.tryParse(json['sales'].toString()) ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
