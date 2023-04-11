import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:shimmer/shimmer.dart';

import '../models/scoreColor.dart';
import 'shimmerlist.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  void _handleIndexChange(int i) {
    setState(() {});
  }

  final CollectionReference _barcodes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection('favorites');

  void snackMessage(bool action, String barcode) {
    //true for delete
    //false for favorite
    if (action == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You have successfully deleted $barcode"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added $barcode to favorites"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 147,
            surfaceTintColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
              color: Colors.indigo[400],
            ),
            title: Text(
              'Favorites',
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
            ),
          ),

          //rest of ui
          SliverToBoxAdapter(
            child: Column(
              children: [
                StreamBuilder(
                  stream:
                      _barcodes.orderBy('time', descending: true).snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      if (streamSnapshot.data!.size > 0) {
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(height: 3),
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
                                        true, documentSnapshot['barcode']);

                                    FirebaseCommands().removeFavorite(
                                        documentSnapshot['barcode']);
                                  },
                                  backgroundColor: Colors.indigo,
                                  icon: Icons.delete,
                                ),
                              ]),
                              child: InkWell(
                                highlightColor: Colors.grey[300],
                                //behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // add your logic here
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => productPage(
                                              documentSnapshot['barcode'],
                                              documentSnapshot['ID'])));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              color: Colors.blueGrey,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    documentSnapshot['name'],
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                scoreColors().scoreColor(
                                                    documentSnapshot['grade']),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    'Grade: ${documentSnapshot['grade'].toString().toUpperCase()}',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: const [
                                          SizedBox(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 160,
                            ),
                            const Icon(
                              Icons.favorite_border_outlined,
                              size: 130,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Favorites will appear here',
                              style: GoogleFonts.bebasNeue(fontSize: 25),
                            )
                          ],
                        );
                      }
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return buildRowShimmer();
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowShimmer() => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey,
                    ),
                  )),
            ],
          ),
          SizedBox(
            width: 230,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerLoader.rectangular(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 16,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerLoader.rectangular(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      );
}
