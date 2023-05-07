import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fires;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/main%20pages/productPage.dart';
import 'package:kart2/main%20pages/scan_page.dart';
import 'package:kart2/main%20pages/search_product_page.dart';

import 'package:kart2/models/barcode_data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/models/firebase_commands.dart' as fire;
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shimmer/shimmer.dart';

import '../models/firebase_commands.dart';
import 'shimmerlist.dart';

List<String> prevSearch = [];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  //String _scanBarcode = '';
  //late Future<BarcodeData> futureBarcodeData;
  bool isFavorite = false;
  bool type = false;
  //String? _lastScannedBarcode;
  final CollectionReference _barcodes = FirebaseFirestore.instance
      .collection('users')
      .doc(fires.FirebaseAuth.instance.currentUser!.email.toString())
      .collection('search');

  Future favs(barcode) async {
    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fires.FirebaseAuth.instance.currentUser!.email.toString())
        .collection('favorties')
        .doc(barcode)
        .get();

    if (favDoc.exists) {
      return isFavorite = true;
    } else {
      return isFavorite = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanAndProcessBarcode() async {
    String barcodeScanRes;
    bool success;
    // try/catch PlatformException in case platform fails
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      success = await FirebaseCommands().addBarcode(barcodeScanRes, true);
      print('success: $success');
    } on PlatformException catch (e) {
      barcodeScanRes = 'Failed to scan barcode: $e';
      success = false;
    }
    bool isFavorite =
        await FirebaseCommands().isProductFavorite(barcodeScanRes);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
            barcodeScanRes, success, true, isFavorite,
            onFail: () => Navigator.of(context).pop()),
      ),
    ).then((result) {
      if (result is bool && !result) {
        // Show an error message, e.g., using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('An error occurred while loading the product details.')),
        );
      }
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      //_scanBarcode = barcodeScanRes;
      //addBarcodeSucess = success;
      //print('addBarcodeSuccess1: $addBarcodeSucess');
      //isLoading = false;
      //type = true;
      //_lastScannedBarcode = barcodeScanRes;
    });
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

  // Future itemScan(String barcode) async {
  //   Map<String, dynamic> item = {};
  //   List<String> alerg = [];
  //   List<String> con = [];
  //   int count = 0;
  //   int count2 = 0;
  //   final String url =
  //       'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
  //   final response = await http.get(Uri.parse(url));
  //   final barcodeData = barcodeDataFromJson(response.body);

  //   if (response.statusCode == 200) {
  //     if (int.parse(barcode) > 0) {
  //       if (barcodeData.product!.allergensTagsEn!.isNotEmpty) {
  //         for (int i = 0;
  //             i < barcodeData.product!.allergensTagsEn!.length;
  //             i++) {
  //           alerg.add(barcodeData.product!.allergensTagsEn![i].substring(3));
  //         }
  //       }
  //       if (barcodeData.product!.allergensTagsEn!.contains('en:milk') ||
  //           barcodeData.product!.allergensTagsEn!.contains('en:lactic')) {
  //         con.add('lactose intolerant');
  //       }

  //       for (final ingredient in barcodeData.product!.ingredients!) {
  //         if (ingredient.vegan != 'yes') {
  //           count++;
  //         }
  //         if (ingredient.vegetarian != 'yes') {
  //           count2++;
  //         }
  //       }
  //       if (count == 0) {
  //         con.add('vegan');
  //       }
  //       if (count2 == 0) {
  //         con.add('vegetarian');
  //       }
  //       item['brand'] =
  //           barcodeData.product?.brands ?? barcodeData.product?.productName!;
  //       item['id'] = false;
  //       item['categories'] = barcodeData.product?.categoriesTagsEn;
  //       item['score'] = barcodeData.product?.nutriscoreScore ?? 0.toString();
  //       item['grade'] = barcodeData.product?.nutritionGrades ?? 'No Grade';
  //       item['calories'] =
  //           barcodeData.product?.nutriments?.energyPerServing ?? 0.toString();
  //       item['total fat'] =
  //           barcodeData.product?.nutriments?.fatPerServing ?? 0.toString();
  //       item['saturated fat'] =
  //           barcodeData.product?.nutriments?.saturatedFatPerServing ??
  //               0.toString();
  //       item['trans fat'] =
  //           barcodeData.product?.nutriments?.transFatPerServing ?? 0.toString();
  //       item['sodium'] =
  //           barcodeData.product?.nutriments?.sodiumPerServing ?? 0.toString();
  //       item['total carbohydrate'] =
  //           barcodeData.product?.nutriments?.carbohydratesPerServing ??
  //               0.toString();
  //       item['total sugars'] =
  //           barcodeData.product?.nutriments?.sugarsPerServing ?? 0.toString();
  //       item['protein'] =
  //           barcodeData.product?.nutriments?.proteinsPerServing ?? 0.toString();
  //       item['fiber'] =
  //           barcodeData.product?.nutriments?.fiberPerServing ?? 0.toString();
  //       item['name'] = barcodeData.product?.productName! ?? 'Product';
  //       item['picture'] = barcodeData
  //               .product?.selectedImages?.front?.small?.en ??
  //           'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg';
  //       item['allergy'] = alerg;
  //       item['condition'] = con;
  //       return item;
  //     } else {
  //       return const AboutDialog();
  //     }
  //   }
  // }

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
                        await scanAndProcessBarcode(); //adds barcode to firebase
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
                                                        'Allergens'],
                                                    documentSnapshot[
                                                        'conditions']);
                                          },
                                          backgroundColor: Colors.red,
                                          icon: Icons.favorite,
                                        ),
                                        SlidableAction(
                                          onPressed: (context) async {
                                            snackMessage(true,
                                                documentSnapshot['barcode']);
                                            await FirebaseCommands()
                                                .destroyRecommendations(
                                                    documentSnapshot['barcode'],
                                                    type);
                                            FirebaseCommands().destroyBarcode(
                                                documentSnapshot['barcode'],
                                                type);
                                            FirebaseCommands().removeFavorite(
                                                documentSnapshot['barcode']);
                                          },
                                          backgroundColor: Colors.indigo,
                                          icon: Icons.delete,
                                        ),
                                      ]),
                                  child: InkWell(
                                    highlightColor: Colors.grey[300],
                                    onTap: () async {
                                      print('type: $type');
                                      await FirebaseCommands().addBarcode(
                                          documentSnapshot['barcode'], false);
                                      isFavorite = await favs(
                                          documentSnapshot['barcode']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductPage(
                                                  documentSnapshot[
                                                      'barcode'], //barcode
                                                  true, //success
                                                  false, //type
                                                  isFavorite, //isFavorite
                                                  onFail: () =>
                                                      Navigator.of(context)
                                                          .pop())));
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
                                                child: SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Image.network(
                                                      '${documentSnapshot['picture']}'),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 155,
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
                                                    SizedBox(
                                                      height: 50,
                                                      width: 75,
                                                      child: ScoreColors()
                                                          .scorePic(
                                                              documentSnapshot[
                                                                      'nutrition']
                                                                  ['grade']),
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
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            '${snapshot.error} occurred');
                                                      } else {
                                                        final data = snapshot
                                                            .data as List<bool>;

                                                        if (data[0] == false) {
                                                          return const SizedBox(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 2),
                                                              child: Icon(
                                                                Icons
                                                                    .energy_savings_leaf,
                                                                color: Colors
                                                                    .green,
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
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            '${snapshot.error} occurred');
                                                      } else {
                                                        final data = snapshot
                                                            .data as List<bool>;

                                                        if (data[1] == false) {
                                                          return const SizedBox(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 2),
                                                              child: Icon(
                                                                Icons
                                                                    .eco_outlined,
                                                                color: Colors
                                                                    .green,
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
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            '${snapshot.error} occurred');
                                                      } else {
                                                        final data = snapshot
                                                            .data as List<bool>;

                                                        if (data[2] == true) {
                                                          return SizedBox(
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            2),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/milk.png',
                                                                  width: 30,
                                                                  height: 30,
                                                                )),
                                                          );
                                                        } else {
                                                          return const Text('');
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
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            '${snapshot.error} occurred');
                                                      } else {
                                                        final data = snapshot
                                                            .data as List<bool>;

                                                        if (data[3] == true) {
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
                              SizedBox(
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
  List<List<String>> cond = [];

  Future getSearch(String word, bool type) async {
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

    for (int i = 0; i < 20; i++) {
      if (result.products?[i].barcode == null ||
          result.products?[i].barcode == '') {
        break;
      }
      bar.add('${result.products?[i].barcode}');

      data.add({
        "brand": result.products?[i].brands ?? result.products?[i].productName,
        "name": result.products?[i].productName ?? "null",
        "grade": result.products?[i].nutriscore ?? "No Grade",
        "id": type,
        "barcode": result.products?[i].barcode ?? 'null',
        "categories": result.products?[i].categoriesTags,
        "pic": result.products?[i].imageFrontSmallUrl ??
            'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
        "ingredients": result.products?[i].ingredientsText,
        "nutrients": {
          'calories': result.products?[i].nutriments
                  ?.getValue(Nutrient.energyKCal, PerSize.serving) ??
              0.toString(),
          "total fat": result.products?[i].nutriments
                  ?.getValue(Nutrient.fat, PerSize.serving) ??
              0.toString(),
          "saturated fat": result.products?[i].nutriments
                  ?.getValue(Nutrient.saturatedFat, PerSize.serving) ??
              0.toString(),
          "trans fat": result.products?[i].nutriments
                  ?.getValue(Nutrient.transFat, PerSize.serving) ??
              0.toString(),
          "sodium": result.products?[i].nutriments
                  ?.getValue(Nutrient.sodium, PerSize.serving) ??
              0.toString(),
          "total carb": result.products?[i].nutriments
                  ?.getValue(Nutrient.carbohydrates, PerSize.serving) ??
              0.toString(),
          "fiber": result.products?[i].nutriments
                  ?.getValue(Nutrient.fiber, PerSize.serving) ??
              0.toString(),
          "sugar": result.products?[i].nutriments
                  ?.getValue(Nutrient.sugars, PerSize.serving) ??
              0.toString(),
          "protein": result.products?[i].nutriments
                  ?.getValue(Nutrient.proteins, PerSize.serving) ??
              0.toString(),
        },
        "conditions": {
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

      print("${data[i]['name']} : ${data[i]['conditions']['vegan']}");
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
            future: getSearch(query, false),
            builder: (context, snaphsot) {
              if (snaphsot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        highlightColor: Colors.grey[300],
                        onTap: () async {
                          // FirebaseCommands().searchBarcode(
                          //     data[index]['barcode'], data[index]);
                          await FirebaseCommands()
                              .addBarcode(data[index]['barcode'], false);
                          SearchPageState().isFavorite = await SearchPageState()
                              .favs(data[index]['barcode']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                      data[index]['barcode'], //barcode
                                      true, //success
                                      false, //type
                                      SearchPageState().isFavorite, //isFavorite
                                      onFail: () =>
                                          Navigator.of(context).pop())));

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
                                      height: 70,
                                      width: 70,
                                      child: Image.network(
                                          '${data[index]['pic']}'),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              width: 155,
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
                                        SizedBox(
                                          height: 50,
                                          width: 75,
                                          child: ScoreColors()
                                              .scorePic(data[index]['grade']),
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
                                  //vegan
                                  FutureBuilder(
                                      future: GradeCal().gradeCalculate2(
                                          data[index]['allergens'],
                                          data[index]['conditions']['vegan'],
                                          data[index]['conditions']
                                              ['vegetarian']),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                '${snapshot.error} occurred');
                                          } else {
                                            final data =
                                                snapshot.data as List<bool>;

                                            if (data[0] == false) {
                                              return const SizedBox(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 2),
                                                  child: Icon(
                                                    Icons.energy_savings_leaf,
                                                    color: Colors.green,
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

                                  //vegetarian
                                  FutureBuilder(
                                      future: GradeCal().gradeCalculate2(
                                          data[index]['allergens'],
                                          data[index]['conditions']['vegan'],
                                          data[index]['conditions']
                                              ['vegetarian']),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                '${snapshot.error} occurred');
                                          } else {
                                            final data =
                                                snapshot.data as List<bool>;

                                            if (data[1] == false) {
                                              return const SizedBox(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 2),
                                                  child: Icon(
                                                    Icons.eco_outlined,
                                                    color: Colors.green,
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

                                  //lactose intolerant
                                  FutureBuilder(
                                      future: GradeCal().gradeCalculate2(
                                          data[index]['allergens'],
                                          data[index]['conditions']['vegan'],
                                          data[index]['conditions']
                                              ['vegetarian']),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                '${snapshot.error} occurred');
                                          } else {
                                            final data =
                                                snapshot.data as List<bool>;

                                            if (data[2] == true) {
                                              return SizedBox(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 2),
                                                    child: Image.asset(
                                                      'assets/images/milk.png',
                                                      width: 30,
                                                      height: 30,
                                                    )),
                                              );
                                            } else {
                                              return const Text('');
                                            }
                                          }
                                        } else {
                                          return const Text('');
                                        }
                                      }),

                                  //allergy
                                  FutureBuilder(
                                      future: GradeCal().gradeCalculate2(
                                          data[index]['allergens'],
                                          data[index]['conditions']['vegan'],
                                          data[index]['conditions']
                                              ['vegetarian']),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                '${snapshot.error} occurred');
                                          } else {
                                            final data =
                                                snapshot.data as List<bool>;

                                            if (data[3] == true) {
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
