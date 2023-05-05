import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/productPage.dart';

import '../models/firebase_commands.dart';
import '../models/scoreColor.dart';

class RecoList extends StatefulWidget {
  final String barcode;
  const RecoList(this.barcode, {Key? key}) : super(key: key);

  @override
  State<RecoList> createState() => RecoListState();
}

class RecoListState extends State<RecoList> {
  List<String> docIDs = [];

  Stream<List<DocumentSnapshot>> getDocs() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .doc(widget.barcode)
        .collection('recommended')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.indigo[400],
          surfaceTintColor: Colors.indigo[400],
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          title: Text(
            'Recommended Products',
            style: GoogleFonts.bebasNeue(fontSize: 25, color: Colors.black),
          ),
        ),
        body: StreamBuilder<List<DocumentSnapshot>>(
          stream: getDocs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              List<DocumentSnapshot> docs = snapshot.data!;
              if (docs.isNotEmpty) {
                return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = docs[index];

                      String imageUrl = doc['picture'] ?? '';
                      String title = doc['name'] ?? '';
                      String barcode = doc['barcode'] ?? '';
                      String grade = doc['nutrition']['grade'] ?? '';

                      return InkWell(
                        onTap: () async {
                          FirebaseCommands().addBarcode(barcode);
                          FirebaseCommands().getSimilarProducts2(barcode);
                          bool isFavorite = await FirebaseCommands()
                              .isProductFavorite(
                                  barcode); // Add this line to fetch the favorite status

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(barcode, true, isFavorite)));
                        },
                        child: Card(
                          margin: EdgeInsets.all(
                              5.0), // Adjust the margin around each Card
                          child: Padding(
                            padding: EdgeInsets.all(
                                5.0), // Adjust the padding inside each Card
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // Distribute the space evenly between child widgets
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center child widgets horizontally
                              children: [
                                Container(
                                  height:
                                      120, // Adjust the height of the container
                                  width:
                                      150, // Adjust the width of the container
                                  color: Colors.indigo[400],
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(imageUrl,
                                          fit: BoxFit
                                              .cover) // Add fit: BoxFit.cover to fill the container with the image
                                      : const Center(child: Text('No picture')),
                                ),
                                const SizedBox(
                                    height:
                                        5), // Add some space between the image and the title
                                Center(
                                  child: Text(title),
                                ),
                                const SizedBox(
                                    height:
                                        5), // Add some space between the title and the grade widget
                                SizedBox(
                                  height: 70,
                                  width: 150,
                                  child: ScoreColors().scorePic(grade),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: Text('No recommended items found.'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
