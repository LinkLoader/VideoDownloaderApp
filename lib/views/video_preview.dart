// // video_preview_screen.dart
// import 'package:flutter/material.dart';
// import 'package:video_downloader/provider/download_provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';

// class VideoPreviewScreen extends StatefulWidget {
//   const VideoPreviewScreen({super.key});

//   @override
//   State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
// }

// class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
//   VideoPlayerController? _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     final downloadProvider = context.read<DownloadProvider>();
//     final videoPath = downloadProvider.lastDownloadedPath;

//     if (videoPath != null) {
//       _controller = VideoPlayerController.file(File(videoPath));

//       try {
//         await _controller!.initialize();
//         setState(() {
//           _isInitialized = true;
//         });
//         _controller!.setLooping(true);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Error loading video'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.blue),
//         title: const Text(
//           'Video Preview',
//           style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.2),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: _isInitialized
//                     ? Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           AspectRatio(
//                             aspectRatio: _controller!.value.aspectRatio,
//                             child: VideoPlayer(_controller!),
//                           ),
//                           _PlayPauseOverlay(controller: _controller!),
//                         ],
//                       )
//                     : const Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.blue,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (_isInitialized)
//               _VideoProgressIndicator(controller: _controller!),
//             const SizedBox(height: 24),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 10,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.video_library,
//                     color: Colors.blue,
//                     size: 20,
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     'Video Preview',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }

// class _PlayPauseOverlay extends StatelessWidget {
//   final VideoPlayerController controller;

//   const _PlayPauseOverlay({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? const SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 50.0,
//                       semanticLabel: 'Play',
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//       ],
//     );
//   }
// }

// class _VideoProgressIndicator extends StatelessWidget {
//   final VideoPlayerController controller;

//   const _VideoProgressIndicator({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       child: VideoProgressIndicator(
//         controller,
//         allowScrubbing: true,
//         colors: const VideoProgressColors(
//           playedColor: Colors.blue,
//           bufferedColor: Color(0x22000000),
//           backgroundColor: Color(0x44000000),
//         ),
//       ),
//     );
//   }
// }
