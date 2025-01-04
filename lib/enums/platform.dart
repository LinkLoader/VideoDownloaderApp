import 'package:flutter/material.dart';

enum SocialPlatform {
  instagram,
  youtube,
  twitter;

  String get displayName {
    switch (this) {
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.youtube:
        return 'YouTube';
      case SocialPlatform.twitter:
        return 'Twitter';
    }
  }

  Color get platformColor {
    switch (this) {
      case SocialPlatform.instagram:
        // return Colors.pinkAccent;
        return Colors.black.withOpacity(0.6);
      case SocialPlatform.youtube:
        // return Colors.red;
        return Colors.black.withOpacity(0.6);
      case SocialPlatform.twitter:
        // return Colors.blue;
        return Colors.black.withOpacity(0.6);
    }
  }

  IconData get platformIcon {
    switch (this) {
      case SocialPlatform.instagram:
        return Icons.camera_alt;
      case SocialPlatform.youtube:
        return Icons.play_arrow;
      case SocialPlatform.twitter:
        return Icons.chat_bubble;
    }
  }

  String get platFormLottie {
    switch (this) {
      case SocialPlatform.instagram:
        return "assets/lottie/instagram.json";
      case SocialPlatform.youtube:
        return "assets/lottie/youtube.json";
      case SocialPlatform.twitter:
        return "assets/lottie/twitter.json";
    }
  }
}
