import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String uid;
  String profilePhoto;

  User({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "profilePhoto": profilePhoto,
      };

  static User fromToSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> snapUser = snapshot.data() as Map<String, dynamic>;
    return User(
      name: snapUser['name'],
      email: snapUser['email'],
      uid: snapUser['uid'],
      profilePhoto: snapUser['profilePhoto'],
    );
  }
}
