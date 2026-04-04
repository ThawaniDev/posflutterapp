import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads update packages with progress tracking and resume support.
class UpdateDownloaderService {
  UpdateDownloaderService(this._dio);

  final Dio _dio;

  bool _isDownloading = false;
  double _progress = 0.0;
  CancelToken? _cancelToken;
  String? _downloadedFilePath;

  bool get isDownloading => _isDownloading;
  double get progress => _progress;
  String? get downloadedFilePath => _downloadedFilePath;

  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  /// Download an update binary from [url].
  /// Returns the local file path of the downloaded file.
  Future<String> download({required String url, required String version, bool throttle = false}) async {
    if (_isDownloading) {
      throw StateError('Download already in progress');
    }

    _isDownloading = true;
    _progress = 0.0;
    _cancelToken = CancelToken();
    _downloadedFilePath = null;

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'pos_update_$version.msix';
      final filePath = '${tempDir.path}/$fileName';

      await _dio.download(
        url,
        filePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _progress = received / total;
            _progressController.add(_progress);
          }
        },
      );

      _downloadedFilePath = filePath;
      _progress = 1.0;
      _progressController.add(1.0);
      return filePath;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        rethrow;
      }
      rethrow;
    } finally {
      _isDownloading = false;
    }
  }

  /// Cancel an in-progress download.
  void cancel() {
    _cancelToken?.cancel('User cancelled download');
    _isDownloading = false;
    _progress = 0.0;
  }

  /// Clean up downloaded files.
  Future<void> cleanupDownloads() async {
    if (_downloadedFilePath != null) {
      final file = File(_downloadedFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
      _downloadedFilePath = null;
    }
  }

  void dispose() {
    cancel();
    _progressController.close();
  }
}
