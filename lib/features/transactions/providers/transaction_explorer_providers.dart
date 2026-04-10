import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:thawani_pos/features/pos_terminal/models/payment.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';
import 'package:thawani_pos/features/transactions/providers/transaction_explorer_state.dart';

// ─────────────────────────────────────────────────────────────
// API Service for Transaction Explorer
// ─────────────────────────────────────────────────────────────

final transactionExplorerApiProvider = Provider<TransactionExplorerApiService>((ref) {
  return TransactionExplorerApiService(ref.watch(dioClientProvider));
});

class TransactionExplorerApiService {
  final Dio _dio;

  TransactionExplorerApiService(this._dio);

  Future<Map<String, dynamic>> getTransactionStats({String? branchId, String? dateFrom, String? dateTo, int? days}) async {
    final response = await _dio.get(
      '${ApiEndpoints.ownerDashboardFinancialSummary}',
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (days != null) 'days': days,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDashboardStats({int? days}) async {
    final response = await _dio.get(ApiEndpoints.ownerDashboardStats, queryParameters: {if (days != null) 'days': days});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHourlySales({String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.ownerDashboardHourlySales,
      queryParameters: {if (dateFrom != null) 'date_from': dateFrom, if (dateTo != null) 'date_to': dateTo},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSalesTrend({String? dateFrom, String? dateTo, int? days}) async {
    final response = await _dio.get(
      ApiEndpoints.ownerDashboardSalesTrend,
      queryParameters: {
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (days != null) 'days': days,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<List<Payment>> getTransactionPayments(String transactionId) async {
    final response = await _dio.get(ApiEndpoints.payments, queryParameters: {'transaction_id': transactionId});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data is List
        ? apiResponse.data as List
        : (apiResponse.data as Map<String, dynamic>)['data'] as List? ?? [];
    return list.map((j) => Payment.fromJson(j as Map<String, dynamic>)).toList();
  }
}

// ─────────────────────────────────────────────────────────────
// Transaction List Provider
// ─────────────────────────────────────────────────────────────

final transactionExplorerProvider = StateNotifierProvider<TransactionExplorerNotifier, TransactionExplorerState>((ref) {
  return TransactionExplorerNotifier(ref.watch(posTerminalApiServiceProvider));
});

class TransactionExplorerNotifier extends StateNotifier<TransactionExplorerState> {
  TransactionExplorerNotifier(this._api) : super(const TransactionExplorerInitial());

  final PosTerminalApiService _api;

  String? _typeFilter;
  String? _statusFilter;
  String? _searchQuery;
  String? _branchId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  Future<void> load({
    int page = 1,
    String? type,
    String? status,
    String? search,
    String? branchId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    if (type != null) _typeFilter = type;
    if (status != null) _statusFilter = status;
    if (search != null) _searchQuery = search;
    if (branchId != null) _branchId = branchId;
    if (dateFrom != null) _dateFrom = dateFrom;
    if (dateTo != null) _dateTo = dateTo;

    state = const TransactionExplorerLoading();
    try {
      final result = await _api.listTransactions(
        page: page,
        perPage: 25,
        type: _typeFilter,
        status: _statusFilter,
        search: _searchQuery?.isNotEmpty == true ? _searchQuery : null,
      );
      state = TransactionExplorerLoaded(
        transactions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        typeFilter: _typeFilter,
        statusFilter: _statusFilter,
        searchQuery: _searchQuery,
        branchId: _branchId,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      );
    } catch (e) {
      state = TransactionExplorerError(e.toString());
    }
  }

  Future<void> nextPage() async {
    if (state is! TransactionExplorerLoaded) return;
    final current = state as TransactionExplorerLoaded;
    if (!current.hasMore) return;
    await load(page: current.currentPage + 1);
  }

  Future<void> previousPage() async {
    if (state is! TransactionExplorerLoaded) return;
    final current = state as TransactionExplorerLoaded;
    if (current.currentPage <= 1) return;
    await load(page: current.currentPage - 1);
  }

  void setTypeFilter(String? type) {
    _typeFilter = type;
    load();
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    load();
  }

  void setSearch(String query) {
    _searchQuery = query;
    load();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
    load();
  }

  void setBranch(String? branchId) {
    _branchId = branchId;
    load();
  }

  void clearFilters() {
    _typeFilter = null;
    _statusFilter = null;
    _searchQuery = null;
    _branchId = null;
    _dateFrom = null;
    _dateTo = null;
    load();
  }
}

// ─────────────────────────────────────────────────────────────
// Transaction Detail Provider
// ─────────────────────────────────────────────────────────────

final transactionDetailProvider = StateNotifierProvider<TransactionDetailNotifier, TransactionDetailState>((ref) {
  return TransactionDetailNotifier(ref.watch(posTerminalApiServiceProvider), ref.watch(transactionExplorerApiProvider));
});

class TransactionDetailNotifier extends StateNotifier<TransactionDetailState> {
  TransactionDetailNotifier(this._posApi, this._explorerApi) : super(const TransactionDetailInitial());

  final PosTerminalApiService _posApi;
  final TransactionExplorerApiService _explorerApi;

  Future<void> load(String transactionId) async {
    state = const TransactionDetailLoading();
    try {
      final results = await Future.wait([
        _posApi.getTransaction(transactionId),
        _explorerApi.getTransactionPayments(transactionId),
      ]);
      state = TransactionDetailLoaded(transaction: results[0] as Transaction, payments: results[1] as List<Payment>);
    } catch (e) {
      state = TransactionDetailError(e.toString());
    }
  }

  Future<void> voidTransaction(String transactionId) async {
    try {
      await _posApi.voidTransaction(transactionId);
      await load(transactionId);
    } catch (e) {
      state = TransactionDetailError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Transaction Stats Provider
// ─────────────────────────────────────────────────────────────

final transactionStatsProvider = StateNotifierProvider<TransactionStatsNotifier, TransactionStatsState>((ref) {
  return TransactionStatsNotifier(ref.watch(transactionExplorerApiProvider));
});

class TransactionStatsNotifier extends StateNotifier<TransactionStatsState> {
  TransactionStatsNotifier(this._api) : super(const TransactionStatsInitial());

  final TransactionExplorerApiService _api;

  Future<void> load({String? branchId, DateTime? dateFrom, DateTime? dateTo, int? days}) async {
    state = const TransactionStatsLoading();
    try {
      final dfStr = dateFrom?.toIso8601String().split('T').first;
      final dtStr = dateTo?.toIso8601String().split('T').first;

      final results = await Future.wait([
        _api.getTransactionStats(branchId: branchId, dateFrom: dfStr, dateTo: dtStr, days: days),
        _api.getDashboardStats(days: days),
        _api.getSalesTrend(dateFrom: dfStr, dateTo: dtStr, days: days ?? 7),
      ]);

      final financial = results[0];
      final dashboard = results[1];
      final trend = results[2];

      // Parse payment method breakdown
      final paymentRaw = financial['payment_methods'] as Map<String, dynamic>? ?? {};
      final paymentBreakdown = paymentRaw.map((k, v) => MapEntry(k, _dbl(v)));

      // Parse hourly distribution
      final hourlyRaw = financial['hourly_sales'] as Map<String, dynamic>? ?? {};
      final hourly = hourlyRaw.map((k, v) => MapEntry(int.tryParse(k) ?? 0, (v as num?)?.toInt() ?? 0));

      // Parse daily trend
      final dailyRaw = trend['data'] as List? ?? trend['points'] as List? ?? [];
      final daily = dailyRaw.map((j) => DailyTrendPoint.fromJson(j as Map<String, dynamic>)).toList();

      state = TransactionStatsLoaded(
        totalSales: _dbl(financial['total_sales'] ?? dashboard['today_sales']),
        totalTransactions:
            (financial['total_transactions'] as num?)?.toInt() ?? (dashboard['today_transactions'] as num?)?.toInt() ?? 0,
        totalReturns: (financial['total_returns'] as num?)?.toInt() ?? 0,
        totalVoids: (financial['total_voids'] as num?)?.toInt() ?? 0,
        avgTransactionValue: _dbl(financial['avg_transaction_value'] ?? dashboard['avg_basket']),
        netRevenue: _dbl(financial['net_revenue'] ?? financial['total_sales']),
        totalTax: _dbl(financial['total_tax']),
        totalDiscount: _dbl(financial['total_discount']),
        totalTips: _dbl(financial['total_tips']),
        salesTrend: _dblOrNull(dashboard['sales_trend']),
        transactionsTrend: _dblOrNull(dashboard['transactions_trend']),
        avgBasketTrend: _dblOrNull(dashboard['basket_trend']),
        paymentMethodBreakdown: paymentBreakdown,
        hourlyDistribution: hourly,
        dailyTrend: daily,
        previousTotalSales: _dblOrNull(financial['previous_total_sales']),
        previousTotalTransactions: (financial['previous_total_transactions'] as num?)?.toInt(),
        previousAvgTransactionValue: _dblOrNull(financial['previous_avg_transaction_value']),
      );
    } catch (e) {
      state = TransactionStatsError(e.toString());
    }
  }

  double _dbl(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  double? _dblOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
