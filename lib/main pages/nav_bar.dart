import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'search_page.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  List pages = [
    //update when pages are created
    RecommendationsPage(),
    SearchPage(),
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
        type: BottomNavigationBarType.fixed,
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

          //recommendation icon
          BottomNavigationBarItem(
            label: "Recommendation",
            icon: Icon(
              Icons.photo_camera_rounded,
              key: ValueKey('recoButton'),
            ),
          ),

          //search icon
          BottomNavigationBarItem(
              label: "Search",
              icon: Icon(
                Icons.search,
                key: ValueKey('searchButton'),
              )),

          //profile icon
          BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(
                Icons.account_circle_rounded,
                key: ValueKey('profileButton'),
              )),
        ],
      ),
    );
  }
}
