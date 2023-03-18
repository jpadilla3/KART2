import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kart2/models/firebase_commands.dart';

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
    SearchPage(),
    ProfilePage(),
  ];

  int currentIndex1 = 0;

  void onTap(int index) {
    setState(() {
      currentIndex1 = index;
    });
  }

  final CollectionReference _barcodes = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString());

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
                StreamBuilder(
                  stream: _barcodes.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];

                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(documentSnapshot['barcode']),
                              trailing: SizedBox(
                                width: 50,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          FirebaseCommands().destroyBarcode(
                                              documentSnapshot['barcode']);
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text('loading');
                    }
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
