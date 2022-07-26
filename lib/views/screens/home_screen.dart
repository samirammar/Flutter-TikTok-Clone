import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/views/screens/confirm_screen.dart';
import 'package:tiktok/views/screens/profile_screen.dart';
import 'package:tiktok/views/screens/search_screen.dart';
import 'package:tiktok/views/screens/video_screen.dart';
import 'package:tiktok/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current Index Number
  int _pageIndex = 0;

  // List Of Screens
  final List<Widget> _screens = [
    VideoScreen(),
    SearchScreen(),
    const Text(''),
    const Center(child: Text('Message')),
    ProfileScreen(uid: authController.user.uid),
  ];

  // Pick Video
  _pickVideo(context, ImageSource imageSource) async {
    final video = await ImagePicker().pickVideo(source: imageSource);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            video: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  // Show Option
  _showOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => _pickVideo(context, ImageSource.gallery),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => _pickVideo(context, ImageSource.camera),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cansel',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.red,
        unselectedItemColor: AppColors.white,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        onTap: (index) {
          if (index == 2) {
            _showOption(context);
          } else {
            setState(() {
              _pageIndex = index;
            });
          }
        },
        currentIndex: _pageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
      body: _screens[_pageIndex],
    );
  }
}
