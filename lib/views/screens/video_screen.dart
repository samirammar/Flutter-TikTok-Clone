import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/controllers/video_controller.dart';
import 'package:tiktok/models/video.dart';
import 'package:tiktok/views/screens/comment_screen.dart';
import 'package:tiktok/views/widgets/circle_animation.dart';
import 'package:tiktok/views/widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);
  // Video Controller
  final VideoController _videoController = Get.put(VideoController());

  // Profile Image Widget
  Widget buildProfile(String profile) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  profile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.grey, AppColors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                profilePhoto,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PageView.builder(
        itemCount: _videoController.videoList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Video video = _videoController.videoList[index];
          return Stack(
            children: [
              VideoPlayerItem(url: video.videoUrl),
              Column(
                children: [
                  const SizedBox(height: 100),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  video.userName,
                                  style: TextStyle(
                                    fontSize: FontSize.s20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  video.caption,
                                  style: TextStyle(
                                    fontSize: FontSize.s15,
                                    color: AppColors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      size: FontSize.s15,
                                      color: AppColors.white,
                                    ),
                                    Text(
                                      video.songName,
                                      style: TextStyle(
                                        fontSize: FontSize.s15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildProfile(video.profilePhoto),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _videoController.likeVideo(video.id),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 40,
                                      color: video.likes
                                              .contains(authController.user.uid)
                                          ? AppColors.red
                                          : AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    '${video.likes.length} likes',
                                    style: TextStyle(
                                      fontSize: FontSize.s20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommentScreen(videoId: video.id),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.comment,
                                      size: 40,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    video.commentsCount.toString(),
                                    style: TextStyle(
                                      fontSize: FontSize.s20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _videoController.shareVideo(video),
                                    child: Icon(
                                      Icons.replay,
                                      size: 40,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    video.shareCount.toString(),
                                    style: TextStyle(
                                      fontSize: FontSize.s20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAnimation(
                                child: buildMusicAlbum(video.profilePhoto),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    });
  }
}
