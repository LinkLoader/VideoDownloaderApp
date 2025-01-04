import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/provider/download_provider.dart';

class DownloadScreen extends StatefulWidget {
  final String type;
  const DownloadScreen({super.key, required this.type});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = widget.type == 'Video'
        ? const Color(0xFF4A90E2)
        : const Color(0xFF9B51E0);
    String hint = widget.type == 'Video'
        ? 'Enter video URL to download'
        : 'Enter video URL to extract audio';

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  themeColor.withOpacity(0.05),
                  themeColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
          // Background pattern
          CustomPaint(
            size: Size.infinite,
            painter: BackgroundPatternPainter(color: themeColor),
          ),
          // Main content
          SafeArea(
            child: Consumer<DownloadProvider>(
              builder: (context, provider, child) {
                if (provider.error != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.error!),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                    provider.clearError();
                  });
                }

                return Column(
                  children: [
                    // Custom AppBar
                    Container(
                      padding: const EdgeInsets.all(20),
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
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  size: 20),
                              onPressed: () => Navigator.pop(context),
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${widget.type} Download',
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Main content area
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeColor.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Icon and title
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color:
                                                    themeColor.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                widget.type == 'Video'
                                                    ? Icons.video_library
                                                    : Icons.audiotrack,
                                                color: themeColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              'Enter URL',
                                              style: TextStyle(
                                                color: themeColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 25),
                                        // URL Input field
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _urlController,
                                            decoration: InputDecoration(
                                              hintText: hint,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              prefixIcon: Icon(
                                                Icons.link,
                                                color: themeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        // Download button
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: provider.isLoading
                                                ? null
                                                : () async {
                                                    if (_urlController
                                                        .text.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                              'Please enter a URL'),
                                                          backgroundColor:
                                                              Colors.red,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    final success =
                                                        await provider
                                                            .downloadContent(
                                                      widget.type,
                                                      _urlController.text,
                                                    );

                                                    if (success && mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              '${widget.type} downloaded successfully!'),
                                                          backgroundColor:
                                                              themeColor,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                      );
                                                    }
                                                  },
                                            child: Container(
                                              width: double.infinity,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    themeColor,
                                                    themeColor.withOpacity(0.8)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: themeColor
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: provider.isLoading
                                                    ? const SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            widget.type ==
                                                                    'Video'
                                                                ? Icons.download
                                                                : Icons
                                                                    .music_note,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            'Download ${widget.type}',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 10; j++) {
        final x = (size.width / 10) * i;
        final y = (size.height / 10) * j;

        canvas.drawCircle(
          Offset(x, y),
          20 * (((i + j) % 3) + 1),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
