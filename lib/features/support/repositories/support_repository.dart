import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/support/data/remote/support_api_service.dart';

class SupportRepository {

  SupportRepository(this._apiService);
  final SupportApiService _apiService;

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();

  Future<Map<String, dynamic>> listTickets({
    String? status,
    String? category,
    String? priority,
    String? search,
    int? page,
    int? perPage,
  }) => _apiService.listTickets(
    status: status,
    category: category,
    priority: priority,
    search: search,
    page: page,
    perPage: perPage,
  );

  Future<Map<String, dynamic>> getTicket(String id) => _apiService.getTicket(id);

  Future<Map<String, dynamic>> createTicket({
    required String category,
    required String subject,
    required String description,
    String? priority,
  }) => _apiService.createTicket(category: category, subject: subject, description: description, priority: priority);

  Future<Map<String, dynamic>> addMessage(String ticketId, {required String message}) =>
      _apiService.addMessage(ticketId, message: message);

  Future<Map<String, dynamic>> closeTicket(String id) => _apiService.closeTicket(id);

  Future<Map<String, dynamic>> getKbArticles({String? category, String? search}) =>
      _apiService.getKbArticles(category: category, search: search);

  Future<Map<String, dynamic>> getKbArticle(String slug) => _apiService.getKbArticle(slug);
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.watch(supportApiServiceProvider));
});
