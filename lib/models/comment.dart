import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String uid;
  String username;
  String comment;
  String profilePhoto;
  List likes;
  dynamic date;

  Comment({
    required this.id,
    required this.uid,
    required this.username,
    required this.comment,
    required this.profilePhoto,
    required this.likes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'username': username,
        'comment': comment,
        'profilePhoto': profilePhoto,
        'likes': likes,
        'date': date,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      id: snapshot['id'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      comment: snapshot['comment'],
      profilePhoto: snapshot['profilePhoto'],
      likes: snapshot['likes'],
      date: snapshot['date'],
    );
  }
}
