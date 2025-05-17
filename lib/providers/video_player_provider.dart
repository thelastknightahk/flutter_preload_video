import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProvider extends ChangeNotifier {
  final List<String> videoUrls = [
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"
  ];

  late List<VideoPlayerController?> _controllers;
  final Map<int, bool> _initializedVideos = {};
  int _currentIndex = 0;

  List<VideoPlayerController?> get controllers => _controllers;
  int get currentIndex => _currentIndex;
  Map<int, bool> get initializedVideos => _initializedVideos;

  VideoPlayerProvider() {
    _controllers = List<VideoPlayerController?>.filled(videoUrls.length, null);
    _initializeCurrentAndAdjacentVideos();
  }

  Future<void> _initializeCurrentAndAdjacentVideos() async {
    await initializeController(_currentIndex);
    if (_controllers[_currentIndex] != null) {
      await _controllers[_currentIndex]!.play();
    }
    
    // Preload adjacent videos
    if (_currentIndex + 1 < videoUrls.length) {
      initializeController(_currentIndex + 1);
    }
  }

  Future<void> initializeController(int index) async {
    if (index < 0 || index >= videoUrls.length) return;
    
    // Skip if already initialized
    if (_initializedVideos[index] == true) return;
    
    // Create controller if needed
    if (_controllers[index] == null) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrls[index]));
      _controllers[index] = controller;
      
      try {
        await controller.initialize();
        await controller.setLooping(true);
        
        // Mark as initialized
        _initializedVideos[index] = true;
        notifyListeners();
      } catch (e) {
        debugPrint('Error initializing video at index $index: $e');
        _initializedVideos[index] = false;
      }
    }
  }

  Future<void> changeVideo(int newIndex) async {
    if (newIndex == _currentIndex) return;
    
    // Pause the current video
    if (_currentIndex >= 0 && _currentIndex < _controllers.length && 
        _controllers[_currentIndex]?.value.isInitialized == true) {
      await _controllers[_currentIndex]?.pause();
    }
    
    // Initialize the new video if needed
    await initializeController(newIndex);
    
    // Play the new video
    if (_controllers[newIndex]?.value.isInitialized == true) {
      await _controllers[newIndex]?.play();
    }
    
    // Preload adjacent videos
    if (newIndex + 1 < videoUrls.length) {
      initializeController(newIndex + 1);
    }
    if (newIndex - 1 >= 0) {
      initializeController(newIndex - 1);
    }
    
    _currentIndex = newIndex;
    notifyListeners();
  }

  void togglePlayPause(int index) {
    if (index < 0 || index >= _controllers.length) return;
    
    final controller = _controllers[index];
    if (controller == null || !controller.value.isInitialized) return;
    
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }
}
