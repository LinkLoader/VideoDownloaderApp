// lib/download_service_mobile.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'download_interface.dart';

class DownloadServiceMobile implements DownloadInterface {
  @override
  Future<void> downloadFile(List<int> bytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
  }
}
