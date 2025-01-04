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
    30,
    (index) => ParticleModel(
      position: Offset(
        Random().nextDouble() * 1200,
        Random().nextDouble() * 800,
      ),
      speed: Random().nextDouble() * 1.5 + 0.5,
      radius: Random().nextDouble() * 15 + 5,
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.3),
    ),
  );

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, provider, _) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we're on a small screen
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth < 1200;

          // Calculate dynamic sizes based on screen width
          final titleFontSize = isSmallScreen ? 24.0 : 36.0;
          final subtitleFontSize = isSmallScreen ? 14.0 : 16.0;
          final cardWidth = isSmallScreen
              ? constraints.maxWidth * 0.8
              : isMediumScreen
                  ? 250.0
                  : 300.0;
          final cardHeight = isSmallScreen
              ? constraints.maxHeight * 0.5
              : isMediumScreen
                  ? 350.0
                  : 400.0;

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF1A1A2E),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated Background
                  AnimatedBuilder(
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

                  // Colorful Gradients
                  ...List.generate(
                    3,
                    (index) => Positioned(
                      left: Random().nextDouble() * constraints.maxWidth,
                      top: Random().nextDouble() * constraints.maxHeight,
                      child: Container(
                        width: constraints.maxWidth * 0.2,
                        height: constraints.maxWidth * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(
                            duration: Duration(seconds: 2 + index),
                            begin: const Offset(0, 1),
                            end: const Offset(0, 1.5),
                          )
                          .then()
                          .scale(
                            duration: Duration(seconds: 2 + index),
                            begin: const Offset(0, 1.5),
                            end: const Offset(0, 1),
                          ),
                    ),
                  ),

                  // Main Content
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.05),
                        // Animated Title
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.2),
                                Colors.purple.withOpacity(0.2),
                              ],
                            ),
                          ),
                          child: Text(
                            'Choose Platform',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 28 : 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn()
                            .scale(delay: 200.ms)
                            .shimmer(duration: 1200.ms),

                        SizedBox(height: constraints.maxHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.05,
                          ),
                          child: Text(
                            'Choose your preferred social platform to continue',
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ).animate().fadeIn().slideY(begin: -0.2, end: 0),

                        SizedBox(height: constraints.maxHeight * 0.04),
                        Expanded(
                          child: Center(
                            child: LayoutBuilder(
                              builder: (context, cardConstraints) {
                                return SingleChildScrollView(
                                  scrollDirection: isSmallScreen
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.05,
                                    vertical: isSmallScreen ? 20 : 0,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  child: isSmallScreen
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _buildPlatformCards(
                                              cardWidth, cardHeight),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _buildPlatformCards(
                                              cardWidth, cardHeight),
                                        ),
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          height: constraints.maxHeight * 0.1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.blue.withOpacity(0.1),
                              ],
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
      return Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedPlatformCard(
          platform: platform,
          isSelected: _selectedPlatform == platform,
          onSelected: () {
            setState(() => _selectedPlatform = platform);
            Provider.of<DownloadProvider>(context, listen: false)
                .setSocialPlatform(platform);
            Navigator.of(context).pushNamed(
              '/requestScreen',
              arguments: platform,
            );
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
