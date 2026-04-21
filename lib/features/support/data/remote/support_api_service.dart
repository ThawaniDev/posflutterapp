import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

class SupportApiService {

  SupportApiService(this._dio);
  final Dio _dio;

  /// GET /support/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.supportStats);
    return response.data as Map<String, dynamic>;
  }

  /// GET /support/tickets
  Future<Map<String, dynamic>> listTickets({
    String? status,
    String? category,
    String? priority,
    String? search,
    int? page,
    int? perPage,
  }) async {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status;
    if (category != null) params['category'] = category;
    if (priority != null) params['priority'] = priority;
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.supportTickets, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /support/tickets/{id}
  Future<Map<String, dynamic>> getTicket(String id) async {
    final response = await _dio.get(ApiEndpoints.supportTicketById(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /support/tickets
  Future<Map<String, dynamic>> createTicket({
    required String category,
    required String subject,
    required String description,
    String? priority,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.supportTickets,
      data: {'category': category, 'subject': subject, 'description': description, 'priority': ?priority},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /support/tickets/{id}/messages
  Future<Map<String, dynamic>> addMessage(String ticketId, {required String message}) async {
    final response = await _dio.post(ApiEndpoints.supportTicketMessages(ticketId), data: {'message': message});
    return response.data as Map<String, dynamic>;
  }

  /// PUT /support/tickets/{id}/close
  Future<Map<String, dynamic>> closeTicket(String id) async {
    final response = await _dio.put(ApiEndpoints.supportTicketClose(id));
    return response.data as Map<String, dynamic>;
  }

  /// GET /support/kb
  Future<Map<String, dynamic>> getKbArticles({String? category, String? search}) async {
    final params = <String, dynamic>{};
    if (category != null) params['category'] = category;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final response = await _dio.get(ApiEndpoints.supportKb, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /support/kb/{slug}
  Future<Map<String, dynamic>> getKbArticle(String slug) async {
    final response = await _dio.get(ApiEndpoints.supportKbArticle(slug));
    return response.data as Map<String, dynamic>;
  }
}

final supportApiServiceProvider = Provider<SupportApiService>((ref) {
  return SupportApiService(ref.watch(dioClientProvider));
});
