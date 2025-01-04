import 'package:flutter/material.dart';
import 'package:video_downloader/service/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();

  bool _isLoading = false;
  String? _lastDownloadedPath;
  String? _error;

  bool get isLoading => _isLoading;
  String? get lastDownloadedPath => _lastDownloadedPath;
  String? get error => _error;

  Future<bool> downloadContent(String type, String url) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final filePath = await _downloadService.downloadFile(type, url);

      if (filePath != null) {
        _lastDownloadedPath = filePath;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Download failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
