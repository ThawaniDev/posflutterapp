import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Verifies update packages using SHA-256 checksums.
class UpdateVerifierService {
  /// Verify a downloaded file against its expected SHA-256 checksum.
  /// Returns true if the file is valid.
  Future<bool> verifyChecksum({required String filePath, required String expectedChecksum}) async {
    final file = File(filePath);
    if (!await file.exists()) return false;

    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    final actualChecksum = digest.toString();

    return actualChecksum.toLowerCase() == expectedChecksum.toLowerCase();
  }

  /// Compute SHA-256 checksum for a file.
  Future<String> computeChecksum(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }

    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify file size matches expected size.
  Future<bool> verifyFileSize({required String filePath, required int expectedSizeBytes}) async {
    final file = File(filePath);
    if (!await file.exists()) return false;

    final actualSize = await file.length();
    return actualSize == expectedSizeBytes;
  }
}
