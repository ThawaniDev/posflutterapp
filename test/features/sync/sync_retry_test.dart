import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/sync/services/sync_retry_service.dart';

void main() {
  group('RetryConfig', () {
    test('default values', () {
      const config = RetryConfig();
      expect(config.maxRetries, 10);
      expect(config.initialDelay, const Duration(seconds: 5));
      expect(config.maxDelay, const Duration(minutes: 30));
      expect(config.backoffMultiplier, 3.0);
      expect(config.jitterFactor, 0.1);
    });

    test('custom values are preserved', () {
      const config = RetryConfig(
        maxRetries: 3,
        initialDelay: Duration(seconds: 1),
        maxDelay: Duration(minutes: 5),
        backoffMultiplier: 2.0,
      );
      expect(config.maxRetries, 3);
      expect(config.initialDelay, const Duration(seconds: 1));
      expect(config.maxDelay, const Duration(minutes: 5));
      expect(config.backoffMultiplier, 2.0);
    });
  });

  group('RetryAttempt', () {
    test('constructor and fields', () {
      final now = DateTime.now();
      final attempt = RetryAttempt(
        attempt: 1,
        maxAttempts: 6,
        delay: const Duration(seconds: 15),
        scheduledAt: now,
        lastError: 'Connection failed',
      );
      expect(attempt.attempt, 1);
      expect(attempt.maxAttempts, 6);
      expect(attempt.scheduledAt, now);
      expect(attempt.lastError, 'Connection failed');
      expect(attempt.delay, const Duration(seconds: 15));
    });
  });

  group('RetryExhaustedException', () {
    test('toString includes message', () {
      final exception = RetryExhaustedException('Max retries exceeded');
      expect(exception.toString(), contains('Max retries exceeded'));
    });
  });

  group('RetryCancelledException', () {
    test('toString returns message', () {
      final exception = RetryCancelledException();
      expect(exception.toString(), contains('cancelled'));
    });
  });
}
