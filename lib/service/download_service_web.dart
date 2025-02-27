import 'dart:html' as html;
import 'download_interface.dart';

class DownloadServiceWeb implements DownloadInterface {
  @override
  Future<void> downloadFile(List<int> bytes, String fileName) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
