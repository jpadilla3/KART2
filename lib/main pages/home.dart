import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/List.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/profile_page.dart';
import 'package:kart2/main%20pages/recommendations_Page.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen2.dart';

import '../models/barcode_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  /*
  Future<BarcodeData> fetchBarcodeData() async {
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$_scanBarcode?fields=allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);
    if (response.statusCode == 200) {
      FirebaseCommands().updateBarcode(_scanBarcode, barcodeData);
      return barcodeData;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  */

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
                                onPressed: (context) async {
                                  snackMessage(
                                      false, documentSnapshot['barcode']);
                                  FirebaseCommands().favoriteBarcode(
                                      documentSnapshot['barcode'],
                                      documentSnapshot['name'],
                                      documentSnapshot['score']);
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
                              title: Text(documentSnapshot['name']),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Score: ${documentSnapshot['score']}',
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              trailing: SizedBox(
                                child: const Icon(Icons.arrow_forward_ios),
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
                    return const CircularProgressIndicator();
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
