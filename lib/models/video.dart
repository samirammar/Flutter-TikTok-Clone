import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String id;
  String uid;
  String userName;
  String songName;
  String caption;
  String videoUrl;
  String thumbnailUrl;
  String profilePhoto;
  int commentsCount;
  int shareCount;
  List likes;

  Video({
    required this.id,
    required this.uid,
    required this.userName,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.profilePhoto,
    required this.commentsCount,
    required this.shareCount,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'userName': userName,
        'songName': songName,
        'caption': caption,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'profilePhoto': profilePhoto,
        'commentsCount': commentsCount,
        'shareCount': shareCount,
        'likes': likes,
      };

  static Video fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> video = snapshot.data() as Map<String, dynamic>;

    return Video(
      id: video['id'],
      uid: video['uid'],
      userName: video['userName'],
      songName: video['songName'],
      caption: video['caption'],
      videoUrl: video['videoUrl'],
      thumbnailUrl: video['thumbnailUrl'],
      profilePhoto: video['profilePhoto'],
      commentsCount: video['commentsCount'],
      shareCount: video['shareCount'],
      likes: video['likes'],
    );
  }
}
