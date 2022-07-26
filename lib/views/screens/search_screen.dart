import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/controllers/search_controller.dart';
import 'package:tiktok/models/user.dart';
import 'package:tiktok/views/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: TextFormField(
          decoration: InputDecoration(
            filled: false,
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: FontSize.s18,
              color: AppColors.white,
            ),
          ),
          onChanged: (text) => _searchController.searchUser(text),
        ),
      ),
      body: Obx(
        () {
          return _searchController.users.isEmpty
              ? Center(
                  child: Icon(
                    Icons.person_off,
                    size: 50,
                    color: AppColors.white,
                  ),
                )
              : ListView.builder(
                  itemCount: _searchController.users.length,
                  itemBuilder: (context, index) {
                    User user = _searchController.users[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(uid: user.uid),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage: NetworkImage(user.profilePhoto),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: FontSize.s18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.clearUsers();
    super.dispose();
  }
}
