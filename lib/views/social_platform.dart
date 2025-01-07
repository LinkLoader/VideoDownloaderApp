import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_downloader/enums/platform.dart';
import 'package:video_downloader/provider/download_provider.dart';

class PlatformSelectionScreen extends StatefulWidget {
  const PlatformSelectionScreen({super.key});

  @override
  State<PlatformSelectionScreen> createState() =>
      _PlatformSelectionScreenState();
}

class _PlatformSelectionScreenState extends State<PlatformSelectionScreen> {
  SocialPlatform? selectedPlatform;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Choose Platform',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Choose your preferred platform from above to proceed with the download',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: SocialPlatform.values.map((platform) {
                        return SizedBox(
                          width: 160, // Fixed width for each card
                          child: _PlatformCard(
                            platform: platform,
                            isSelected: selectedPlatform == platform,
                            onSelect: () {
                              setState(() {
                                selectedPlatform = platform;

                                if (selectedPlatform ==
                                    SocialPlatform.youtube) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Coming Soon Stay Tuned'),
                                      backgroundColor: Colors.blue,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(10),
                                    ),
                                  );
                                } else {
                                  provider.setSocialPlatform(platform);
                                  Navigator.of(context).pushNamed(
                                    '/requestScreen',
                                    arguments: platform,
                                  );
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildDownloadSection(),
          ],
        ),
      );
    });
  }

  Widget _buildDownloadSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedPlatform != null
                ? 'Download ${selectedPlatform!.displayName} Content'
                : 'Select a platform to continue',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final SocialPlatform platform;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PlatformCard({
    super.key,
    required this.platform,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? platform.platformColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Lottie.asset(
                  platform.platFormLottie,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 12),
              Icon(
                platform.platformIcon,
                size: 28,
                color: platform.platformColor,
              ),
              const SizedBox(height: 8),
              Text(
                platform.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: platform.platformColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: platform.platformColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Selected',
                    style: TextStyle(
                      fontSize: 12,
                      color: platform.platformColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
