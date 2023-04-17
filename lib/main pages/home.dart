import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';
import 'package:shimmer/shimmer.dart';
import 'shimmerlist.dart';

import '../models/barcode_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  String _scanBarcode = '';
  late Future<BarcodeData> futureBarcodeData;
  //might have to change this for ever page
  List pages = [
    //update when pages are created
    const RecommendationsPage(),
    const SearchPage(),
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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      //add barcode to firebase
      //passes current user email and barcode
      FirebaseCommands().addBarcode(barcodeScanRes);
      FirebaseCommands().updateBarcode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await scanBarcodeNormal(); //adds barcode to firebase
        },
        backgroundColor: Colors.indigo[400],
        child: const Icon(
          Icons.photo_camera_rounded,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          expandedHeight: 147,
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
            key: const Key('history'),
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

                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      snackMessage(
                                          false, documentSnapshot['barcode']);
                                      FirebaseCommands().favoriteBarcode(
                                          documentSnapshot['barcode'],
                                          documentSnapshot['name'],
                                          documentSnapshot['nutrition']
                                              ['grade'],
                                          true,
                                          documentSnapshot['picture'],
                                          documentSnapshot['Allergens']);
                                    },
                                    backgroundColor: Colors.red,
                                    icon: Icons.favorite,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      snackMessage(
                                          true, documentSnapshot['barcode']);
                                      FirebaseCommands().destroyBarcode(
                                          documentSnapshot['barcode'], true);
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
                                            true)));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            child: Image.network(
                                                '${documentSnapshot['picture']}'),
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
                                                  style: TextStyle(
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
                                                  documentSnapshot['nutrition']
                                                      ['grade']),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  'Grade: ${documentSnapshot['nutrition']['grade'].toString().toUpperCase()}',
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        FutureBuilder(
                                            future: GradeCal().gradeCalculate(
                                                documentSnapshot['Allergens']),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      '${snapshot.error} occurred');
                                                } else {
                                                  final data =
                                                      snapshot.data as bool;

                                                  if (data == true) {
                                                    return const SizedBox(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: Icon(
                                                          Icons.info_outline,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return const Text('');
                                                  }
                                                }
                                              } else {
                                                return const Text('');
                                              }
                                            }),
                                        const SizedBox(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.indigo,
                                            ),
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
      ]),
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
