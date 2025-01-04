import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/app/routes/app_routes.dart';

import 'package:google_fonts/google_fonts.dart';
import 'provider/download_provider.dart';

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
      title: 'LinkLoader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: const RequestScreen(),
      // routes: {
      //   // AppRoutes.homeScreen: (_) => const HomeScreen(),
      //   AppRoutes.selectionScreen: (_) => const SelectionScreen(),
      //   AppRoutes.requestScreen: (_) => const RequestScreen(),
      // },
      initialRoute: AppRoutes.homeScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
