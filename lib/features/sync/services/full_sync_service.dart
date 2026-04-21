import 'dart:async';

import 'package:wameedpos/features/sync/data/remote/sync_api_service.dart';
import 'package:wameedpos/features/sync/services/data_integrity_service.dart';

/// Handles full data synchronization for initial setup or recovery.
/// Downloads all data from the server organized by category.
class FullSyncService {
  FullSyncService({required this.apiService, required this.integrityService});

  final SyncApiService apiService;
  final DataIntegrityService integrityService;

  bool _isSyncing = false;
  double _progress = 0.0;
  String _currentPhase = '';
  final _progressController = StreamController<FullSyncProgress>.broadcast();

  bool get isSyncing => _isSyncing;
  double get progress => _progress;
  String get currentPhase => _currentPhase;
  Stream<FullSyncProgress> get progressStream => _progressController.stream;

  /// Perform a full sync, downloading all data from the server.
  Future<FullSyncResult> performFullSync({required String terminalId}) async {
    if (_isSyncing) {
      return const FullSyncResult(success: false, error: 'Full sync already in progress');
    }

    _isSyncing = true;
    _progress = 0.0;
    final categories = <String, int>{};

    try {
      // Phase 1: Request full sync data
      _updateProgress(0.1, 'Requesting data from server...');
      final result = await apiService.fullSync(terminalId: terminalId);

      final data = result['data'] as Map<String, dynamic>? ?? {};
      final syncToken = result['sync_token'] as String?;
      final serverChecksum = result['checksum'] as String?;

      // Phase 2: Verify data integrity
      _updateProgress(0.3, 'Verifying data integrity...');
      if (serverChecksum != null) {
        // Flatten all data for checksum verification
        final allRecords = <Map<String, dynamic>>[];
        for (final category in data.values) {
          if (category is Map<String, dynamic>) {
            for (final records in category.values) {
              if (records is List) {
                allRecords.addAll(records.cast<Map<String, dynamic>>());
              }
            }
          }
        }

        final localChecksum = integrityService.computeChecksum(allRecords);
        if (localChecksum != serverChecksum) {
          _isSyncing = false;
          return const FullSyncResult(success: false, error: 'Data integrity check failed — checksum mismatch');
        }
      }

      // Phase 3: Process categories
      final totalCategories = data.keys.length;
      var processedCategories = 0;

      for (final entry in data.entries) {
        final categoryName = entry.key;
        final categoryData = entry.value;

        if (categoryData is Map<String, dynamic>) {
          var categoryRecords = 0;
          for (final tableRecords in categoryData.values) {
            if (tableRecords is List) {
              categoryRecords += tableRecords.length;
            }
          }
          categories[categoryName] = categoryRecords;
        }

        processedCategories++;
        final categoryProgress = 0.3 + (processedCategories / totalCategories) * 0.6;
        _updateProgress(categoryProgress, 'Processing $categoryName...');
      }

      // Phase 4: Complete
      _updateProgress(1.0, 'Sync complete');

      _isSyncing = false;
      return FullSyncResult(
        success: true,
        data: data,
        syncToken: syncToken,
        categoryCounts: categories,
        totalRecords: categories.values.fold(0, (sum, count) => sum + count),
      );
    } catch (e) {
      _isSyncing = false;
      _updateProgress(0.0, 'Sync failed');
      return FullSyncResult(success: false, error: e.toString());
    }
  }

  void _updateProgress(double value, String phase) {
    _progress = value;
    _currentPhase = phase;
    _progressController.add(FullSyncProgress(progress: value, phase: phase));
  }

  void dispose() {
    _progressController.close();
  }
}

class FullSyncProgress {

  const FullSyncProgress({required this.progress, required this.phase});
  final double progress;
  final String phase;
}

class FullSyncResult {

  const FullSyncResult({
    required this.success,
    this.error,
    this.data,
    this.syncToken,
    this.categoryCounts,
    this.totalRecords = 0,
  });
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;
  final String? syncToken;
  final Map<String, int>? categoryCounts;
  final int totalRecords;
}
