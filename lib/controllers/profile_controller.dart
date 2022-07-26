import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/user.dart';
import 'package:tiktok/models/video.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  // User ID
  Rx<String> _uid = "".obs;
  // Update User Id
  void updateUserId(String id) {
    _uid.value = id;
    getUserData();
  }

  void getUserData() async {
    try {
      // Get thumbnails
      List<String> thumbnails = [];
      QuerySnapshot videos = await firestore
          .collection(CollectionName.videos)
          .where('uid', isEqualTo: _uid.value)
          .get();

      for (var video in videos.docs) {
        thumbnails.add((video.data() as dynamic)['thumbnailUrl']);
      }

      // Get user data
      User userData = User.fromToSnap(await firestore
          .collection(CollectionName.users)
          .doc(_uid.value)
          .get());

      // Like calc
      int likes = 0;
      for (var video in videos.docs) {
        likes += Video.fromSnap(video).likes.length;
      }

      // Get followers
      QuerySnapshot followersDoc = await firestore
          .collection(CollectionName.users)
          .doc(_uid.value)
          .collection(CollectionName.followers)
          .get();
      int followers = followersDoc.docs.length;

      // Get following
      QuerySnapshot followingDoc = await firestore
          .collection(CollectionName.users)
          .doc(_uid.value)
          .collection(CollectionName.following)
          .get();
      int following = followingDoc.docs.length;

      // Is following
      bool isFollowing = true;
      firestore
          .collection(CollectionName.users)
          .doc(_uid.value)
          .collection(CollectionName.followers)
          .doc(authController.user.uid)
          .get()
          .then(
        (value) {
          if (value.exists) {
            isFollowing = false;
          }
        },
      );

      _user.value = {
        'followers': followers.toString(),
        'following': following.toString(),
        'isFollowing': isFollowing,
        'likes': likes.toString(),
        'profilePhoto': userData.profilePhoto,
        'name': userData.name,
        'thumbnails': thumbnails,
      };
      update();
    } catch (e) {
      Get.snackbar('Get User Data', e.toString());
    }
  }

  void followUser() async {
    try {
      var doc = await firestore
          .collection(CollectionName.users)
          .doc(_uid.value)
          .collection(CollectionName.followers)
          .doc(authController.user.uid)
          .get();

      if (!doc.exists) {
        // Follow
        await firestore
            .collection(CollectionName.users)
            .doc(_uid.value)
            .collection(CollectionName.followers)
            .doc(authController.user.uid)
            .set({});
        await firestore
            .collection(CollectionName.users)
            .doc(authController.user.uid)
            .collection(CollectionName.following)
            .doc(_uid.value)
            .set({});
        _user.value
            .update('followers', (value) => (int.parse(value) + 1).toString());
      } else {
        // Unfollow
        await firestore
            .collection(CollectionName.users)
            .doc(_uid.value)
            .collection(CollectionName.followers)
            .doc(authController.user.uid)
            .delete();
        await firestore
            .collection(CollectionName.users)
            .doc(authController.user.uid)
            .collection(CollectionName.following)
            .doc(_uid.value)
            .delete();
        _user.value
            .update('followers', (value) => (int.parse(value) - 1).toString());
      }
      _user.value.update('isFollowing', (value) => !value);
      update();
    } catch (e) {
      Get.snackbar('Follow User', e.toString());
    }
  }
}
