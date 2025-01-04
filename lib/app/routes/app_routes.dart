import 'package:flutter/material.dart';
import 'package:video_downloader/views/download_screen.dart';
import 'package:video_downloader/views/home_screen.dart';
import 'package:video_downloader/views/request_screen.dart';

class AppRoutes {
  // Define all route names here
  static const String homeScreen = '/homeScreen';
  static const String requestScreen = '/requestScreen';
  static const String downloadScreen = '/downloadScreen';

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

      default:
        return _errorRoute();
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
