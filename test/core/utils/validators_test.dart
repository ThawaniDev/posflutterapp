import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('returns error for null', () {
      final result = Validators.required(null, 'Name');
      expect(result, isNotNull);
      expect(result, contains('Name'));
    });

    test('returns error for empty string', () {
      final result = Validators.required('', 'Name');
      expect(result, isNotNull);
    });

    test('returns error for whitespace-only string', () {
      final result = Validators.required('   ', 'Name');
      expect(result, isNotNull);
    });

    test('returns null for valid input', () {
      final result = Validators.required('John', 'Name');
      expect(result, isNull);
    });

    test('returns null for arabic text', () {
      final result = Validators.required('أحمد', 'Name');
      expect(result, isNull);
    });
  });

  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('user.name@domain.co'), isNull);
      expect(Validators.email('user-name@domain.com'), isNull);
      expect(Validators.email('user_name@domain.com'), isNull);
    });

    test('returns error for invalid email', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
      expect(Validators.email('user@.com'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('returns error for null input', () {
      final result = Validators.email(null);
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('validates email with common TLDs', () {
      expect(Validators.email('a@b.om'), isNull);
      expect(Validators.email('a@b.sa'), isNull);
      expect(Validators.email('a@b.io'), isNull);
    });
  });

  group('Validators.phone', () {
    test('returns null for valid phone numbers', () {
      expect(Validators.phone('+96891234567'), isNull);
      expect(Validators.phone('+966512345678'), isNull);
      expect(Validators.phone('12345678'), isNull);
      expect(Validators.phone('+1234567890'), isNull);
    });

    test('returns error for invalid phone numbers', () {
      expect(Validators.phone('abc'), isNotNull);
      expect(Validators.phone('123'), isNotNull); // too short (< 8 digits)
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('+1234567890123456'), isNotNull); // too long (> 15)
    });

    test('returns error for null input', () {
      final result = Validators.phone(null);
      expect(result, isNotNull);
      expect(result, contains('required'));
    });
  });

  group('Validators.minLength', () {
    test('returns null when value meets minimum', () {
      expect(Validators.minLength('abcdef', 6), isNull);
      expect(Validators.minLength('longer string', 6), isNull);
    });

    test('returns error when too short', () {
      expect(Validators.minLength('abc', 6), isNotNull);
      expect(Validators.minLength('', 1), isNotNull);
    });

    test('returns error for null input', () {
      final result = Validators.minLength(null, 6);
      expect(result, isNotNull);
      expect(result, contains('at least'));
    });
  });

  group('Validators.pin', () {
    test('returns null for valid 4-digit PIN', () {
      expect(Validators.pin('1234'), isNull);
      expect(Validators.pin('0000'), isNull);
      expect(Validators.pin('9999'), isNull);
    });

    test('returns error for non-4-digit values', () {
      expect(Validators.pin('123'), isNotNull); // too short
      expect(Validators.pin('12345'), isNotNull); // too long
      expect(Validators.pin('abcd'), isNotNull); // not digits
      expect(Validators.pin(''), isNotNull); // empty
    });

    test('returns error for null input', () {
      final result = Validators.pin(null);
      expect(result, isNotNull);
      expect(result, contains('required'));
    });
  });
}
