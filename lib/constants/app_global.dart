import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiktok/controllers/auth_controller.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

AuthController authController = AuthController.instance;

class CollectionName {
  static String videos = 'videos';
  static String comments = 'comments';
  static String users = 'users';
  static String followers = 'followers';
  static String following = 'following';
}
