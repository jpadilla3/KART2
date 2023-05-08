import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/shimmerlist.dart';
import 'package:shimmer/shimmer.dart';

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
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          height: 4,
                          indent: 12,
                          endIndent: 12,
                        ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = docs[index];
                      Map<String, dynamic>? docData =
                          doc.data() as Map<String, dynamic>?;
                      String imageUrl = '';
                      String title = '';
                      String barcode = '';
                      String grade = '';
                      bool type = true;

                      if (docData != null) {
                        imageUrl = docData['picture'] ?? '';
                        title = docData['name'] ?? '';
                        barcode = docData['barcode'] ?? '';
                        if (docData['nutrition'] is Map<String, dynamic>) {
                          grade =
                              (docData['nutrition']['grade'] as String?) ?? '';
                        }
                        type = docData['id'] as bool? ?? true;
                      }

                      return InkWell(
                          onTap: () async {
                            print(
                                "docData?['barcode']: ${docData?['barcode']}");
                            FirebaseCommands()
                                .addBarcode(docData?['barcode'], type);
                            bool isFavorite = await FirebaseCommands()
                                .isProductFavorite(docData?[
                                    'barcode']); // Add this line to fetch the favorite status

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        docData?['barcode'],
                                        true,
                                        true,
                                        isFavorite,
                                        onFail: () =>
                                            Navigator.of(context).pop())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: 70,
                                        width: 70,
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                              )
                                            : const Text('no image'))
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          title,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 50,
                                              width: 75,
                                              child:
                                                  ScoreColors().scorePic(grade))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 25, color: Colors.indigo[400]),
                              ],
                            ),
                          ));
                    });
              } else {
                return const Center(
                    child: Text('No Recommended Products Found.'));
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
        ));
  }
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
                  width: 200,
                  height: 16,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ShimmerLoader.rectangular(
                  width: 100,
                  height: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
