import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:wameedpos/features/pos_terminal/models/payment.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';
import 'package:wameedpos/features/transactions/providers/transaction_explorer_state.dart';

// ─────────────────────────────────────────────────────────────
// API Service for Transaction Explorer
// ─────────────────────────────────────────────────────────────

final transactionExplorerApiProvider = Provider<TransactionExplorerApiService>((ref) {
  return TransactionExplorerApiService(ref.watch(dioClientProvider));
});

class TransactionExplorerApiService {

  TransactionExplorerApiService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> getTransactionStats({String? branchId, String? dateFrom, String? dateTo, int? days}) async {
    final response = await _dio.get(
      ApiEndpoints.ownerDashboardFinancialSummary,
      queryParameters: {
        'branch_id': ?branchId,
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
        'days': ?days,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDashboardStats({int? days}) async {
    final response = await _dio.get(ApiEndpoints.ownerDashboardStats, queryParameters: {'days': ?days});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getHourlySales({String? date}) async {
    final response = await _dio.get(ApiEndpoints.ownerDashboardHourlySales, queryParameters: {'date': ?date});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data is List ? apiResponse.data as List : [];
  }

  Future<Map<String, dynamic>> getSalesTrend({String? dateFrom, String? dateTo, int? days}) async {
    final response = await _dio.get(
      ApiEndpoints.ownerDashboardSalesTrend,
      queryParameters: {
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
        'days': ?days,
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

  Future<void> voidTransaction(String transactionId, {required String reason, String? approvalToken}) async {
    try {
      await _posApi.voidTransaction(transactionId, reason: reason, approvalToken: approvalToken);
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
        _api.getHourlySales(date: dfStr),
      ]);

      final financial = results[0] as Map<String, dynamic>;
      final dashboard = results[1] as Map<String, dynamic>;
      final trend = results[2] as Map<String, dynamic>;
      final hourlyRaw = results[3] as List;

      // financial-summary: revenue is nested { total, net, cost, tax, discounts, refunds }
      final revenue = financial['revenue'] as Map<String, dynamic>? ?? {};

      // Parse payment method breakdown from payments array [{method, count, total}]
      final paymentsList = financial['payments'] as List? ?? [];
      final paymentBreakdown = <String, double>{};
      for (final p in paymentsList) {
        final m = p as Map<String, dynamic>;
        paymentBreakdown[m['method'] as String? ?? 'unknown'] = _dbl(m['total']);
      }

      // Calculate total transactions from daily data
      final dailyFinancial = financial['daily'] as List? ?? [];
      int totalTransactionsFromDaily = 0;
      for (final d in dailyFinancial) {
        totalTransactionsFromDaily += ((d as Map<String, dynamic>)['orders'] as num?)?.toInt() ?? 0;
      }

      // Dashboard stats: each stat is { value, change }
      final dashTodaySales = dashboard['today_sales'] as Map<String, dynamic>? ?? {};
      final dashTransactions = dashboard['transactions'] as Map<String, dynamic>? ?? {};
      final dashAvgBasket = dashboard['avg_basket'] as Map<String, dynamic>? ?? {};

      // Parse daily trend from sales-trend endpoint: { current: [{date, revenue, orders}], summary: {...} }
      final trendCurrent = trend['current'] as List? ?? [];
      final trendSummary = trend['summary'] as Map<String, dynamic>? ?? {};
      final daily = trendCurrent.map((j) {
        final m = j as Map<String, dynamic>;
        return DailyTrendPoint(
          date: DateTime.parse(m['date'] as String),
          sales: _dbl(m['revenue']),
          count: (m['orders'] as num?)?.toInt() ?? 0,
        );
      }).toList();

      // Parse hourly distribution from hourlySales endpoint: [{hour, transaction_count, revenue}]
      final hourlyDistribution = <int, int>{};
      for (final h in hourlyRaw) {
        final m = h as Map<String, dynamic>;
        hourlyDistribution[(m['hour'] as num).toInt()] = (m['transaction_count'] as num?)?.toInt() ?? 0;
      }

      state = TransactionStatsLoaded(
        totalSales: _dbl(revenue['total']) > 0 ? _dbl(revenue['total']) : _dbl(dashTodaySales['value']),
        totalTransactions: totalTransactionsFromDaily > 0
            ? totalTransactionsFromDaily
            : (dashTransactions['value'] as num?)?.toInt() ?? 0,
        totalReturns: 0, // Not directly in these endpoints
        totalVoids: 0, // Not directly in these endpoints
        avgTransactionValue: totalTransactionsFromDaily > 0
            ? _dbl(revenue['total']) / totalTransactionsFromDaily
            : _dbl(dashAvgBasket['value']),
        netRevenue: _dbl(revenue['net']) > 0 ? _dbl(revenue['net']) : _dbl(revenue['total']),
        totalTax: _dbl(revenue['tax']),
        totalDiscount: _dbl(revenue['discounts']),
        totalTips: 0.0,
        salesTrend: _dblOrNull(dashTodaySales['change']),
        transactionsTrend: _dblOrNull(dashTransactions['change']),
        avgBasketTrend: _dblOrNull(dashAvgBasket['change']),
        paymentMethodBreakdown: paymentBreakdown,
        hourlyDistribution: hourlyDistribution,
        dailyTrend: daily,
        previousTotalSales: _dblOrNull(trendSummary['previous_total']),
        previousTotalTransactions: null,
        previousAvgTransactionValue: null,
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
