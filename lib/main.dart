import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/app/routes/app_routes.dart';

import 'provider/download_provider.dart';
import 'views/request_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DownloadProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Download Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: const RequestScreen(),
      initialRoute: AppRoutes.homeScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
