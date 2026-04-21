import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/nice_to_have/data/nice_to_have_repository.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_state.dart';

// ─── Wishlist ─────────────────────────────────────────────
final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class WishlistNotifier extends StateNotifier<WishlistState> {
  WishlistNotifier(this._repo) : super(const WishlistInitial());
  final NiceToHaveRepository _repo;

  Future<void> load(String customerId) async {
    if (state is! WishlistLoaded) state = const WishlistLoading();
    try {
      final res = await _repo.getWishlist(customerId);
      final data = res.data['data'] as List? ?? [];
      state = WishlistLoaded(data);
    } catch (e) {
      if (state is! WishlistLoaded) state = WishlistError(e.toString());
    }
  }
}

// ─── Appointments ─────────────────────────────────────────
final appointmentProvider = StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class AppointmentNotifier extends StateNotifier<AppointmentState> {
  AppointmentNotifier(this._repo) : super(const AppointmentInitial());
  final NiceToHaveRepository _repo;

  Future<void> load() async {
    if (state is! AppointmentLoaded) state = const AppointmentLoading();
    try {
      final res = await _repo.getAppointments();
      final data = res.data['data'] as List? ?? [];
      state = AppointmentLoaded(data);
    } catch (e) {
      if (state is! AppointmentLoaded) state = AppointmentError(e.toString());
    }
  }
}

// ─── CfdConfig ────────────────────────────────────────────
final cfdConfigProvider = StateNotifierProvider<CfdConfigNotifier, CfdConfigState>((ref) {
  return CfdConfigNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class CfdConfigNotifier extends StateNotifier<CfdConfigState> {
  CfdConfigNotifier(this._repo) : super(const CfdConfigInitial());
  final NiceToHaveRepository _repo;

  Future<void> load() async {
    if (state is! CfdConfigLoaded) state = const CfdConfigLoading();
    try {
      final res = await _repo.getCfdConfig();
      final data = (res.data['data'] as Map<String, dynamic>?) ?? {};
      state = CfdConfigLoaded(data);
    } catch (e) {
      if (state is! CfdConfigLoaded) state = CfdConfigError(e.toString());
    }
  }
}

// ─── Gift Registry ────────────────────────────────────────
final giftRegistryProvider = StateNotifierProvider<GiftRegistryNotifier, GiftRegistryState>((ref) {
  return GiftRegistryNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class GiftRegistryNotifier extends StateNotifier<GiftRegistryState> {
  GiftRegistryNotifier(this._repo) : super(const GiftRegistryInitial());
  final NiceToHaveRepository _repo;

  Future<void> load() async {
    if (state is! GiftRegistryLoaded) state = const GiftRegistryLoading();
    try {
      final res = await _repo.getRegistries();
      final data = res.data['data'] as List? ?? [];
      state = GiftRegistryLoaded(data);
    } catch (e) {
      if (state is! GiftRegistryLoaded) state = GiftRegistryError(e.toString());
    }
  }
}

// ─── Signage ──────────────────────────────────────────────
final signageProvider = StateNotifierProvider<SignageNotifier, SignageState>((ref) {
  return SignageNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class SignageNotifier extends StateNotifier<SignageState> {
  SignageNotifier(this._repo) : super(const SignageInitial());
  final NiceToHaveRepository _repo;

  Future<void> load() async {
    if (state is! SignageLoaded) state = const SignageLoading();
    try {
      final res = await _repo.getPlaylists();
      final data = res.data['data'] as List? ?? [];
      state = SignageLoaded(data);
    } catch (e) {
      if (state is! SignageLoaded) state = SignageError(e.toString());
    }
  }
}

// ─── Gamification ─────────────────────────────────────────
final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier(ref.watch(niceToHaveRepositoryProvider));
});

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier(this._repo) : super(const GamificationInitial());
  final NiceToHaveRepository _repo;

  Future<void> load() async {
    if (state is! GamificationLoaded) state = const GamificationLoading();
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
      if (state is! GamificationLoaded) state = GamificationError(e.toString());
    }
  }
}
