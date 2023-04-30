import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fires;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/search_product_page.dart';

import 'package:kart2/models/barcode_data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/models/firebase_commands.dart' as fire;
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shimmer/shimmer.dart';

import 'shimmerlist.dart';

List<String> prevSearch = [];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _scanBarcode = '';
  late Future<BarcodeData> futureBarcodeData;

  Future getSuggestion(String word) async {
    ProductSearchQueryConfiguration config = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: <Parameter>[
          SearchTerms(terms: [word]),
          const SortBy(
            option: SortOption.NUTRISCORE,
          ),
        ],
        version: ProductQueryVersion.v3);

    SearchResult result = await OpenFoodAPIClient.searchProducts(
        User(userId: 'jpadilla3', password: 'abc123!'), config);

    for (int i = 0; i < 5; i++) {
      print(
          "${result.products?[i].productName} : ${result.products?[i].barcode}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      //add barcode to firebase
      //passes current user email and barcode
      fire.FirebaseCommands().addBarcode(barcodeScanRes);
      fire.FirebaseCommands().getSimilarProducts(barcodeScanRes);
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

  final CollectionReference _barcodes = FirebaseFirestore.instance
      .collection('users')
      .doc(fires.FirebaseAuth.instance.currentUser!.email.toString())
      .collection('search');

  //fetchBarcodeData function gets the data with certian fields from barcode and parses it.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(''),
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          minimum: EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate());
                    },
                    child: Container(
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.indigo),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Search',
                              style: GoogleFonts.bebasNeue(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(children: [
                Container(
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.indigo[400],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: IconButton(
                      onPressed: () async {
                        await scanBarcodeNormal();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const navBar()));
                      },
                      icon: const Icon(
                        Icons.photo_camera_rounded,
                        color: Colors.white,
                      )),
                ),
              ])
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
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
                                return Slidable(
                                  endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            snackMessage(false,
                                                documentSnapshot['barcode']);
                                            fire.FirebaseCommands()
                                                .favoriteBarcode(
                                                    documentSnapshot['barcode'],
                                                    documentSnapshot['name'],
                                                    documentSnapshot[
                                                        'nutrition']['grade'],
                                                    false,
                                                    documentSnapshot['picture'],
                                                    documentSnapshot[
                                                        'Allergens']);
                                          },
                                          backgroundColor: Colors.red,
                                          icon: Icons.favorite,
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            snackMessage(true,
                                                documentSnapshot['barcode']);
                                            fire.FirebaseCommands()
                                                .destroyBarcode(
                                                    documentSnapshot['barcode'],
                                                    false);
                                            fire.FirebaseCommands()
                                                .removeFavorite(
                                                    documentSnapshot[
                                                        'barcode']);
                                          },
                                          backgroundColor: Colors.indigo,
                                          icon: Icons.delete,
                                        ),
                                      ]),
                                  child: InkWell(
                                    highlightColor: Colors.grey[300],
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => productPage(
                                                  documentSnapshot['barcode'],
                                                  false)));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                                        documentSnapshot[
                                                            'name'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        documentSnapshot[
                                                                'nutrition']
                                                            ['grade']),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        'Grade: ${documentSnapshot['nutrition']['grade'].toUpperCase()}',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FutureBuilder(
                                                  future: GradeCal()
                                                      .gradeCalculate(
                                                          documentSnapshot[
                                                              'Allergens']),
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            '${snapshot.error} occurred');
                                                      } else {
                                                        final data = snapshot
                                                            .data as bool;

                                                        if (data == true) {
                                                          return const SizedBox(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 2),
                                                              child: Icon(
                                                                Icons
                                                                    .info_outline,
                                                                color:
                                                                    Colors.red,
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
                                                  padding: EdgeInsets.only(
                                                      right: 10),
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
                              });
                        } else {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 200,
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                child: Image.asset("assets/images/Search.png"),
                              ),
                              Text(
                                "Enter a Search",
                                style: GoogleFonts.bebasNeue(
                                    color: Colors.black, fontSize: 30),
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
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> bar = [];
  List<Map<String, dynamic>> data = [];
  Future getSearch(String word) async {
    ProductSearchQueryConfiguration config = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: <Parameter>[
          SearchTerms(terms: [word]),
          const SortBy(
            option: SortOption.POPULARITY,
          ),
          TagFilter.fromType(
              tagFilterType: TagFilterType.COUNTRIES, tagName: 'united-states'),
        ],
        version: ProductQueryVersion.v3);

    SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: 'jpadilla3', password: 'abc123!'), config);

    bool vegan = false;
    bool vegetarian = false;

    for (int i = 0; i < 20; i++) {
      bar.add('${result.products?[i].barcode}');

      data.add({
        "brand": result.products?[i].brands ?? result.products?[i].productName,
        "name": result.products?[i].productName ?? "null",
        "grade": result.products?[i].nutriscore ?? "Not Avaliable",
        "barcode": result.products?[i].barcode ?? 'null',
        "pic": result.products?[i].imageFrontUrl ??
            'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
        "ingredients": result.products?[i].ingredientsText,
        "nutrients": {
          'calories': result.products?[i].nutriments
                  ?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) ??
              0,
          "total fat": result.products?[i].nutriments
                  ?.getValue(Nutrient.fat, PerSize.oneHundredGrams) ??
              0,
          "saturated fat": result.products?[i].nutriments
                  ?.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams) ??
              0,
          "sodium": result.products?[i].nutriments
                  ?.getValue(Nutrient.sodium, PerSize.oneHundredGrams) ??
              0,
          "total carb": result.products?[i].nutriments
                  ?.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams) ??
              0,
          "fiber": result.products?[i].nutriments
                  ?.getValue(Nutrient.fiber, PerSize.oneHundredGrams) ??
              0,
          "sugar": result.products?[i].nutriments
                  ?.getValue(Nutrient.sugars, PerSize.oneHundredGrams) ??
              0,
          "protein": result.products?[i].nutriments
                  ?.getValue(Nutrient.proteins, PerSize.oneHundredGrams) ??
              0,
          "vegan": result.products?[i].ingredientsAnalysisTags?.veganStatus
                  .toString() ??
              "VeganStatus.NON_VEGAN",
          "vegetarian": result
                  .products?[i].ingredientsAnalysisTags?.vegetarianStatus
                  .toString() ??
              "VegetarianStatus.NON_VEGETARIAN",
        },
        "allergens": result.products?[i].allergens?.names ?? "Not avaliable",
      });

      print("${data[i]['name']} : ${data[i]['barcode']}");
    }
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () => close(context, null));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            if (prevSearch.contains(query)) {
              int pos = prevSearch.indexOf(query);
              final String first = prevSearch.removeAt(pos);
              prevSearch.add(first);
            } else {
              prevSearch.add(query);
            }

            showResults(context);
            data.clear();
            //getSuggestion(query);
          },
        )
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: prevSearch.length,
        itemBuilder: (context, index) {
          var revSearch = List.from(prevSearch.reversed);
          final suggestion = revSearch[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              if (prevSearch.contains(query)) {
                int pos = prevSearch.indexOf(query);
                final String first = prevSearch.removeAt(pos);
                prevSearch.add(first);
              } else {
                prevSearch.add(query);
              }
              showResults(context);
              data.clear();
            },
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(
        child: FutureBuilder(
            future: getSearch(query),
            builder: (context, snaphsot) {
              if (snaphsot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        highlightColor: Colors.grey[300],
                        onTap: () {
                          fire.FirebaseCommands().searchBarcode(
                              data[index]['barcode'], data[index]);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      searchProduct(data[index])));
                          Timer(const Duration(seconds: 1), () {
                            data.clear();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                          '${data[index]['pic']}'),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              width: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          data[index]['name'],
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        scoreColors()
                                            .scoreColor(data[index]['grade']),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Grade: ${data[index]['grade'].toUpperCase()}',
                                            textAlign: TextAlign.start,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FutureBuilder(
                                      future: GradeCal().gradeCalculate(
                                          data[index]['allergens']),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                '${snapshot.error} occurred');
                                          } else {
                                            final data = snapshot.data as bool;

                                            if (data == true) {
                                              return const SizedBox(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 2),
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
                      );
                    });
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
            }),
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
