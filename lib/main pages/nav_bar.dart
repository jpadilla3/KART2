import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_Page.dart';

import 'camera_page.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  List pages = [
    //update when pages are created
    HomePage(),
    recommendationsPage(),
    cameraPage(),
    searchPage(),
    ProfilePage(),
  ];

  int currentIndex1 = 0;

  void onTap(int index) {
    setState(() {
      currentIndex1 = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex1],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        selectedItemColor: Colors.indigo[400],
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex1,
        items: const [
          //home icon
          BottomNavigationBarItem(label: "History", icon: Icon(Icons.home)),

          //recommendation icon
          BottomNavigationBarItem(
            label: "Recommendation",
            icon: Icon(
              Icons.change_circle_outlined,
            ),
          ),

          //camera icon
          BottomNavigationBarItem(
              label: "Camera", icon: Icon(Icons.photo_camera_rounded)),

          //search icon
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),

          //profile icon
          BottomNavigationBarItem(
              label: "Profile", icon: Icon(Icons.account_circle_rounded)),
        ],
      ),
    );
  }
}
