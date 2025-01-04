import 'package:flutter/material.dart';
import 'package:video_downloader/enums/platform.dart';
import 'package:video_downloader/service/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  SocialPlatform socialPlatform = SocialPlatform.youtube;

  void setSocialPlatform(SocialPlatform platform) {
    socialPlatform = platform;
    notifyListeners();
  }

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

      // final filePath = await _downloadService.downloadFileInsta(type, url);
      final filePath = await getFilePath(type, url);
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

  Future<String?> getFilePath(String type, String url) {
    switch (socialPlatform) {
      case SocialPlatform.instagram:
        return _downloadService.downloadFileInsta(type, url);
      case SocialPlatform.twitter:
        return _downloadService.downloadFile(type, url);
      case SocialPlatform.youtube:
        return _downloadService.downloadFile(type, url);
      default:
        throw UnsupportedError('The social platform is not supported');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
