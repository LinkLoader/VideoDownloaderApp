import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/enums/platform.dart';
import 'dart:math';

import 'package:video_downloader/provider/download_provider.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  SocialPlatform? _selectedPlatform;
  final List<ParticleModel> particles = List.generate(
    15, // Reduced number of particles
    (index) => ParticleModel(
      position: Offset(
        Random().nextDouble() * 1200,
        Random().nextDouble() * 800,
      ),
      speed: Random().nextDouble() * 1.0 + 0.3, // Reduced speed range
      radius: Random().nextDouble() * 10 + 3, // Reduced size range
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.2), // Reduced opacity
    ),
  );

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Slowed down animation
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, provider, _) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth < 1200;

          // Simplified size calculations
          final cardWidth = isSmallScreen
              ? constraints.maxWidth * 0.85
              : isMediumScreen
                  ? 280.0
                  : 320.0;
          final cardHeight = isSmallScreen
              ? 400.0
              : isMediumScreen
                  ? 380.0
                  : 420.0;

          return Scaffold(
            body: Container(
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
              child: Stack(
                children: [
                  // Optimized background animation
                  if (!isSmallScreen) // Only show particles on larger screens
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _backgroundController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ParticlesPainter(
                              particles: particles,
                              animation: _backgroundController.value,
                            ),
                            size: Size.infinite,
                          );
                        },
                      ),
                    ),

                  // Reduced number of gradient overlays
                  if (!isSmallScreen)
                    ...List.generate(
                      2, // Reduced number of gradients
                      (index) => Positioned(
                        left: Random().nextDouble() * constraints.maxWidth,
                        top: Random().nextDouble() * constraints.maxHeight,
                        child: Container(
                          width: constraints.maxWidth * 0.15,
                          height: constraints.maxWidth * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    .withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .scale(
                              duration: const Duration(seconds: 3),
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.2, 1.2),
                            ),
                      ),
                    ),

                  // Main Content with RepaintBoundary
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.03),
                        RepaintBoundary(
                          child: Container(
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
                          ).animate().fadeIn().scale(),
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
                            // physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05,
                              vertical: isSmallScreen ? 10 : 0,
                            ),
                            child: Center(
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children:
                                    _buildPlatformCards(cardWidth, cardHeight),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildPlatformCards(double cardWidth, double cardHeight) {
    return SocialPlatform.values.map((platform) {
      return RepaintBoundary(
        child: AnimatedPlatformCard(
          platform: platform,
          isSelected: _selectedPlatform == platform,
          onSelected: () {
            setState(() => _selectedPlatform = platform);
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
              Provider.of<DownloadProvider>(context, listen: false)
                  .setSocialPlatform(platform);
              Navigator.of(context).pushNamed(
                '/requestScreen',
                arguments: platform,
              );
            }
          },
          cardWidth: cardWidth,
          cardHeight: cardHeight,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }
}

// AnimatedPlatformCard and other classes remain the same
class AnimatedPlatformCard extends StatefulWidget {
  final SocialPlatform platform;
  final bool isSelected;
  final VoidCallback onSelected;
  final double cardWidth;
  final double cardHeight;

  const AnimatedPlatformCard({
    super.key,
    required this.platform,
    required this.isSelected,
    required this.onSelected,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  _AnimatedPlatformCardState createState() => _AnimatedPlatformCardState();
}

class _AnimatedPlatformCardState extends State<AnimatedPlatformCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onSelected();
          },
          onTapCancel: () => _controller.reverse(),
          child: Container(
            width: widget.cardWidth,
            height: widget.cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.platform.platformColor.withOpacity(0.9),
                  widget.platform.platformColor.withOpacity(0.7),
                  Color.lerp(widget.platform.platformColor, Colors.black, 0.3)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.platform.platformColor.withOpacity(
                    widget.isSelected ? 0.8 : (_isHovered ? 0.6 : 0.4),
                  ),
                  blurRadius: widget.isSelected ? 30 : (_isHovered ? 25 : 15),
                  spreadRadius: widget.isSelected ? 4 : (_isHovered ? 3 : 2),
                ),
              ],
              border: widget.isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : Border.all(color: Colors.white30, width: 1),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomPaint(
                      painter: PatternPainter(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: widget.cardWidth * 0.8,
                        height: widget.cardHeight * 0.5,
                        child: Lottie.asset(
                          widget.platform.platFormLottie,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                      SizedBox(height: widget.cardHeight * 0.05),
                      Text(
                        widget.platform.displayName,
                        style: TextStyle(
                          fontSize: widget.cardWidth * 0.09,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(
                delay: Duration(
                  milliseconds:
                      (200 * SocialPlatform.values.indexOf(widget.platform)),
                ),
              )
              .slideX(
                begin: 0.2,
                end: 0,
                curve: Curves.easeOutQuad,
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ParticleModel, ParticlesPainter, and PatternPainter classes remain the same
// Add this new painter class for the card pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < size.width; i += 20) {
      for (var j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) => false;
}

// Update ParticleModel to include color
class ParticleModel {
  Offset position;
  double speed;
  double radius;
  Color color;

  ParticleModel({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

// Update ParticlesPainter to use particle colors
class ParticlesPainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animation;

  ParticlesPainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final offset = Offset(
        particle.position.dx,
        (particle.position.dy + (animation * particle.speed * size.height)) %
            size.height,
      );

      canvas.drawCircle(offset, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
