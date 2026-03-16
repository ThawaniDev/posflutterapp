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
  final List<dynamic> items;
  const WishlistLoaded(this.items);
}

final class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);
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
  final List<dynamic> appointments;
  const AppointmentLoaded(this.appointments);
}

final class AppointmentError extends AppointmentState {
  final String message;
  const AppointmentError(this.message);
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
  final Map<String, dynamic> config;
  const CfdConfigLoaded(this.config);
}

final class CfdConfigError extends CfdConfigState {
  final String message;
  const CfdConfigError(this.message);
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
  final List<dynamic> registries;
  const GiftRegistryLoaded(this.registries);
}

final class GiftRegistryError extends GiftRegistryState {
  final String message;
  const GiftRegistryError(this.message);
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
  final List<dynamic> playlists;
  const SignageLoaded(this.playlists);
}

final class SignageError extends SignageState {
  final String message;
  const SignageError(this.message);
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
  final List<dynamic> challenges;
  final List<dynamic> badges;
  final List<dynamic> tiers;
  const GamificationLoaded({required this.challenges, required this.badges, required this.tiers});
}

final class GamificationError extends GamificationState {
  final String message;
  const GamificationError(this.message);
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
  final String message;
  const NthOpSuccess(this.message);
}

final class NthOpError extends NiceToHaveOperationState {
  final String message;
  const NthOpError(this.message);
}
