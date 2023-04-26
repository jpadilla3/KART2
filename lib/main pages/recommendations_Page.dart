import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  State<RecommendationsPage> createState() => _RecPageState();
}

class _RecPageState extends State<RecommendationsPage> {
  bool isLoading = false;
  String _scanBarcode = '';
  bool type = false;
  bool favo = false;
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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    List<String> con = [];

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      //add barcode to firebase

      //passes current user email and barcode
      FirebaseCommands().addBarcode(barcodeScanRes);
      FirebaseCommands().updateBarcode(barcodeScanRes); //recommendation
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
      type = true;
    });
  }

  Future favs(barcode) async {
    bool fav;
    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('favorties')
        .doc(barcode)
        .get();

    if (favDoc.exists) {
      fav = true;
    } else {
      fav = false;
    }
    return fav;
  }

  Future itemScan(String barcode) async {
    Map<String, dynamic> item = {};
    List<String> alerg = [];
    List<String> con = [];
    int count = 0;
    int count2 = 0;
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags,brands,categories,categories_tags,compared_to_category,food_groups,food_groups_tags,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);

    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
        if (barcodeData.product!.allergensTags!.isNotEmpty) {
          for (int i = 0; i < barcodeData.product!.allergensTags!.length; i++) {
            alerg.add(barcodeData.product!.allergensTags![i].substring(3));
          }
        }
        if (barcodeData.product!.allergensTags!.contains('en:milk') ||
            barcodeData.product!.allergensTags!.contains('en:lactic')) {
          con.add('lactose intolerant');
        }

        for (final ingredient in barcodeData.product!.ingredients!) {
          if (ingredient.vegan != 'yes') {
            count++;
          }
          if (ingredient.vegetarian != 'yes') {
            count2++;
          }
        }
        if (count == 0) {
          con.add('vegan');
        }
        if (count2 == 0) {
          con.add('vegetarian');
        }
        item['brand'] =
            barcodeData.product?.brands ?? barcodeData.product?.productName!;
        item['score'] = barcodeData.product?.nutriscoreScore ?? 0;
        item['grade'] = barcodeData.product?.nutritionGrades ?? 'No Grade';
        item['calories'] = barcodeData.product?.nutriments?.energy ?? 0;
        item['total fat'] = barcodeData.product?.nutriments?.fat ?? 0;
        item['saturated fat'] =
            barcodeData.product?.nutriments?.saturatedFat ?? 0;
        item['sodium'] = barcodeData.product?.nutriments?.sodium ?? 0;
        item['total carbohydrate'] =
            barcodeData.product?.nutriments?.carbohydrates ?? 0;
        item['total sugars'] = barcodeData.product?.nutriments?.sugars ?? 0;
        item['protein'] = barcodeData.product?.nutriments?.proteins ?? 0;
        item['fiber'] = barcodeData.product?.nutriscoreData?.fiber ?? 0;
        item['name'] = barcodeData.product?.productName! ?? 'Product';
        item['picture'] = barcodeData
                .product?.selectedImages?.front?.small?.en ??
            'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg';
        item['allergy'] = alerg;
        item['condition'] = con;
        return item;
      } else {
        return AboutDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await scanBarcodeNormal(); //adds barcode to firebase
            Map items = await itemScan(_scanBarcode);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScanPage(items)));
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
                'history',
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
                                  height: 220,
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
                                                  builder: (context) =>
                                                      productPage(
                                                          documentSnapshot[
                                                              'barcode'],
                                                          true,
                                                          favo)));
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
                                              height: 50,
                                              width: 120,
                                              alignment: Alignment.center,
                                              child: Expanded(
                                                child: Text(
                                                  '${documentSnapshot['name']}',
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            Container(
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
                                                                  'conditions']),
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
                                                                  'conditions']),
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
                                                                  'conditions']),
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
                                                                  'conditions']),
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
                                              Icons.change_circle_outlined),
                                        ),
                                      ),
                                      //recommended item
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      recoList(documentSnapshot[
                                                          'barcode'])));
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
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
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return getName(
                                                            docIDs[0]);
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
