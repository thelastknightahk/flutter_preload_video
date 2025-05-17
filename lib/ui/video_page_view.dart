import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/video_player_provider.dart';

class VideoPageView extends StatefulWidget {
  final Function(int) onPageChanged;
  
  const VideoPageView({
    super.key, 
    required this.onPageChanged,
  });

  @override
  State<VideoPageView> createState() => _VideoPageViewState();
}

class _VideoPageViewState extends State<VideoPageView> {
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handlePageChange);
  }
  
  void _handlePageChange() {
    final newIndex = _pageController.page?.round() ?? 0;
    final currentProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    
    if (newIndex != currentProvider.currentIndex) {
      widget.onPageChanged(newIndex);
    }
  }
  
  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoPlayerProvider>(context);
    
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videoProvider.videoUrls.length,
      itemBuilder: (context, index) => VideoPlayerItem(index: index),
    );
  }
}

class VideoPlayerItem extends StatelessWidget {
  final int index;
  
  const VideoPlayerItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoPlayerProvider>(context);
    final controller = videoProvider.controllers[index];
    
    // Show loading indicator if controller is not ready
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading video...'),
          ],
        ),
      );
    }
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        GestureDetector(
          onTap: () => videoProvider.togglePlayPause(index),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        
        // Play/pause indicator overlay
        if (!controller.value.isPlaying)
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 80,
              color: Colors.white70,
            ),
          ),
        
        // Video index indicator
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Video ${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}