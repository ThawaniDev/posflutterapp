import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';
import 'package:wameedpos/features/softpos/providers/softpos_state.dart';
import 'package:wameedpos/features/softpos/services/softpos_service.dart';

// ─── Storage keys ────────────────────────────────────────────────────────────

const _kEdfapayToken = 'edfapay_terminal_token';
const _kEdfapayEnv = 'edfapay_environment';

// ─── Service provider ────────────────────────────────────────────────────────

/// Singleton [SoftPosService].  Re-used across re-reads so the SDK
/// initialisation state is preserved within the app session.
final softPosServiceProvider = Provider<SoftPosService>((ref) {
  return SoftPosService();
});

// ─── Settings providers ──────────────────────────────────────────────────────

final _secureStorage = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Reads the stored EdfaPay terminal token (null = not configured).
final softPosTokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(_secureStorage);
  return storage.read(key: _kEdfapayToken);
});

/// Reads the stored environment string (`'production'` or `'development'`).
final softPosEnvironmentProvider = FutureProvider<String>((ref) async {
  final storage = ref.read(_secureStorage);
  return (await storage.read(key: _kEdfapayEnv)) ?? 'production';
});

// ─── Notifier ────────────────────────────────────────────────────────────────

class SoftPosNotifier extends StateNotifier<SoftPosState> {
  SoftPosNotifier(this._service, this._storage, this._db) : super(const SoftPosIdle());

  final SoftPosService _service;
  final FlutterSecureStorage _storage;
  final PosOfflineDatabase _db;

  bool get isReady => state is SoftPosReady;

  // ── Save config ──────────────────────────────────────────────────────────

  Future<void> saveConfig({required String token, required String environment}) async {
    await _storage.write(key: _kEdfapayToken, value: token.trim());
    await _storage.write(key: _kEdfapayEnv, value: environment);
  }

  Future<void> clearConfig() async {
    await _storage.delete(key: _kEdfapayToken);
    await _storage.delete(key: _kEdfapayEnv);
    state = const SoftPosIdle();
  }

  // ── Initialise ───────────────────────────────────────────────────────────

  /// Initialise using credentials stored in secure storage.
  Future<void> initFromStorage() async {
    final token = await _storage.read(key: _kEdfapayToken);
    final env = (await _storage.read(key: _kEdfapayEnv)) ?? 'production';
    if (token == null || token.isEmpty) {
      state = const SoftPosError('No terminal token configured. Go to Settings → Hardware → SoftPOS.');
      return;
    }
    await _init(token: token, environment: env);
  }

  /// Initialise with explicit credentials (e.g. after saving settings).
  Future<void> initWithToken({required String token, String environment = 'production'}) async {
    await saveConfig(token: token, environment: environment);
    await _init(token: token, environment: environment);
  }

  Future<void> _init({required String token, required String environment}) async {
    if (!_service.isAvailable) {
      state = const SoftPosError('SoftPOS is only supported on Android devices.');
      return;
    }
    state = const SoftPosInitialising();
    await _service.initialize(
      token: token,
      environment: environment,
      logoPath: 'assets/images/wameedlogo.png',
      onError: (msg) => state = SoftPosError(msg),
      onSuccess: (sessionId) => state = SoftPosReady(sessionId: sessionId),
    );
  }

  // ── Payment ──────────────────────────────────────────────────────────────

  Future<SoftPosPaymentResult> pay({required String amount, required String orderId}) async {
    state = const SoftPosProcessing();
    final result = await _service.purchase(amount: amount, orderId: orderId);
    state = SoftPosPaymentDone(result);
    return result;
  }

  void resetPaymentState() {
    if (_service.isInitiated) {
      state = const SoftPosReady(sessionId: '');
    } else {
      state = const SoftPosIdle();
    }
  }

  // ── Offline recovery queue ───────────────────────────────────────────────

  /// Enqueues a failed SoftPOS transaction payload into the local sync queue
  /// so it gets replayed automatically when connectivity is restored.
  ///
  /// [payload] should be the complete transaction body that would normally be
  /// POSTed to `/api/v2/pos/transactions`, **including** an `idempotency_key`
  /// so the server can safely deduplicate replays.
  Future<void> enqueueSoftPosTransaction(Map<String, dynamic> payload) async {
    await _db.enqueue(
      LocalSyncQueueCompanion(
        clientUuid: Value(payload['idempotency_key'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString()),
        kind: const Value('softpos_transaction'),
        payloadJson: Value(jsonEncode(payload)),
        attempts: const Value(0),
        createdAt: Value(DateTime.now()),
        nextAttemptAt: Value(DateTime.now()),
        status: const Value('pending'),
      ),
    );
  }
}

// ─── Exposed provider ────────────────────────────────────────────────────────

final softPosProvider = StateNotifierProvider<SoftPosNotifier, SoftPosState>((ref) {
  final service = ref.watch(softPosServiceProvider);
  final db = ref.watch(posOfflineDatabaseProvider);
  const storage = FlutterSecureStorage();
  return SoftPosNotifier(service, storage, db);
});
