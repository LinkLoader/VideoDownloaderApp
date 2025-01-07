import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_downloader/enums/platform.dart';

class PlatformDropdown extends StatelessWidget {
  final SocialPlatform selectedPlatform;
  final Function(SocialPlatform) onChanged;

  const PlatformDropdown({
    super.key,
    required this.selectedPlatform,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.black,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SocialPlatform>(
              value: selectedPlatform,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
                size: 28,
              ),
              dropdownColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              items: SocialPlatform.values.map((platform) {
                return DropdownMenuItem<SocialPlatform>(
                  value: platform,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 72,
                            height: 72,
                            padding: const EdgeInsets.all(8),
                            // child: Lottie.asset(
                            //   platform.platFormLottie,
                            //   fit: BoxFit.contain,
                            //   repeat: false,
                            // ),
                            child: Image.asset(
                              platform.platFormPng,
                              fit: BoxFit.cover,
                              width: 72,
                              height: 72,
                            )),
                        const SizedBox(width: 12),
                        Text(
                          platform.displayName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const Spacer(),
                        if (size.width > 500)
                          if (platform == selectedPlatform)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Selected',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (platform) {
                if (platform != null) {
                  onChanged(platform);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
