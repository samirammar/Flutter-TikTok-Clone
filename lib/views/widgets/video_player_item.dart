import 'package:flutter/material.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String url;
  const VideoPlayerItem({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        _videoPlayerController.play();
        _videoPlayerController.setVolume(1);
        _videoPlayerController.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: AppColors.black),
      child: VideoPlayer(_videoPlayerController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
