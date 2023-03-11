import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/camera_page.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_Page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ];

  int currentIndex1 = 0;

  void onTap(int index) {
    setState(() {
      currentIndex1 = index;
    });
  }

  //print barcodes
  List<String> barcodeIDS = [];
  List<String> reverseBarcode = [];

  Future getBarcode() async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .orderBy('time:', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              barcodeIDS.add(element.reference.id);
            }));
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
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: getBarcode(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: barcodeIDS.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(barcodeIDS[index]),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
