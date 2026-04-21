// ─── Wishlist ─────────────────────────────────────────────
sealed class WishlistState {
  const WishlistState();
}

final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistLoaded extends WishlistState {
  const WishlistLoaded(this.items);
  final List<dynamic> items;
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);
  final String message;
}

// ─── Appointments ─────────────────────────────────────────
sealed class AppointmentState {
  const AppointmentState();
}

final class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

final class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

final class AppointmentLoaded extends AppointmentState {
  const AppointmentLoaded(this.appointments);
  final List<dynamic> appointments;
}

final class AppointmentError extends AppointmentState {
  const AppointmentError(this.message);
  final String message;
}

// ─── CfdConfig ────────────────────────────────────────────
sealed class CfdConfigState {
  const CfdConfigState();
}

final class CfdConfigInitial extends CfdConfigState {
  const CfdConfigInitial();
}

final class CfdConfigLoading extends CfdConfigState {
  const CfdConfigLoading();
}

final class CfdConfigLoaded extends CfdConfigState {
  const CfdConfigLoaded(this.config);
  final Map<String, dynamic> config;
}

final class CfdConfigError extends CfdConfigState {
  const CfdConfigError(this.message);
  final String message;
}

// ─── Gift Registry ────────────────────────────────────────
sealed class GiftRegistryState {
  const GiftRegistryState();
}

final class GiftRegistryInitial extends GiftRegistryState {
  const GiftRegistryInitial();
}

final class GiftRegistryLoading extends GiftRegistryState {
  const GiftRegistryLoading();
}

final class GiftRegistryLoaded extends GiftRegistryState {
  const GiftRegistryLoaded(this.registries);
  final List<dynamic> registries;
}

final class GiftRegistryError extends GiftRegistryState {
  const GiftRegistryError(this.message);
  final String message;
}

// ─── Signage ──────────────────────────────────────────────
sealed class SignageState {
  const SignageState();
}

final class SignageInitial extends SignageState {
  const SignageInitial();
}

final class SignageLoading extends SignageState {
  const SignageLoading();
}

final class SignageLoaded extends SignageState {
  const SignageLoaded(this.playlists);
  final List<dynamic> playlists;
}

final class SignageError extends SignageState {
  const SignageError(this.message);
  final String message;
}

// ─── Gamification ─────────────────────────────────────────
sealed class GamificationState {
  const GamificationState();
}

final class GamificationInitial extends GamificationState {
  const GamificationInitial();
}

final class GamificationLoading extends GamificationState {
  const GamificationLoading();
}

final class GamificationLoaded extends GamificationState {
  const GamificationLoaded({required this.challenges, required this.badges, required this.tiers});
  final List<dynamic> challenges;
  final List<dynamic> badges;
  final List<dynamic> tiers;
}

final class GamificationError extends GamificationState {
  const GamificationError(this.message);
  final String message;
}

// ─── Nice-to-Have Operation ───────────────────────────────
sealed class NiceToHaveOperationState {
  const NiceToHaveOperationState();
}

final class NthOpIdle extends NiceToHaveOperationState {
  const NthOpIdle();
}

final class NthOpLoading extends NiceToHaveOperationState {
  const NthOpLoading();
}

final class NthOpSuccess extends NiceToHaveOperationState {
  const NthOpSuccess(this.message);
  final String message;
}

final class NthOpError extends NiceToHaveOperationState {
  const NthOpError(this.message);
  final String message;
}
