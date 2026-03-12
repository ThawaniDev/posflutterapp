import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('creates with message', () {
      final ex = AppException(message: 'Something went wrong');
      expect(ex.message, 'Something went wrong');
      expect(ex.code, isNull);
      expect(ex.originalError, isNull);
    });

    test('creates with code and original error', () {
      final original = FormatException('bad format');
      final ex = AppException(message: 'Parse error', code: 'PARSE', originalError: original);
      expect(ex.message, 'Parse error');
      expect(ex.code, 'PARSE');
      expect(ex.originalError, original);
    });

    test('toString includes message', () {
      final ex = AppException(message: 'Test error');
      expect(ex.toString(), contains('Test error'));
    });
  });

  group('NetworkException', () {
    test('creates with status code', () {
      final ex = NetworkException(message: 'Not found', statusCode: 404);
      expect(ex.message, 'Not found');
      expect(ex.statusCode, 404);
    });

    test('inherits from AppException', () {
      final ex = NetworkException(message: 'Server error', statusCode: 500);
      expect(ex, isA<AppException>());
    });

    test('toString includes status code', () {
      final ex = NetworkException(message: 'Unauthorized', statusCode: 401);
      final str = ex.toString();
      expect(str, contains('401'));
    });

    test('common HTTP status codes', () {
      final badRequest = NetworkException(message: 'Bad request', statusCode: 400);
      expect(badRequest.statusCode, 400);

      final forbidden = NetworkException(message: 'Forbidden', statusCode: 403);
      expect(forbidden.statusCode, 403);

      final serverError = NetworkException(message: 'Internal error', statusCode: 500);
      expect(serverError.statusCode, 500);

      final timeout = NetworkException(message: 'Gateway timeout', statusCode: 504);
      expect(timeout.statusCode, 504);
    });
  });

  group('AuthException', () {
    test('creates correctly', () {
      final ex = AuthException(message: 'Token expired');
      expect(ex.message, 'Token expired');
    });

    test('inherits from AppException', () {
      final ex = AuthException(message: 'Unauthorized');
      expect(ex, isA<AppException>());
    });

    test('common auth scenarios', () {
      final expired = AuthException(message: 'Session expired');
      expect(expired.message, 'Session expired');

      final invalid = AuthException(message: 'Invalid credentials');
      expect(invalid.message, 'Invalid credentials');

      final pinRequired = AuthException(message: 'PIN verification required');
      expect(pinRequired.message, contains('PIN'));
    });
  });

  group('SyncException', () {
    test('creates correctly', () {
      final ex = SyncException(message: 'Sync failed');
      expect(ex.message, 'Sync failed');
    });

    test('inherits from AppException', () {
      final ex = SyncException(message: 'Conflict detected');
      expect(ex, isA<AppException>());
    });

    test('common sync scenarios', () {
      final conflict = SyncException(message: 'Data conflict during sync');
      expect(conflict.message, contains('conflict'));

      final offline = SyncException(message: 'Cannot sync while offline');
      expect(offline.message, contains('offline'));
    });
  });

  group('Exception hierarchy', () {
    test('all exceptions are AppException', () {
      final exceptions = <AppException>[
        AppException(message: 'base'),
        NetworkException(message: 'network', statusCode: 500),
        AuthException(message: 'auth'),
        SyncException(message: 'sync'),
      ];

      for (final ex in exceptions) {
        expect(ex, isA<AppException>());
        expect(ex.message, isNotEmpty);
      }
    });

    test('can catch all via AppException', () {
      AppException? caught;

      try {
        throw NetworkException(message: 'test', statusCode: 404);
      } on AppException catch (e) {
        caught = e;
      }

      expect(caught, isNotNull);
      expect(caught, isA<NetworkException>());
      expect((caught as NetworkException).statusCode, 404);
    });
  });
}
