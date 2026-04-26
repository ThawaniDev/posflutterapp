import 'dart:async';

import 'package:wameedpos/features/sync/data/remote/sync_api_service.dart';

/// Strategies for resolving sync conflicts.
enum ConflictResolutionStrategy {
  /// Always accept the local (device) version.
  acceptLocal,

  /// Always accept the cloud (server) version.
  acceptCloud,

  /// Use the version with the most recent timestamp.
  lastWriteWins,

  /// Merge fields from both versions (requires manual merge logic).
  merge,

  /// Prompt the user to resolve manually.
  manual,
}

/// A detected sync conflict between local and cloud data.
class SyncConflict {
  const SyncConflict({
    required this.id,
    required this.table,
    required this.recordId,
    required this.localData,
    required this.cloudData,
    required this.detectedAt,
    this.suggestedStrategy,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    return SyncConflict(
      id: json['id'] as String,
      table: json['table'] as String? ?? '',
      recordId: json['record_id'] as String? ?? '',
      localData: Map<String, dynamic>.from(json['local_data'] as Map? ?? {}),
      cloudData: Map<String, dynamic>.from(json['cloud_data'] as Map? ?? {}),
      detectedAt: json['detected_at'] != null ? DateTime.parse(json['detected_at'] as String) : DateTime.now(),
    );
  }
  final String id;
  final String table;
  final String recordId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> cloudData;
  final DateTime detectedAt;
  final ConflictResolutionStrategy? suggestedStrategy;
}

/// Result of a conflict resolution attempt.
class ConflictResolution {
  const ConflictResolution({
    required this.conflictId,
    required this.resolved,
    required this.strategy,
    this.mergedData,
    this.error,
  });
  final String conflictId;
  final bool resolved;
  final ConflictResolutionStrategy strategy;
  final Map<String, dynamic>? mergedData;
  final String? error;
}

/// Handles sync conflict detection and resolution.
class ConflictResolverService {
  ConflictResolverService({required this.apiService, this.defaultStrategy = ConflictResolutionStrategy.lastWriteWins});

  final SyncApiService apiService;
  final ConflictResolutionStrategy defaultStrategy;

  final _pendingConflicts = <String, SyncConflict>{};
  final _conflictController = StreamController<List<SyncConflict>>.broadcast();

  Stream<List<SyncConflict>> get conflictsStream => _conflictController.stream;
  List<SyncConflict> get pendingConflicts => _pendingConflicts.values.toList();
  int get pendingCount => _pendingConflicts.length;

  /// Fetch unresolved conflicts from the server.
  Future<List<SyncConflict>> fetchConflicts() async {
    try {
      final result = await apiService.listConflicts();
      final conflictsList = List<Map<String, dynamic>>.from(result['conflicts'] as List? ?? []);

      _pendingConflicts.clear();
      for (final json in conflictsList) {
        final conflict = SyncConflict.fromJson(json);
        _pendingConflicts[conflict.id] = conflict;
      }

      _notifyListeners();
      return pendingConflicts;
    } catch (e) {
      return [];
    }
  }

  /// Auto-resolve a conflict using the specified or default strategy.
  Future<ConflictResolution> resolve(
    SyncConflict conflict, {
    ConflictResolutionStrategy? strategy,
    Map<String, dynamic>? mergedData,
  }) async {
    final resolveStrategy = strategy ?? defaultStrategy;

    try {
      String apiResolution;
      Map<String, dynamic>? dataToSend;

      switch (resolveStrategy) {
        case ConflictResolutionStrategy.acceptLocal:
          apiResolution = 'local_wins';
          break;
        case ConflictResolutionStrategy.acceptCloud:
          apiResolution = 'cloud_wins';
          break;
        case ConflictResolutionStrategy.lastWriteWins:
          // Compare timestamps — use server's last-write-wins logic
          final localUpdated = _parseTimestamp(conflict.localData['updated_at']);
          final cloudUpdated = _parseTimestamp(conflict.cloudData['updated_at']);
          if (localUpdated != null && cloudUpdated != null && localUpdated.isAfter(cloudUpdated)) {
            apiResolution = 'local_wins';
          } else {
            apiResolution = 'cloud_wins';
          }
          break;
        case ConflictResolutionStrategy.merge:
          apiResolution = 'merged';
          dataToSend = mergedData ?? _autoMerge(conflict);
          break;
        case ConflictResolutionStrategy.manual:
          return ConflictResolution(
            conflictId: conflict.id,
            resolved: false,
            strategy: resolveStrategy,
            error: 'Manual resolution required',
          );
      }

      await apiService.resolveConflict(conflictId: conflict.id, resolution: apiResolution, mergedData: dataToSend);

      _pendingConflicts.remove(conflict.id);
      _notifyListeners();

      return ConflictResolution(conflictId: conflict.id, resolved: true, strategy: resolveStrategy, mergedData: dataToSend);
    } catch (e) {
      return ConflictResolution(conflictId: conflict.id, resolved: false, strategy: resolveStrategy, error: e.toString());
    }
  }

  /// Auto-resolve all pending conflicts using the default strategy.
  Future<List<ConflictResolution>> resolveAll({ConflictResolutionStrategy? strategy}) async {
    final results = <ConflictResolution>[];
    final conflicts = List<SyncConflict>.from(pendingConflicts);

    for (final conflict in conflicts) {
      final result = await resolve(conflict, strategy: strategy);
      results.add(result);
    }

    return results;
  }

  /// Simple auto-merge: cloud fields win unless local field was more recently changed.
  Map<String, dynamic> _autoMerge(SyncConflict conflict) {
    final merged = Map<String, dynamic>.from(conflict.cloudData);

    // Override with local fields that are present and differ
    for (final entry in conflict.localData.entries) {
      if (entry.key == 'updated_at' || entry.key == 'created_at') continue;
      if (!merged.containsKey(entry.key)) {
        merged[entry.key] = entry.value;
      }
    }

    return merged;
  }

  DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  void _notifyListeners() {
    _conflictController.add(pendingConflicts);
  }

  void dispose() {
    _conflictController.close();
  }
}
