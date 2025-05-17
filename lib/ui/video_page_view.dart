import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/video_player_provider.dart';
import 'widgets/video_player_item.dart';

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
