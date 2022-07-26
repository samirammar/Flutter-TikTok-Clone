import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/controllers/upload_video_controller.dart';
import 'package:tiktok/views/widgets/text_input.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File video;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.video,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  late UploadVideoController _uploadVideoController;

  @override
  void initState() {
    super.initState();
    _uploadVideoController = Get.put(UploadVideoController());
    _videoPlayerController = VideoPlayerController.file(widget.video);
    _videoPlayerController.initialize();
    _videoPlayerController.play();
    _videoPlayerController.setVolume(1);
    _videoPlayerController.setLooping(true);
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(_videoPlayerController),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInput(
                      icon: Icons.music_note,
                      label: 'Song Name',
                      controller: _songController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInput(
                      icon: Icons.closed_caption,
                      label: 'Caption',
                      controller: _captionController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            _uploadVideoController
                                .uploadVideo(_songController.text,
                                    _captionController.text, widget.videoPath)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _captionController.dispose();
    _songController.dispose();
    super.dispose();
  }
}
