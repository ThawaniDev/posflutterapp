import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/network/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('fromJson parses success response with data', () {
      final json = {
        'success': true,
        'message': 'Resource retrieved',
        'data': {'id': '1', 'name': 'Test'},
      };

      final response = ApiResponse<Map<String, dynamic>>.fromJson(json, (data) => data as Map<String, dynamic>);

      expect(response.success, true);
      expect(response.message, 'Resource retrieved');
      expect(response.data, isNotNull);
      expect(response.data!['id'], '1');
      expect(response.data!['name'], 'Test');
    });

    test('fromJson parses error response', () {
      final json = {
        'success': false,
        'message': 'Validation error',
        'errors': {
          'email': ['Email is required'],
          'name': ['Name is too short'],
        },
      };

      final response = ApiResponse<void>.fromJson(json, null);

      expect(response.success, false);
      expect(response.message, 'Validation error');
      expect(response.errors, isNotNull);
      expect(response.errors!['email'], contains('Email is required'));
    });

    test('fromJson parses response with generic model', () {
      final json = {
        'success': true,
        'message': 'OK',
        'data': {'token': 'abc123', 'token_type': 'Bearer'},
      };

      final response = ApiResponse<_MockToken>.fromJson(json, (data) => _MockToken.fromJson(data as Map<String, dynamic>));

      expect(response.success, true);
      expect(response.data, isNotNull);
      expect(response.data!.token, 'abc123');
      expect(response.data!.tokenType, 'Bearer');
    });

    test('fromJson handles null data gracefully', () {
      final json = {'success': true, 'message': 'Deleted', 'data': null};

      final response = ApiResponse<Map<String, dynamic>>.fromJson(json, (data) => data as Map<String, dynamic>);

      expect(response.success, true);
      expect(response.data, isNull);
    });

    test('fromJson handles missing data key', () {
      final json = {'success': true, 'message': 'No content'};

      final response = ApiResponse<void>.fromJson(json, null);

      expect(response.success, true);
      expect(response.message, 'No content');
    });

    test('fromJson parses list data', () {
      final json = {
        'success': true,
        'message': 'Listed',
        'data': [
          {'id': '1', 'name': 'A'},
          {'id': '2', 'name': 'B'},
        ],
      };

      final response = ApiResponse<List<Map<String, dynamic>>>.fromJson(
        json,
        (data) => (data as List).cast<Map<String, dynamic>>(),
      );

      expect(response.success, true);
      expect(response.data, isNotNull);
      expect(response.data!.length, 2);
    });

    test('handles empty errors map', () {
      final json = {'success': false, 'message': 'Error', 'errors': {}};

      final response = ApiResponse<void>.fromJson(json, null);
      expect(response.success, false);
      expect(response.errors, isEmpty);
    });
  });
}

/// Simple mock for testing generic parsing
class _MockToken {

  _MockToken({required this.token, required this.tokenType});

  factory _MockToken.fromJson(Map<String, dynamic> json) =>
      _MockToken(token: json['token'] as String, tokenType: json['token_type'] as String? ?? 'Bearer');
  final String token;
  final String tokenType;
}
