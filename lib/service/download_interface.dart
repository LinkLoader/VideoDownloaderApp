abstract class DownloadInterface {
  Future<void> downloadFile(List<int> bytes, String fileName);
}
