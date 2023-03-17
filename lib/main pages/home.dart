import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/productPage.dart';

import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_Page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kart2/models/firebase_commands.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //might have to change this for ever page
  List pages = [
    //update when pages are created
    const RecommendationsPage(),
    const searchPage(),
    ProfilePage(),
  ];

  int currentIndex1 = 0;

  void onTap(int index) {
    setState(() {
      currentIndex1 = index;
    });
  }

  final CollectionReference _barcodes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection('scanned');

  void snackMessage(bool action, String barcode) {
    //true for delete
    //false for favorite
    if (action == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You have successfully deleted $barcode"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added $barcode to favorites"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          collapsedHeight: 75,
          surfaceTintColor: Colors.white,
          centerTitle: true,
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
          child: Column(
            children: [
              StreamBuilder(
                stream: _barcodes.orderBy('time', descending: true).snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    if (streamSnapshot.data!.size > 0) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Slidable(
                            endActionPane:
                                ActionPane(motion: DrawerMotion(), children: [
                              SlidableAction(
                                onPressed: (context) {
                                  snackMessage(
                                      false, documentSnapshot['barcode']);
                                  FirebaseCommands().favoriteBarcode(
                                      documentSnapshot['barcode']);
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.favorite,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  snackMessage(
                                      true, documentSnapshot['barcode']);
                                  FirebaseCommands().destroyBarcode(
                                      documentSnapshot['barcode']);
                                  FirebaseCommands().removeFavorite(
                                      documentSnapshot['barcode']);
                                },
                                backgroundColor: Colors.indigo,
                                icon: Icons.delete,
                              ),
                            ]),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => productPage(
                                            documentSnapshot['barcode'])));
                              },
                              leading: Image.network(
                                  "https://www.eslc.org/wp-content/uploads/2019/08/placeholder-grey-square-600x600.jpg"),
                              title: Text(documentSnapshot['barcode']),
                              subtitle: const Text("Grade: Good"),
                              trailing: SizedBox(
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 250,
                          ),
                          Text(
                            'Scan an item to get started',
                            style: GoogleFonts.bebasNeue(fontSize: 25),
                          )
                        ],
                      );
                    }
                  } else {
                    return const Text('loading...');
                  }
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
