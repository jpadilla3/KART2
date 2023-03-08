import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/camera_page.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_Page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //might have to change this for ever page
  List pages = [
    //update when pages are created
    RecommendationsPage(),
    CameraPage(),
    searchPage(),
    ProfilePage(),
  ];
  final List<Map<String, String>> items = [
    {
      'image':
          'https://kellogg-h.assetsadobe.com/is/image/content/dam/kelloggs/kna/us/digital-shelf/rice-krispies/00038000200038_C1L1.jpg',
      'title': 'Rice Krispies Cereal',
      'subtitle': 'Poor: Sugar '
    },
    {
      'image': 'https://i5.peapod.com/c/63/63OIA.png',
      'title': 'HotPockets Pepperoni',
      'subtitle': 'Poor: High on sodium'
    },
    {
      'image':
          'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcSM03KIfF8AODqR0AL0MimAm86l0LAelByuQhyF90MpwVekSPDdK3xfSUwyHHoxJnGp6v7FVGfm5wGLAl35G_Zl-SigGuWBPg',
      'title': 'Tyson Chicken Strips',
      'subtitle': 'Moderate: Sodium'
    },
    {
      'image': 'https://images.heb.com/is/image/HEBGrocery/000569244',
      'title': 'Hungry Jacks Pancake Mix',
      'subtitle': 'Poor: High Sugar'
    },
    {
      'image': 'https://i5.peapod.com/c/3V/3VP33.png',
      'title': 'Stouffers Lasagna',
      'subtitle': 'Poor: Saturated Fat'
    },
    {
      'image': 'https://images.heb.com/is/image/HEBGrocery/000105727',
      'title': 'Banquat Chicken Pot Pie',
      'subtitle': 'Poor: Saturated Fat'
    },
    {
      'image':
          'https://images.heb.com/is/image/HEBGrocery/005684048?fit=constrain,1&wid=800&hei=800&fmt=jpg&qlt=85,0&resMode=sharp2&op_usm=1.75,0.3,2,0',
      'title': 'Checkers Rallys Famous Seasoned Fries',
      'subtitle': 'Unknown'
    },
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
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FavPage()));
              },
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

        //rest of ui
        PreferredSize(
          preferredSize: Size.fromHeight(600.0),
          child: ItemList(items: items),
        ),
      ]),
    );
  }
}
