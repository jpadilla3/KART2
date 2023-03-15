import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void snackMessage(String barcode) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You have successfully removed $barcode"),
    ));
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
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            snackMessage(
                                                documentSnapshot['barcode']);
                                            FirebaseCommands().removeFavorite(
                                                documentSnapshot['barcode']);
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ],
                                  ),
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
