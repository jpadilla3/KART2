import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //might have to change this for ever page
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChange(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          backgroundColor: Colors.grey,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.indigo[400],
                size: 35,
              )),
          title: Text(
            'HISTORY',
            style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InfoPage()));
              },
              icon: const Icon(
                Icons.info_outline,
                size: 35,
              ),
              color: Colors.indigo[400],
            )
          ],
        ),
      ]),
      bottomNavigationBar: SizedBox(
        width: 50,
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: DotNavigationBar(
            backgroundColor: Colors.grey,
            //margin: EdgeInsets.only(left: 10, right: 10),
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            dotIndicatorColor: Colors.indigo[400],
            unselectedItemColor: Colors.grey,
            onTap: _handleIndexChange,
            items: [
              //home
              DotNavigationBarItem(
                  icon: const Icon(Icons.home),
                  selectedColor: Colors.indigo[400]),

              //recommendation
              DotNavigationBarItem(
                  icon: const Icon(Icons.change_circle_outlined),
                  selectedColor: Colors.indigo[400]),

              //camera
              DotNavigationBarItem(
                  icon: const Icon(Icons.photo_camera_rounded),
                  selectedColor: Colors.indigo[400]),

              //search
              DotNavigationBarItem(
                  icon: const Icon(Icons.search),
                  selectedColor: Colors.indigo[400]),

              //profile
              DotNavigationBarItem(
                  icon: const Icon(Icons.account_circle_rounded),
                  selectedColor: Colors.indigo[400]),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SelectedTab {
  home,
  changed_circle_outlined,
  photo_camera_rounded,
  search,
  account_circle_rounded
}
