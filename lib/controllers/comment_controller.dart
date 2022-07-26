import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/comment.dart';
import 'package:tiktok/models/user.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  // Get All Comments
  getComments(String videoId) {
    try {
      _comments.bindStream(
        firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .collection(CollectionName.comments)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<Comment> values = [];
            for (var doc in query.docs) {
              values.add(Comment.fromSnap(doc));
            }
            return values;
          },
        ),
      );
    } catch (e) {
      Get.snackbar('Get Video Comments', e.toString());
    }
  }

  // Set New Comment
  Future<void> postComment(String commentText, String videoId) async {
    if (commentText.isNotEmpty) {
      try {
        // get user profile
        DocumentSnapshot userDoc = await firestore
            .collection(CollectionName.users)
            .doc(authController.user.uid)
            .get();
        User user = User.fromToSnap(userDoc);

        // create comment id
        var allDocs = await firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .collection(CollectionName.comments)
            .get();
        String commentId = 'comment ${allDocs.docs.length}';

        // create a new comment
        Comment comment = Comment(
          id: commentId,
          uid: user.uid,
          username: user.name,
          comment: commentText,
          profilePhoto: user.profilePhoto,
          likes: [],
          date: DateTime.now(),
        );

        // upload new comment
        await firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .collection(CollectionName.comments)
            .doc(commentId)
            .set(comment.toJson());

        // update comment count
        var docs = await firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .get();
        await firestore.collection(CollectionName.videos).doc(videoId).update({
          'commentsCount': (docs.data() as dynamic)['commentsCount'] + 1,
        });
      } catch (e) {
        Get.snackbar('Comment Error', e.toString());
      }
    }
  }

  // Like Comment
  void likeComment(String id, String videoId) async {
    if (id.isNotEmpty) {
      try {
        // get comment
        Comment comment = Comment.fromSnap(await firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .collection(CollectionName.comments)
            .doc(id)
            .get());

        // get user id
        String uid = authController.user.uid;

        // set and remove like
        if (comment.likes.contains(uid)) {
          await firestore
              .collection(CollectionName.videos)
              .doc(videoId)
              .collection(CollectionName.comments)
              .doc(id)
              .update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        } else {
          await firestore
              .collection(CollectionName.videos)
              .doc(videoId)
              .collection(CollectionName.comments)
              .doc(id)
              .update({
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
      } catch (e) {
        Get.snackbar('Like Error', e.toString());
      }
    }
  }
}
