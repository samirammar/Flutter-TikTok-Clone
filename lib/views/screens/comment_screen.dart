import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/controllers/comment_controller.dart';
import 'package:tiktok/models/comment.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String videoId;
  CommentScreen({Key? key, required this.videoId}) : super(key: key);

  final TextEditingController _commentTextController = TextEditingController();
  final CommentController _commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    _commentController.getComments(videoId);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: _commentController.comments.length,
                    itemBuilder: (context, index) {
                      Comment comment = _commentController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.black,
                          backgroundImage: NetworkImage(comment.profilePhoto),
                        ),
                        title: Row(
                          children: [
                            Text(
                              '${comment.username} ',
                              style: TextStyle(
                                fontSize: FontSize.s20,
                                color: AppColors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              comment.comment,
                              style: TextStyle(
                                fontSize: FontSize.s20,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              tago.format(comment.date.toDate()).toString(),
                              style: TextStyle(
                                fontSize: FontSize.s12,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${comment.likes.length} likes',
                              style: TextStyle(
                                fontSize: FontSize.s12,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () => _commentController.likeComment(
                              comment.id, videoId),
                          child: Icon(
                            Icons.favorite,
                            color:
                                comment.likes.contains(authController.user.uid)
                                    ? AppColors.red
                                    : AppColors.white,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentTextController,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'comment',
                    labelStyle: TextStyle(
                      fontSize: FontSize.s20,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    _commentController
                        .postComment(_commentTextController.text, videoId)
                        .then((value) {
                      _commentTextController.clear();
                    });
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
