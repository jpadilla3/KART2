import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:shimmer/shimmer.dart';

import '../models/firebase_commands.dart';
import 'shimmerlist.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecPageState();
}

class _RecPageState extends State<RecommendationsPage> {
  bool isLoading = false;
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
        content: Text("You have successfully favorited $barcode"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50),
      ));
    }
    void initState() {
      isLoading = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
      });
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          expandedHeight: 147,
          leading: const Text(''),
          title: Text(
            'Recommendations',
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
            ),
          ],
          surfaceTintColor: Colors.white,
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              StreamBuilder(
                stream: _barcodes.orderBy('time', descending: true).snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    if (streamSnapshot.data!.size > 0) {
                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 3,
                          indent: 12,
                          endIndent: 12,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];

                          List<String> docIDs = [];

                          Stream getDocId() async* {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.email
                                    .toString())
                                .collection('scanned')
                                .doc(documentSnapshot['barcode'])
                                .collection('recommended')
                                .get()
                                .then((snapshot) =>
                                    snapshot.docs.forEach((document) {
                                      docIDs.add(document.reference.id);
                                    }));
                          }

                          getName(String barcode2) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: _barcodes
                                  .doc(documentSnapshot['barcode'])
                                  .collection('recommended')
                                  .doc(barcode2)
                                  .get(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Expanded(
                                    child: Text(
                                      '${data['name']}',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 2,
                                    ),
                                  );
                                }
                                return const Text('loading');
                              }),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              height: 200,
                              width: 330,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //scanned item
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => productPage(
                                                  documentSnapshot['barcode'],
                                                  true)));
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: Image.network(
                                                '${documentSnapshot['picture']}'),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 120,
                                          alignment: Alignment.center,
                                          child: Expanded(
                                            child: Text(
                                              '${documentSnapshot['name']}',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: SizedBox(
                                      width: 70,
                                      child: Icon(Icons.change_circle_outlined),
                                    ),
                                  ),
                                  //recommended item
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => recoList(
                                                  documentSnapshot[
                                                      'barcode'])));
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Container(
                                              height: 120,
                                              width: 120,
                                              color: Colors.indigo[400],
                                              alignment: Alignment.center,
                                              child: Text('Picture')),
                                        ),
                                        Container(
                                            height: 50,
                                            width: 120,
                                            alignment: Alignment.center,
                                            child: StreamBuilder(
                                                stream: getDocId(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return getName(docIDs[0]);
                                                  } else {
                                                    return const Text(
                                                        'loading');
                                                  }
                                                }))
                                      ],
                                    ),
                                  )
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
                            height: 250,
                          ),
                          Text(
                            'Recommended items will appear here',
                            style: GoogleFonts.bebasNeue(fontSize: 25),
                          )
                        ],
                      );
                    }
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
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
    ));
  }

  Widget buildRowShimmer() => Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Container(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child:
                            ShimmerLoader.rectangular(width: 16, height: 16)),
                  ),
                  Container(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    child: ShimmerLoader.rectangular(width: 50, height: 16),
                  ),
                ],
              ),
              SizedBox(
                width: 70,
                child: Icon(Icons.change_circle_outlined),
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    child: ShimmerLoader.rectangular(width: 50, height: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
