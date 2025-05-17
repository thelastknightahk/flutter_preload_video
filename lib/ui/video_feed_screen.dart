import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/video_player_provider.dart';
import 'video_page_view.dart';

class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VideoPlayerProvider>(
        builder: (context, videoProvider, _) {
          return VideoPageView(
            onPageChanged: videoProvider.changeVideo,
          );
        },
      ),
    );
  }
}