import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('creates with message', () {
      const ex = AppException(message: 'Something went wrong');
      expect(ex.message, 'Something went wrong');
      expect(ex.code, isNull);
      expect(ex.originalError, isNull);
    });

    test('creates with code and original error', () {
      const original = FormatException('bad format');
      const ex = AppException(message: 'Parse error', code: 'PARSE', originalError: original);
      expect(ex.message, 'Parse error');
      expect(ex.code, 'PARSE');
      expect(ex.originalError, original);
    });

    test('toString includes message', () {
      const ex = AppException(message: 'Test error');
      expect(ex.toString(), contains('Test error'));
    });
  });

  group('NetworkException', () {
    test('creates with status code', () {
      const ex = NetworkException(message: 'Not found', statusCode: 404);
      expect(ex.message, 'Not found');
      expect(ex.statusCode, 404);
    });

    test('inherits from AppException', () {
      const ex = NetworkException(message: 'Server error', statusCode: 500);
      expect(ex, isA<AppException>());
    });

    test('toString includes status code', () {
      const ex = NetworkException(message: 'Unauthorized', statusCode: 401);
      final str = ex.toString();
      expect(str, contains('401'));
    });

    test('common HTTP status codes', () {
      const badRequest = NetworkException(message: 'Bad request', statusCode: 400);
      expect(badRequest.statusCode, 400);

      const forbidden = NetworkException(message: 'Forbidden', statusCode: 403);
      expect(forbidden.statusCode, 403);

      const serverError = NetworkException(message: 'Internal error', statusCode: 500);
      expect(serverError.statusCode, 500);

      const timeout = NetworkException(message: 'Gateway timeout', statusCode: 504);
      expect(timeout.statusCode, 504);
    });
  });

  group('AuthException', () {
    test('creates correctly', () {
      const ex = AuthException(message: 'Token expired');
      expect(ex.message, 'Token expired');
    });

    test('inherits from AppException', () {
      const ex = AuthException(message: 'Unauthorized');
      expect(ex, isA<AppException>());
    });

    test('common auth scenarios', () {
      const expired = AuthException(message: 'Session expired');
      expect(expired.message, 'Session expired');

      const invalid = AuthException(message: 'Invalid credentials');
      expect(invalid.message, 'Invalid credentials');

      const pinRequired = AuthException(message: 'PIN verification required');
      expect(pinRequired.message, contains('PIN'));
    });
  });

  group('SyncException', () {
    test('creates correctly', () {
      const ex = SyncException(message: 'Sync failed');
      expect(ex.message, 'Sync failed');
    });

    test('inherits from AppException', () {
      const ex = SyncException(message: 'Conflict detected');
      expect(ex, isA<AppException>());
    });

    test('common sync scenarios', () {
      const conflict = SyncException(message: 'Data conflict during sync');
      expect(conflict.message, contains('conflict'));

      const offline = SyncException(message: 'Cannot sync while offline');
      expect(offline.message, contains('offline'));
    });
  });

  group('Exception hierarchy', () {
    test('all exceptions are AppException', () {
      final exceptions = <AppException>[
        const AppException(message: 'base'),
        const NetworkException(message: 'network', statusCode: 500),
        const AuthException(message: 'auth'),
        const SyncException(message: 'sync'),
      ];

      for (final ex in exceptions) {
        expect(ex, isA<AppException>());
        expect(ex.message, isNotEmpty);
      }
    });

    test('can catch all via AppException', () {
      AppException? caught;

      try {
        throw const NetworkException(message: 'test', statusCode: 404);
      } on AppException catch (e) {
        caught = e;
      }

      expect(caught, isNotNull);
      expect(caught, isA<NetworkException>());
      expect((caught as NetworkException).statusCode, 404);
    });
  });
}
