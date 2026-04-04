import 'dart:async';
import 'dart:math';

/// Configuration for retry behavior.
class RetryConfig {
  final Duration initialDelay;
  final Duration maxDelay;
  final int maxRetries;
  final double backoffMultiplier;
  final double jitterFactor;

  const RetryConfig({
    this.initialDelay = const Duration(seconds: 5),
    this.maxDelay = const Duration(minutes: 30),
    this.maxRetries = 10,
    this.backoffMultiplier = 3.0,
    this.jitterFactor = 0.1,
  });
}

/// Retry attempt information.
class RetryAttempt {
  final int attempt;
  final int maxAttempts;
  final Duration delay;
  final DateTime scheduledAt;
  final String? lastError;

  const RetryAttempt({
    required this.attempt,
    required this.maxAttempts,
    required this.delay,
    required this.scheduledAt,
    this.lastError,
  });
}

/// Handles retry logic with exponential backoff and jitter for failed sync operations.
class SyncRetryService {
  SyncRetryService({this.config = const RetryConfig()});

  final RetryConfig config;
  final _random = Random();

  Timer? _retryTimer;
  int _currentAttempt = 0;
  String? _lastError;
  bool _isRetrying = false;
  Completer<void>? _cancelCompleter;

  final _retryController = StreamController<RetryAttempt>.broadcast();
  Stream<RetryAttempt> get retryStream => _retryController.stream;

  int get currentAttempt => _currentAttempt;
  bool get isRetrying => _isRetrying;
  String? get lastError => _lastError;

  /// Execute an operation with automatic retry on failure.
  Future<T> executeWithRetry<T>(Future<T> Function() operation, {bool Function(Exception)? retryIf}) async {
    _currentAttempt = 0;
    _isRetrying = false;
    _cancelCompleter = Completer<void>();

    while (_currentAttempt < config.maxRetries) {
      try {
        final result = await operation();
        _reset();
        return result;
      } on Exception catch (e) {
        _lastError = e.toString();

        if (retryIf != null && !retryIf(e)) {
          _reset();
          rethrow;
        }

        _currentAttempt++;
        if (_currentAttempt >= config.maxRetries) {
          _reset();
          throw RetryExhaustedException('Max retries (${config.maxRetries}) exceeded', lastError: e);
        }

        final delay = _computeDelay(_currentAttempt);
        _isRetrying = true;

        _retryController.add(
          RetryAttempt(
            attempt: _currentAttempt,
            maxAttempts: config.maxRetries,
            delay: delay,
            scheduledAt: DateTime.now().add(delay),
            lastError: _lastError,
          ),
        );

        // Wait for delay or cancellation
        final cancelled = await _waitOrCancel(delay);
        if (cancelled) {
          throw RetryCancelledException();
        }
      }
    }

    throw RetryExhaustedException('Max retries exceeded');
  }

  /// Schedule a retry for a given operation after computing the next delay.
  void scheduleRetry(void Function() operation) {
    _currentAttempt++;
    if (_currentAttempt > config.maxRetries) {
      _reset();
      return;
    }

    final delay = _computeDelay(_currentAttempt);
    _isRetrying = true;

    _retryController.add(
      RetryAttempt(
        attempt: _currentAttempt,
        maxAttempts: config.maxRetries,
        delay: delay,
        scheduledAt: DateTime.now().add(delay),
        lastError: _lastError,
      ),
    );

    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      _isRetrying = false;
      operation();
    });
  }

  /// Cancel any pending retry.
  void cancel() {
    _retryTimer?.cancel();
    _cancelCompleter?.complete();
    _reset();
  }

  /// Reset retry state (e.g., after a successful sync).
  void resetAttempts() {
    _currentAttempt = 0;
    _lastError = null;
    _isRetrying = false;
  }

  /// Compute delay with exponential backoff + jitter.
  /// Sequence: 5s → 15s → 45s → 2m15s → ~6m45s → ~20m → capped at 30m
  Duration _computeDelay(int attempt) {
    final baseMs = config.initialDelay.inMilliseconds * pow(config.backoffMultiplier, attempt - 1);
    final cappedMs = min(baseMs.toInt(), config.maxDelay.inMilliseconds);

    // Add jitter: ±jitterFactor of the delay
    final jitter = (cappedMs * config.jitterFactor * (2 * _random.nextDouble() - 1)).toInt();
    final finalMs = max(1000, cappedMs + jitter);

    return Duration(milliseconds: finalMs);
  }

  Future<bool> _waitOrCancel(Duration delay) async {
    final completer = Completer<bool>();

    final timer = Timer(delay, () {
      if (!completer.isCompleted) completer.complete(false);
    });

    _cancelCompleter?.future.then((_) {
      timer.cancel();
      if (!completer.isCompleted) completer.complete(true);
    });

    return completer.future;
  }

  void _reset() {
    _retryTimer?.cancel();
    _isRetrying = false;
    _cancelCompleter = null;
  }

  void dispose() {
    _retryTimer?.cancel();
    _retryController.close();
  }
}

class RetryExhaustedException implements Exception {
  final String message;
  final Exception? lastError;

  RetryExhaustedException(this.message, {this.lastError});

  @override
  String toString() => 'RetryExhaustedException: $message';
}

class RetryCancelledException implements Exception {
  @override
  String toString() => 'RetryCancelledException: Retry was cancelled';
}
