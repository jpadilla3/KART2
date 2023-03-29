import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/models/firebase_commands.dart';

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
                              Divider(height: 3),
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
                              child: GestureDetector(
                                onTap: () {
                                  // add your logic here
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => productPage(
                                              documentSnapshot['barcode'])));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.network(
                                            "https://www.eslc.org/wp-content/uploads/2019/08/placeholder-grey-square-600x600.jpg",
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
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
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
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
                      return const Text('loading...');
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
}
