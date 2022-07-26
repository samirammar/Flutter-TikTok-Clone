import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/user.dart' as model;
import 'package:tiktok/views/screens/home_screen.dart';
import 'package:tiktok/views/screens/login/login_screen.dart';

class AuthController extends GetxController {
  // Instance
  static AuthController instance = Get.find();

  // User
  late Rx<User?> _user;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(const LoginScreen());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

  // Image Pic
  Rx<File?> profileImage = Rx<File?>(null);

  void imagePic() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      profileImage = Rx<File?>(File(imagePicked.path));
      Get.snackbar('Profile Image', 'Set profile image successfully');
    } else {
      Get.snackbar('Profile Image', 'Set profile image not success');
    }
  }

  // Upload Image To Storage
  Future<String> _uploadImage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePhotos')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }

  // Register New User
  Future<void> register(
      String userName, String email, String password, File? image) async {
    try {
      // check input data
      if (userName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // create a new user account
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // upload image profile
        String imageUrl = await _uploadImage(image);

        // create new profle
        model.User user = model.User(
            email: email,
            name: userName,
            profilePhoto: imageUrl,
            uid: userCredential.user!.uid);
        await firestore
            .collection(CollectionName.users)
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        // show field not found message
        Get.snackbar('Error Creating New User', 'Please enter all the fields');
      }
    } catch (e) {
      // show error message
      Get.snackbar('Error Creating New User', e.toString());
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      // check input data
      if (email.isNotEmpty && password.isNotEmpty) {
        // sign in function
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // show field not found message
        Get.snackbar('Error Login', 'Please enter all the fields');
      }
    } catch (e) {
      // show error message
      Get.snackbar('Error Login', e.toString());
    }
  }

  void signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      // show error message
      Get.snackbar('Error Sign Out', e.toString());
    }
  }
}
