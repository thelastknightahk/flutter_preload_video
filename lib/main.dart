import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/video_player_provider.dart';
import 'ui/video_feed_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => VideoPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Preloading Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VideoFeedScreen(),
    );
  }
}