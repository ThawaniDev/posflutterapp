import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/nice_to_have_repository.dart';
import 'nice_to_have_state.dart';

// ─── Wishlist ─────────────────────────────────────────────
final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class WishlistNotifier extends StateNotifier<WishlistState> {
  final NiceToHaveRepository _repo;
  WishlistNotifier(this._repo) : super(const WishlistInitial());

  Future<void> load(String customerId) async {
    state = const WishlistLoading();
    try {
      final res = await _repo.getWishlist(customerId);
      final data = res.data['data'] as List? ?? [];
      state = WishlistLoaded(data);
    } catch (e) {
      state = WishlistError(e.toString());
    }
  }
}

// ─── Appointments ─────────────────────────────────────────
final appointmentProvider = StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class AppointmentNotifier extends StateNotifier<AppointmentState> {
  final NiceToHaveRepository _repo;
  AppointmentNotifier(this._repo) : super(const AppointmentInitial());

  Future<void> load() async {
    state = const AppointmentLoading();
    try {
      final res = await _repo.getAppointments();
      final data = res.data['data'] as List? ?? [];
      state = AppointmentLoaded(data);
    } catch (e) {
      state = AppointmentError(e.toString());
    }
  }
}

// ─── CfdConfig ────────────────────────────────────────────
final cfdConfigProvider = StateNotifierProvider<CfdConfigNotifier, CfdConfigState>((ref) {
  return CfdConfigNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class CfdConfigNotifier extends StateNotifier<CfdConfigState> {
  final NiceToHaveRepository _repo;
  CfdConfigNotifier(this._repo) : super(const CfdConfigInitial());

  Future<void> load() async {
    state = const CfdConfigLoading();
    try {
      final res = await _repo.getCfdConfig();
      final data = (res.data['data'] as Map<String, dynamic>?) ?? {};
      state = CfdConfigLoaded(data);
    } catch (e) {
      state = CfdConfigError(e.toString());
    }
  }
}

// ─── Gift Registry ────────────────────────────────────────
final giftRegistryProvider = StateNotifierProvider<GiftRegistryNotifier, GiftRegistryState>((ref) {
  return GiftRegistryNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class GiftRegistryNotifier extends StateNotifier<GiftRegistryState> {
  final NiceToHaveRepository _repo;
  GiftRegistryNotifier(this._repo) : super(const GiftRegistryInitial());

  Future<void> load() async {
    state = const GiftRegistryLoading();
    try {
      final res = await _repo.getRegistries();
      final data = res.data['data'] as List? ?? [];
      state = GiftRegistryLoaded(data);
    } catch (e) {
      state = GiftRegistryError(e.toString());
    }
  }
}

// ─── Signage ──────────────────────────────────────────────
final signageProvider = StateNotifierProvider<SignageNotifier, SignageState>((ref) {
  return SignageNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class SignageNotifier extends StateNotifier<SignageState> {
  final NiceToHaveRepository _repo;
  SignageNotifier(this._repo) : super(const SignageInitial());

  Future<void> load() async {
    state = const SignageLoading();
    try {
      final res = await _repo.getPlaylists();
      final data = res.data['data'] as List? ?? [];
      state = SignageLoaded(data);
    } catch (e) {
      state = SignageError(e.toString());
    }
  }
}

// ─── Gamification ─────────────────────────────────────────
final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class GamificationNotifier extends StateNotifier<GamificationState> {
  final NiceToHaveRepository _repo;
  GamificationNotifier(this._repo) : super(const GamificationInitial());

  Future<void> load() async {
    state = const GamificationLoading();
    try {
      final cRes = await _repo.getChallenges();
      final bRes = await _repo.getBadges();
      final tRes = await _repo.getTiers();
      state = GamificationLoaded(
        challenges: cRes.data['data'] as List? ?? [],
        badges: bRes.data['data'] as List? ?? [],
        tiers: tRes.data['data'] as List? ?? [],
      );
    } catch (e) {
      state = GamificationError(e.toString());
    }
  }
}
