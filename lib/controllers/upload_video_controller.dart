import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/user.dart' as model;
import 'package:tiktok/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  // Instance
  static UploadVideoController instance = Get.find();

  // Video Compress
  Future _compressVideo(String videoPath) async {
    final video = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );

    return video!.file;
  }

  // Upload Video To Storage
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }

  // Get Video Thumbnail
  Future _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  // Upload Thumbnails To Storage
  Future<String> _uploadThumbnailsToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }

  // Upload Video
  Future<void> uploadVideo(
      String songName, String caption, String videoPath) async {
    try {
      if (songName.isNotEmpty && caption.isNotEmpty && videoPath.isNotEmpty) {
        // user data
        String uid = firebaseAuth.currentUser!.uid;
        model.User user = model.User.fromToSnap(
            await firestore.collection(CollectionName.users).doc(uid).get());

        // video data
        var allDocs = await firestore.collection(CollectionName.videos).get();
        int len = allDocs.docs.length;
        String videoId = 'video $len';

        // uploade video and thumbnail, and get url
        String videoUrl = await _uploadVideoToStorage(videoId, videoPath);
        String thumbnailUrl =
            await _uploadThumbnailsToStorage(videoId, videoPath);

        Video video = Video(
          id: videoId,
          uid: uid,
          userName: user.name,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
          profilePhoto: user.profilePhoto,
          commentsCount: 0,
          shareCount: 0,
          likes: [],
        );

        await firestore
            .collection(CollectionName.videos)
            .doc(videoId)
            .set(video.toJson());
      } else {
        Get.snackbar('Upload Video', 'Please enter all data');
      }
    } catch (e) {
      Get.snackbar('Upload Video', e.toString());
    }
    // go back
    Get.back();
  }
}
