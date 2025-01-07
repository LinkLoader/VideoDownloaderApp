import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/enums/platform.dart';
import 'package:video_downloader/provider/download_provider.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, provider, _) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth < 1200;
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          final cardWidth = isLandscape
              ? constraints.maxHeight * 0.4
              : isSmallScreen
                  ? constraints.maxWidth * 0.85
                  : isMediumScreen
                      ? 280.0
                      : 320.0;

          final cardHeight = isLandscape
              ? constraints.maxHeight * 0.8
              : isSmallScreen
                  ? 240.0
                  : isMediumScreen
                      ? 250.0
                      : 300.0;

          return Scaffold(
            body: Stack(
              children: [
                // Base gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                      ],
                    ),
                  ),
                ),

                // Background pattern
                CustomPaint(
                  painter: BackgroundPatternPainter(),
                  size: Size.infinite,
                ),

                // Content
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: Text(
                          'Choose Platform',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        child: Text(
                          'Choose your preferred social platform to continue',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.05,
                            vertical: isSmallScreen ? 10 : 0,
                          ),
                          child: Center(
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: SocialPlatform.values.map((platform) {
                                return PlatformCard(
                                  platform: platform,
                                  cardWidth: cardWidth,
                                  cardHeight: cardHeight,
                                );
                              }).toList(),
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
        },
      );
    });
  }
}

// Background pattern painter
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw subtle diagonal lines
    const spacing = 40.0;
    for (double i = -size.width; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw subtle dots
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) => false;
}

class PlatformCard extends StatelessWidget {
  final SocialPlatform platform;
  final double cardWidth;
  final double cardHeight;

  const PlatformCard({
    super.key,
    required this.platform,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (platform == SocialPlatform.youtube) {
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
          Provider.of<DownloadProvider>(context, listen: false)
              .setSocialPlatform(platform);
          Navigator.of(context).pushNamed(
            '/requestScreen',
            arguments: platform,
          );
        }
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              platform.platformColor.withOpacity(0.9),
              platform.platformColor.withOpacity(0.7),
              Color.lerp(platform.platformColor, Colors.black, 0.3)!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: platform.platformColor.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white30, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              platform.platFormLottie,
              width: cardWidth * 0.8,
              height: cardHeight * 0.8,
              fit: BoxFit.contain,
            ),
            Text(
              platform.displayName,
              style: TextStyle(
                fontSize: cardWidth * 0.09,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
