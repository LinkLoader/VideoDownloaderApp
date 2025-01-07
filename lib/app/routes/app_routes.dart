import 'package:flutter/material.dart';
import 'package:video_downloader/views/download_screen.dart';
import 'package:video_downloader/views/home_screen.dart';
import 'package:video_downloader/views/platform_selector.dart';
import 'package:video_downloader/views/request_screen.dart';
import 'package:video_downloader/views/social_platform.dart';

class AppRoutes {
  // Define all route names here
  static const String homeScreen = '/homeScreen';
  static const String requestScreen = '/requestScreen';
  static const String downloadScreen = '/downloadScreen';
  static const String selectionScreen = '/selectionScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case requestScreen:
        return MaterialPageRoute(builder: (_) => const RequestScreen());
      case downloadScreen:
        return MaterialPageRoute(
            builder: (_) => DownloadScreen(
                  type: settings.arguments.toString(),
                ));
      case selectionScreen:
        return MaterialPageRoute(
            builder: (_) => const PlatformSelectionScreen());

      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }

  // Handle undefined routes
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("No route found!")),
      ),
    );
  }
}
