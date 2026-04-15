import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final niceToHaveApiServiceProvider = Provider<NiceToHaveApiService>((ref) {
  return NiceToHaveApiService(ref.watch(dioClientProvider));
});

class NiceToHaveApiService {
  final Dio _dio;
  NiceToHaveApiService(this._dio);

  // ─── Wishlist ───────────────────────────────────────────
  Future<Response> getWishlist(String customerId) =>
      _dio.get(ApiEndpoints.wishlist, queryParameters: {'customer_id': customerId});

  Future<Response> addToWishlist(Map<String, dynamic> data) => _dio.post(ApiEndpoints.wishlist, data: data);

  Future<Response> removeFromWishlist(Map<String, dynamic> data) => _dio.delete(ApiEndpoints.wishlist, data: data);

  // ─── Appointments ──────────────────────────────────────
  Future<Response> getAppointments() => _dio.get(ApiEndpoints.appointments);

  Future<Response> createAppointment(Map<String, dynamic> data) => _dio.post(ApiEndpoints.appointments, data: data);

  Future<Response> updateAppointment(String id, Map<String, dynamic> data) =>
      _dio.put(ApiEndpoints.appointmentUpdate(id), data: data);

  Future<Response> cancelAppointment(String id) => _dio.post(ApiEndpoints.appointmentCancel(id));

  // ─── CFD ────────────────────────────────────────────────
  Future<Response> getCfdConfig() => _dio.get(ApiEndpoints.cfdConfig);

  Future<Response> updateCfdConfig(Map<String, dynamic> data) => _dio.put(ApiEndpoints.cfdConfig, data: data);

  // ─── Gift Registry ─────────────────────────────────────
  Future<Response> getRegistries() => _dio.get(ApiEndpoints.giftRegistry);

  Future<Response> createRegistry(Map<String, dynamic> data) => _dio.post(ApiEndpoints.giftRegistry, data: data);

  Future<Response> getRegistryByShareCode(String code) => _dio.get(ApiEndpoints.giftRegistryShare(code));

  Future<Response> addRegistryItem(String registryId, Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.giftRegistryItems(registryId), data: data);

  Future<Response> getRegistryItems(String registryId) => _dio.get(ApiEndpoints.giftRegistryItems(registryId));

  // ─── Signage ────────────────────────────────────────────
  Future<Response> getPlaylists() => _dio.get(ApiEndpoints.signagePlaylists);

  Future<Response> createPlaylist(Map<String, dynamic> data) => _dio.post(ApiEndpoints.signagePlaylists, data: data);

  Future<Response> updatePlaylist(String id, Map<String, dynamic> data) => _dio.put(ApiEndpoints.signagePlaylist(id), data: data);

  Future<Response> deletePlaylist(String id) => _dio.delete(ApiEndpoints.signagePlaylist(id));

  // ─── Gamification ──────────────────────────────────────
  Future<Response> getChallenges() => _dio.get(ApiEndpoints.gamificationChallenges);

  Future<Response> getBadges() => _dio.get(ApiEndpoints.customerGamificationBadges);

  Future<Response> getTiers() => _dio.get(ApiEndpoints.gamificationTiers);

  Future<Response> getCustomerProgress(String customerId) => _dio.get(ApiEndpoints.gamificationCustomerProgress(customerId));

  Future<Response> getCustomerBadges(String customerId) => _dio.get(ApiEndpoints.gamificationCustomerBadges(customerId));
}
