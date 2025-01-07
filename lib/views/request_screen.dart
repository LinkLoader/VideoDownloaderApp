import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:video_downloader/enums/platform.dart';
import 'package:video_downloader/provider/download_provider.dart';
import 'package:video_downloader/widgets/platform_dropdown.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  SocialPlatform _selectedPlatform = SocialPlatform.instagram;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF5F6FA),
                  Colors.blue.withOpacity(0.1),
                  Colors.purple.withOpacity(0.1),
                ],
              ),
            ),
          ),
          // Background patterns
          CustomPaint(
            size: Size.infinite,
            painter: BackgroundPatternPainter(),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () => Navigator.pop(context),
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Choose Download Type',
                        style: TextStyle(
                          color: Color(0xFF2D3436),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: PlatformDropdown(
                                  selectedPlatform: _selectedPlatform,
                                  onChanged: (platform) {
                                    setState(() {
                                      _selectedPlatform = platform;
                                      if (platform == SocialPlatform.youtube) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Coming Soon Stay Tuned'),
                                            backgroundColor: Colors.blue,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.all(10),
                                          ),
                                        );
                                      } else {
                                        Provider.of<DownloadProvider>(context,
                                                listen: false)
                                            .setSocialPlatform(platform);
                                        // Navigator.of(context).pushNamed(
                                        //   '/requestScreen',
                                        //   arguments: platform,
                                        // );
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          _buildAnimatedButton(
                              context,
                              'Download Video',
                              'High quality video downloads',
                              Icons.video_library,
                              const Color(0xFF4A90E2), () {
                            if (_selectedPlatform == SocialPlatform.youtube) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Coming Soon Stay Tuned'),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                ),
                              );
                            } else {
                              Provider.of<DownloadProvider>(context,
                                      listen: false)
                                  .setSocialPlatform(_selectedPlatform);
                              // Navigator.of(context).pushNamed(
                              //   '/requestScreen',
                              //   arguments: platform,
                              // );
                              Navigator.of(context).pushNamed(
                                '/downloadScreen',
                                arguments: 'Video',
                              );
                            }
                          }),
                          const SizedBox(height: 30),
                          _buildAnimatedButton(
                              context,
                              'Download Audio',
                              'Extract audio from videos',
                              Icons.audiotrack,
                              const Color(0xFF9B51E0), () {
                            if (_selectedPlatform == SocialPlatform.youtube) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Coming Soon Stay Tuned'),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                ),
                              );
                            } else {
                              Provider.of<DownloadProvider>(context,
                                      listen: false)
                                  .setSocialPlatform(_selectedPlatform);
                              // Navigator.of(context).pushNamed(
                              //   '/requestScreen',
                              //   arguments: platform,
                              // );
                              Navigator.of(context).pushNamed(
                                '/downloadScreen',
                                arguments: 'Audio',
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String title,
      String subtitle, IconData icon, Color color, VoidCallback onPressed) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(icon, color: color, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color.withOpacity(0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final random = math.Random(42);
    for (var i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 30 + 10;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
