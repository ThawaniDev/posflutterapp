import 'package:wameedpos/features/softpos/services/softpos_service.dart';

// ─── State ──────────────────────────────────────────────────────────────────

sealed class SoftPosState {
  const SoftPosState();
}

/// SDK has never been initialised this session.
class SoftPosIdle extends SoftPosState {
  const SoftPosIdle();
}

/// Initialisation in progress.
class SoftPosInitialising extends SoftPosState {
  const SoftPosInitialising();
}

/// SDK is ready for payments.
class SoftPosReady extends SoftPosState {
  const SoftPosReady({required this.sessionId});
  final String sessionId;
}

/// Initialisation failed.
class SoftPosError extends SoftPosState {
  const SoftPosError(this.message);
  final String message;
}

/// A payment is in progress (SDK UI is open).
class SoftPosProcessing extends SoftPosState {
  const SoftPosProcessing();
}

/// Last payment completed.
class SoftPosPaymentDone extends SoftPosState {
  const SoftPosPaymentDone(this.result);
  final SoftPosPaymentResult result;
}
