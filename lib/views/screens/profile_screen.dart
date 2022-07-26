import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.black,
            leading: const Icon(Icons.person_add_alt_1_outlined),
            actions: const [
              Icon(Icons.more_horiz),
              SizedBox(width: 10),
            ],
            title: Text(controller.user['name']),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: controller.user['profilePhoto'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, err) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 61,
                            child: Column(
                              children: [
                                Text(
                                  controller.user['following'],
                                  style: TextStyle(
                                    fontSize: FontSize.s20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 61,
                            child: Column(
                              children: [
                                Text(
                                  controller.user['followers'],
                                  style: TextStyle(
                                    fontSize: FontSize.s20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 61,
                            child: Column(
                              children: [
                                Text(
                                  controller.user['likes'],
                                  style: TextStyle(
                                    fontSize: FontSize.s20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 140,
                        height: 47,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              if (widget.uid == authController.user.uid) {
                                authController.signOut();
                              } else {
                                controller.followUser();
                              }
                            },
                            child: Text(
                              widget.uid == authController.user.uid
                                  ? 'Sign Out'
                                  : controller.user['isFollowing']
                                      ? 'Unfollow'
                                      : 'Follow',
                              style: TextStyle(
                                fontSize: FontSize.s15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.user['thumbnails'].length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: controller.user['thumbnails'][index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
