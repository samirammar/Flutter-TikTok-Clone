import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _users = Rx<List<User>>([]);
  List<User> get users => _users.value;

  @override
  void onReady() {
    clearUsers();
    super.onReady();
  }

  // Search User Function
  searchUser(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (text.isNotEmpty) {
      try {
        _users.bindStream(
          firestore
              .collection(CollectionName.users)
              .where('name', isGreaterThanOrEqualTo: text)
              .snapshots()
              .map(
            (QuerySnapshot snapshots) {
              List<User> values = [];
              // set user in list
              for (var snap in snapshots.docs) {
                User newUser = User.fromToSnap(snap);
                if (newUser.uid != authController.user.uid) {
                  values.add(newUser);
                }
              }
              return values;
            },
          ),
        );
      } catch (e) {
        Get.snackbar('User Search', e.toString());
      }
    } else {
      clearUsers();
    }
  }

  // Clear Users
  void clearUsers() {
    _users.value = [];
  }
}
