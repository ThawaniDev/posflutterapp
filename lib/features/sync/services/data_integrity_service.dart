import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Provides SHA-256 checksum computation for sync payloads
/// to verify data integrity during transfer.
class DataIntegrityService {
  /// Compute a SHA-256 checksum for a list of records.
  /// Records are sorted by key and serialized to JSON for deterministic output.
  String computeChecksum(List<Map<String, dynamic>> records) {
    final normalized = _normalizeRecords(records);
    final json = jsonEncode(normalized);
    final bytes = utf8.encode(json);
    return sha256.convert(bytes).toString();
  }

  /// Compute a checksum for a single record.
  String computeRecordChecksum(Map<String, dynamic> record) {
    final sorted = _sortMap(record);
    final json = jsonEncode(sorted);
    final bytes = utf8.encode(json);
    return sha256.convert(bytes).toString();
  }

  /// Verify a payload against an expected checksum.
  bool verifyChecksum(List<Map<String, dynamic>> records, String expectedChecksum) {
    return computeChecksum(records) == expectedChecksum;
  }

  /// Verify a single record against an expected checksum.
  bool verifyRecordChecksum(Map<String, dynamic> record, String expectedChecksum) {
    return computeRecordChecksum(record) == expectedChecksum;
  }

  /// Normalize records for deterministic JSON output.
  List<Map<String, dynamic>> _normalizeRecords(List<Map<String, dynamic>> records) {
    final sorted = records.map(_sortMap).toList();
    // Sort by 'id' field if present for consistent ordering
    sorted.sort((a, b) {
      final aId = a['id']?.toString() ?? '';
      final bId = b['id']?.toString() ?? '';
      return aId.compareTo(bId);
    });
    return sorted;
  }

  /// Recursively sort map keys for deterministic serialization.
  Map<String, dynamic> _sortMap(Map<String, dynamic> map) {
    final sorted = <String, dynamic>{};
    final keys = map.keys.toList()..sort();
    for (final key in keys) {
      final value = map[key];
      if (value is Map<String, dynamic>) {
        sorted[key] = _sortMap(value);
      } else if (value is List) {
        sorted[key] = value.map((item) {
          if (item is Map<String, dynamic>) return _sortMap(item);
          return item;
        }).toList();
      } else {
        sorted[key] = value;
      }
    }
    return sorted;
  }
}
