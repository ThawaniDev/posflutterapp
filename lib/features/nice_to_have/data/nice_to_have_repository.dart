import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/nice_to_have/data/nice_to_have_api_service.dart';

final niceToHaveRepositoryProvider = Provider<NiceToHaveRepository>((ref) {
  return NiceToHaveRepository(ref.watch(niceToHaveApiServiceProvider));
});

class NiceToHaveRepository {
  NiceToHaveRepository(this._api);
  final NiceToHaveApiService _api;

  // Wishlist
  Future<Response> getWishlist(String customerId) => _api.getWishlist(customerId);
  Future<Response> addToWishlist(Map<String, dynamic> data) => _api.addToWishlist(data);
  Future<Response> removeFromWishlist(Map<String, dynamic> data) => _api.removeFromWishlist(data);

  // Appointments
  Future<Response> getAppointments() => _api.getAppointments();
  Future<Response> createAppointment(Map<String, dynamic> data) => _api.createAppointment(data);
  Future<Response> updateAppointment(String id, Map<String, dynamic> data) => _api.updateAppointment(id, data);
  Future<Response> cancelAppointment(String id) => _api.cancelAppointment(id);

  // CFD
  Future<Response> getCfdConfig() => _api.getCfdConfig();
  Future<Response> updateCfdConfig(Map<String, dynamic> data) => _api.updateCfdConfig(data);

  // Gift Registry
  Future<Response> getRegistries() => _api.getRegistries();
  Future<Response> createRegistry(Map<String, dynamic> data) => _api.createRegistry(data);
  Future<Response> getRegistryByShareCode(String code) => _api.getRegistryByShareCode(code);
  Future<Response> addRegistryItem(String registryId, Map<String, dynamic> data) => _api.addRegistryItem(registryId, data);
  Future<Response> getRegistryItems(String registryId) => _api.getRegistryItems(registryId);

  // Signage
  Future<Response> getPlaylists() => _api.getPlaylists();
  Future<Response> createPlaylist(Map<String, dynamic> data) => _api.createPlaylist(data);
  Future<Response> updatePlaylist(String id, Map<String, dynamic> data) => _api.updatePlaylist(id, data);
  Future<Response> deletePlaylist(String id) => _api.deletePlaylist(id);

  // Gamification
  Future<Response> getChallenges() => _api.getChallenges();
  Future<Response> getBadges() => _api.getBadges();
  Future<Response> getTiers() => _api.getTiers();
  Future<Response> getCustomerProgress(String customerId) => _api.getCustomerProgress(customerId);
  Future<Response> getCustomerBadges(String customerId) => _api.getCustomerBadges(customerId);
}
