import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/user.dart';
import 'package:tiktok/models/video.dart';

class VideoController extends GetxController {
  // Create Video List
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    // get videos from firebase
    _videoList.bindStream(
      firestore.collection(CollectionName.videos).snapshots().map(
        (QuerySnapshot querySnapshot) {
          List<Video> values = []; // return array of video
          for (var video in querySnapshot.docs) {
            values.add(Video.fromSnap(video));
          }
          return values.reversed.toList();
        },
      ),
    );
  }

  // Set Like Function
  likeVideo(String videoId) async {
    DocumentSnapshot doc =
        await firestore.collection(CollectionName.videos).doc(videoId).get();
    String uid = authController.user.uid;

    if ((doc.data() as dynamic)['likes'].contains(uid)) {
      await firestore.collection(CollectionName.videos).doc(videoId).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection(CollectionName.videos).doc(videoId).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  // Share Video
  void shareVideo(Video oldVideo) async {
    try {
      // user data
      String uid = authController.user.uid;
      User user = User.fromToSnap(
          await firestore.collection(CollectionName.users).doc(uid).get());

      // video data
      var allDocs = await firestore.collection(CollectionName.videos).get();
      int len = allDocs.docs.length;
      String videoId = 'video $len';

      Video shareVideo = Video(
        id: videoId,
        uid: uid,
        userName: user.name,
        songName: oldVideo.songName,
        caption: oldVideo.caption,
        videoUrl: oldVideo.videoUrl,
        thumbnailUrl: oldVideo.thumbnailUrl,
        profilePhoto: user.profilePhoto,
        commentsCount: 0,
        shareCount: 0,
        likes: [],
      );

      await firestore
          .collection(CollectionName.videos)
          .doc(videoId)
          .set(shareVideo.toJson());

      await firestore
          .collection(CollectionName.videos)
          .doc(oldVideo.id)
          .update({
        'shareCount': oldVideo.shareCount + 1,
      });
    } catch (e) {
      Get.snackbar('Upload Video', e.toString());
    }
  }
}
