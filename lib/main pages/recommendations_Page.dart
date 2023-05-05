import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/scan_page.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../models/barcode_data_model.dart';
import '../models/firebase_commands.dart';
import 'shimmerlist.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => RecPageState();
}

class RecPageState extends State<RecommendationsPage> {
  bool isLoading = false;
  String _scanBarcode = '';
  String? _lastScannedBarcode;

  bool type = false;
  bool fav = false;
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

  Future<void> scanAndProcessBarcode() async {
    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      // Adds barcode to firebase and get recommendations
      FirebaseCommands().addBarcode(barcodeScanRes);
      FirebaseCommands().getSimilarProducts2(barcodeScanRes);
    } on PlatformException catch (e) {
      barcodeScanRes = 'Failed to scan barcode: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      isLoading = false;
      type = true;
      _lastScannedBarcode = barcodeScanRes;
    });
  }

  Future<List<String>> getRecommendedDocIds(
      DocumentSnapshot documentSnapshot) async {
    List<String> docIDs = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .doc(documentSnapshot['barcode'])
        .collection('recommended')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));

    return docIDs;
  }

  Future<String> getRecommendedProductName(
      String barcode, String barcode2) async {
    DocumentSnapshot snapshot = await _barcodes
        .doc(barcode)
        .collection('recommended')
        .doc(barcode2)
        .get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return data['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await scanAndProcessBarcode(); //adds barcode to firebase
            bool isFavorite = await FirebaseCommands()
                .isProductFavorite(_lastScannedBarcode!);
            if (_lastScannedBarcode != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductPage(_lastScannedBarcode!, true, isFavorite)));
            }
          },
          backgroundColor: Colors.indigo[400],
          child: const Icon(
            Icons.photo_camera_rounded,
            color: Colors.white,
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavPage()));
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.indigo[400],
                    size: 35,
                  )),
              expandedHeight: 147,
              title: Text(
                'Recommendations',
                style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoPage()));
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
                    stream:
                        _barcodes.orderBy('time', descending: true).snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        if (streamSnapshot.data!.size > 0) {
                          return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
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

                              FutureBuilder<List<String>>(
                                future: getRecommendedDocIds(documentSnapshot),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    String barcode2 = snapshot.data![0];
                                    return FutureBuilder<String>(
                                      future: getRecommendedProductName(
                                          documentSnapshot['barcode'],
                                          barcode2),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return SizedBox(
                                            child: Text(
                                              '${snapshot.data}',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 2,
                                            ),
                                          );
                                        }
                                        return const Text('loading');
                                      },
                                    );
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              );

                              List<String> docIDs = [];

                              Stream getDocId() async* {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email
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

                              Future<Map<String, dynamic>> getNameAndPicture(
                                  String barcode2) async {
                                DocumentSnapshot snapshot = await _barcodes
                                    .doc(documentSnapshot['barcode'])
                                    .collection('recommended')
                                    .doc(barcode2)
                                    .get();
                                Map<String, dynamic> data =
                                    snapshot.data()! as Map<String, dynamic>;
                                return data;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: SizedBox(
                                  height: 220,
                                  width: 330,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //scanned item
                                      GestureDetector(
                                        onTap: () async {
                                          //adds barcode to firebase
                                          bool isFavorite =
                                              await FirebaseCommands()
                                                  .isProductFavorite(
                                                      documentSnapshot[
                                                          'barcode']);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductPage(
                                                          documentSnapshot[
                                                              'barcode'],
                                                          true,
                                                          isFavorite)));
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
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
                                              height: 45,
                                              width: 120,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${documentSnapshot['name']}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      maxLines: 2,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  //vegan
                                                  FutureBuilder(
                                                      future: GradeCal()
                                                          .gradeCalculate(
                                                              documentSnapshot[
                                                                  'Allergens'],
                                                              documentSnapshot[
                                                                  'conditions'])
                                                          .catchError((error) =>
                                                              throw Exception(
                                                                  'Failed to calculate Allergens and Conditions: $error')),
                                                      builder:
                                                          (BuildContext context,
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                '${snapshot.error} occurred');
                                                          } else {
                                                            final data =
                                                                snapshot.data
                                                                    as List<
                                                                        bool>;

                                                            if (data[0] ==
                                                                false) {
                                                              return const SizedBox(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              2),
                                                                  child: Icon(
                                                                    Icons
                                                                        .energy_savings_leaf,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  '');
                                                            }
                                                          }
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      }),
                                                  //vegetarian
                                                  FutureBuilder(
                                                      future: GradeCal()
                                                          .gradeCalculate(
                                                              documentSnapshot[
                                                                  'Allergens'],
                                                              documentSnapshot[
                                                                  'conditions'])
                                                          .catchError((error) =>
                                                              throw Exception(
                                                                  'Failed to calculate Allergens and Conditions: $error')),
                                                      builder:
                                                          (BuildContext context,
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                '${snapshot.error} occurred');
                                                          } else {
                                                            final data =
                                                                snapshot.data
                                                                    as List<
                                                                        bool>;

                                                            if (data[1] ==
                                                                false) {
                                                              return const SizedBox(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              2),
                                                                  child: Icon(
                                                                    Icons
                                                                        .eco_outlined,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  '');
                                                            }
                                                          }
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      }),

                                                  //lactose
                                                  FutureBuilder(
                                                      future: GradeCal()
                                                          .gradeCalculate(
                                                              documentSnapshot[
                                                                  'Allergens'],
                                                              documentSnapshot[
                                                                  'conditions'])
                                                          .catchError((error) =>
                                                              throw Exception(
                                                                  'Failed to calculate Allergens and Conditions: $error')),
                                                      builder:
                                                          (BuildContext context,
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                '${snapshot.error} occurred');
                                                          } else {
                                                            final data =
                                                                snapshot.data
                                                                    as List<
                                                                        bool>;

                                                            if (data[2] ==
                                                                true) {
                                                              return SizedBox(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            2),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/milk.png',
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                    )),
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  '');
                                                            }
                                                          }
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      }),

                                                  //allergy
                                                  FutureBuilder(
                                                      future: GradeCal()
                                                          .gradeCalculate(
                                                              documentSnapshot[
                                                                  'Allergens'],
                                                              documentSnapshot[
                                                                  'conditions'])
                                                          .catchError((error) =>
                                                              throw Exception(
                                                                  'Failed to calculate Allergens and Conditions: $error')),
                                                      builder:
                                                          (BuildContext context,
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                '${snapshot.error} occurred');
                                                          } else {
                                                            final data =
                                                                snapshot.data
                                                                    as List<
                                                                        bool>;

                                                            if (data[3] ==
                                                                true) {
                                                              return const SizedBox(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              2),
                                                                  child: Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  '');
                                                            }
                                                          }
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      })
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: SizedBox(
                                          width: 70,
                                          child: Icon(
                                            Ionicons
                                                .arrow_forward_circle_outline,
                                          ),
                                        ),
                                      ),
                                      //recommended item
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RecoList(documentSnapshot[
                                                          'barcode'])));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 180,
                                              width: 120,
                                              alignment: Alignment.center,
                                              child: StreamBuilder(
                                                stream: getDocId(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return FutureBuilder<
                                                        Map<String, dynamic>>(
                                                      future: getNameAndPicture(
                                                          docIDs[0]),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  Map<String,
                                                                      dynamic>>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          }
                                                          String picture =
                                                              snapshot.data![
                                                                  'picture'];
                                                          String name = snapshot
                                                              .data!['name'];
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                                  child:
                                                                      Container(
                                                                    height: 120,
                                                                    width: 120,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    color: Colors
                                                                        .transparent,
                                                                    child: picture ==
                                                                            ''
                                                                        ? const Text(
                                                                            'loading')
                                                                        : Image
                                                                            .network(
                                                                            picture,
                                                                          ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 45,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    name,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        false,
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          return const Text(
                                                              'loading');
                                                        }
                                                      },
                                                    );
                                                  } else {
                                                    return const Text(
                                                        'loading');
                                                  }
                                                },
                                              ),
                                            )
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
        child: SizedBox(
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
                    child:
                        const ShimmerLoader.rectangular(width: 50, height: 16),
                  ),
                ],
              ),
              const SizedBox(
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
