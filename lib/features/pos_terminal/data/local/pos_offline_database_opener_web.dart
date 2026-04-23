import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

/// Web (Chrome/Edge) opener — uses sqlite3 compiled to WebAssembly with
/// IndexedDB-backed persistence. Requires `sqlite3.wasm` and the drift
/// service worker to be served from the web build (see `web/` assets).
QueryExecutor openPosOfflineConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'wameedpos_offline',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      debugPrint(
        '[PosOfflineDatabase] WASM opened with reduced features: '
        '${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
