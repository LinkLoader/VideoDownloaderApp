import 'dart:convert';
import 'dart:html' as html; // Add this import for web functionality
import 'dart:io'; // Use platform-specific imports

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static const String endPoint = "https://flask-backend-3uod.onrender.com/";
  static const String videoEndpointInsta = "${endPoint}download_video_insta";
  static const String audioEndpointInsta = "${endPoint}download_audio_insta";

  Future<String?> downloadFileInsta(String type, String url) async {
    try {
      final endpoint =
          type == 'Video' ? videoEndpointInsta : audioEndpointInsta;
      final extension = type == 'Video' ? 'mp4' : 'mp3';
      final apiUrl = Uri.parse(endpoint);

      final response = await http.post(
        apiUrl,
        headers: {
          // HttpHeaders.contentTypeHeader: 'application/json',
          "Content-type": "application/json"
        },
        body: jsonEncode({"url": url}),
      );

      if (response.statusCode == 200) {
        // String filePath;
        if (kIsWeb) {
          // For Web: Create a Blob and trigger the download
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download =
                'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
          anchor.click();
          html.Url.revokeObjectUrl(url); // Cleanup the URL
          return "downloaded"; // Return null as file is downloaded in the browser
        } else {
          // For Mobile (Android/iOS), use path_provider
          final directory = await getApplicationDocumentsDirectory();
          final fileName =
              'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
          final filePath = '${directory.path}/$fileName';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes); // Write the file locally

          return filePath;
        }
      }
      return null;
      //   final directory = await getApplicationDocumentsDirectory();
      //   final fileName =
      //       'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
      //   final filePath = '${directory.path}/$fileName';

      //   final file = File(filePath);
      //   await file.writeAsBytes(response.bodyBytes);

      //   return filePath;
      // }
      // return null;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  static const String videoEndpoint = "${endPoint}download_video";
  static const String audioEndpoint = "${endPoint}download_audio";

  Future<String?> downloadFile(String type, String url) async {
    try {
      final endpoint = type == 'Video' ? videoEndpoint : audioEndpoint;
      final extension = type == 'Video' ? 'mp4' : 'mp3';
      final apiUrl = Uri.parse(endpoint);

      final response = await http.post(
        apiUrl,
        headers: {
          // HttpHeaders.contentTypeHeader: 'application/json',
          "Content-type": "application/json"
        },
        body: jsonEncode({"url": url}),
      );

      if (response.statusCode == 200) {
        // String filePath;
        if (kIsWeb) {
          // For Web: Create a Blob and trigger the download
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download =
                'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
          anchor.click();
          html.Url.revokeObjectUrl(url); // Cleanup the URL
          return "downloaded"; // Return null as file is downloaded in the browser
        } else {
          // For Mobile (Android/iOS), use path_provider
          final directory = await getApplicationDocumentsDirectory();
          final fileName =
              'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
          final filePath = '${directory.path}/$fileName';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes); // Write the file locally

          return filePath;
        }
      }
      return null;
      //   final directory = await getApplicationDocumentsDirectory();
      //   final fileName =
      //       'download_${DateTime.now().millisecondsSinceEpoch}.$extension';
      //   final filePath = '${directory.path}/$fileName';

      //   final file = File(filePath);
      //   await file.writeAsBytes(response.bodyBytes);

      //   return filePath;
      // }
      // return null;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }
}
