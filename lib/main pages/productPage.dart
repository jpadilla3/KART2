import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:kart2/main%20pages/shimmerlist.dart';
import 'package:kart2/models/barcode_data_model.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  String barcode;
  bool success;
  final bool type;
  bool isFavorite;
  final Function() onFail;

  ProductPage(this.barcode, this.success, this.type, this.isFavorite,
      {super.key, required this.onFail});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  Future<void>? _processedDataFuture;
  bool _loading = true;
  Map<String, dynamic>? appBarTitleData;
  Map<String, dynamic>? productInfoData;
  Map<String, dynamic>? productImageData;
  late List? productGradeInfoData;
  Map<String, dynamic>? productNutritionInfoData;
  late StreamSubscription<DocumentSnapshot<Object?>> _streamSubscription;
  //bool get success => ProductPageState().success;

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        getCollectionReference(widget.type ? 'scanned' : 'search')
            .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        _processedDataFuture =
            processData(documentSnapshot.data() as Map<String, dynamic>);
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  // Returns Stream<DocumentSnapshot>
  Stream<DocumentSnapshot<Object?>> getCollectionReference(
      String collectionName) {
    final userDocId = FirebaseAuth.instance.currentUser!.email.toString();
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection(collectionName);
    return collectionRef.doc(widget.barcode).snapshots();
  }

  Stream<QuerySnapshot> _fetchRecommendedProducts(
      String collectionName, String barcode) {
    final userDocId = FirebaseAuth.instance.currentUser!.email.toString();

    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection(collectionName)
        .doc(barcode)
        .collection('recommended')
        .snapshots();

    return collectionRef;
  }

  // Processes the fetched data
  Future<void> processData(Map<String, dynamic> data) async {
    //print('Processing data: $data');
    final gradeData = await GradeCal()
        .gradeCalculateInfo3(data['Allergens'], data['conditions']);
    //print('Processed gradeData: $gradeData');
    setState(() {
      if (appBarTitleData != data ||
          productInfoData != data ||
          productImageData != data ||
          productGradeInfoData != gradeData ||
          productNutritionInfoData != data) {
        appBarTitleData = data;
        productInfoData = data;
        productImageData = data;
        productGradeInfoData = gradeData;
        productNutritionInfoData = data;
      }
      _loading = false;
    });
  }

  void snackMessage(bool action, String barcode) {
    //true for delete
    //false for favorite
    if (action == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You have successfully deleted $barcode"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added $barcode to favorites"),
      ));
    }
  }

  Widget _fetchAppBarTitleData() {
    if (appBarTitleData != null) {
      return Text(
        '${appBarTitleData?['brand']}',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return const CircularProgressIndicator(); 
    }
  }

  Widget _fetchProductInfoData() {
    if (productInfoData != null) {
      return Column(
        children: [
          Container(
            height: 50,
            width: 180,
            child: Text(
              productInfoData?['name'] ?? 'Unknown Name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: false,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 150,
            child:
                ScoreColors().scorePic(productInfoData?['nutrition']['grade']),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _fetchProductImageData() {
    if (productImageData != null) {
      return Column(
        children: [
          SizedBox.square(
              dimension: 180,
              child: Image.network('${productImageData?['picture']}')),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _fetchProductGradeInfoData() {
    if (productGradeInfoData != null) {
      return Column(
        children: [
          Row(
            //vegan
            children: [
              const SizedBox(
                width: 35,
              ),
              ScoreColors().scoreInfo2(productGradeInfoData?[0]),
            ],
          ),
          Row(
            //vegetarian
            children: [
              const SizedBox(
                width: 35,
              ),
              ScoreColors().scoreInfo2(productGradeInfoData?[1]),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 25,
              ),
              ScoreColors().scoreInfo3(productGradeInfoData?[2]),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
              ),
              ScoreColors().scoreInfo(productGradeInfoData?[3]),
            ],
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _fetchProductNutritionInfoData() {
    if (productNutritionInfoData != null) {
      return Column(
        children: [
          rowInfo(
            "Calories",
            '${double.parse(productNutritionInfoData?['nutrition']['calories']).toStringAsFixed(0)} kcals',
            Icon(
              Ionicons.flame_outline,
              size: 30,
              color: Colors.grey[600],
            ),
          ),
          ExpansionTile(
            title: const Text("Total Fat"),
            leading: const Icon(
              Ionicons.water_outline,
              size: 30,
            ),
            trailing: SizedBox(
              height: 60,
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${double.parse(productNutritionInfoData?['nutrition']['total fat']).toStringAsFixed(1)} g',
                  ),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 60),
            children: [
              ListTile(
                title: const Text('Saturated Fat'),
                leading: const Icon(
                  Ionicons.water_outline,
                  color: Colors.black,
                ),
                trailing: Text(
                    '${double.parse(productNutritionInfoData?['nutrition']['saturated fat']).toStringAsFixed(1)} g'),
              ),
              ListTile(
                title: const Text('Trans Fat'),
                leading: const Icon(
                  Ionicons.water_outline,
                  color: Colors.black,
                ),
                trailing: Text(
                    '${double.parse(productNutritionInfoData?['nutrition']['trans fat']).toStringAsFixed(1)} g'),
              ),
            ],
          ),
          rowInfo(
            "Sodium",
            '${double.parse(productNutritionInfoData?['nutrition']['sodium']).toStringAsFixed(1)} g',
            Icon(
              MaterialCommunityIcons.shaker_outline,
              size: 30,
              color: Colors.grey[600],
            ),
          ),
          ExpansionTile(
            title: const Text("Total Carbohydrate"),
            leading: const Icon(
              Icons.cookie_outlined,
              size: 30,
            ),
            trailing: SizedBox(
              height: 60,
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      '${double.parse(productNutritionInfoData?['nutrition']['total carbohydrate']).toStringAsFixed(1)} g'),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 60),
            children: [
              ListTile(
                title: const Text('Dietary Fiber'),
                leading: const Icon(
                  MaterialIcons.accessibility_new,
                  color: Colors.black,
                ),
                trailing: Text(
                    '${double.parse(productNutritionInfoData?['nutrition']['fiber']).toStringAsFixed(1)} g'),
              ),
              ListTile(
                title: const Text('Total Sugars'),
                leading: const Icon(
                  Ionicons.cube_outline,
                  color: Colors.black,
                ),
                trailing: Text(
                    '${double.parse(productNutritionInfoData?['nutrition']['total sugars']).toStringAsFixed(1)} g'),
              ),
            ],
          ),
          rowInfo(
            "Protein",
            '${double.parse(productNutritionInfoData?['nutrition']['protein']).toStringAsFixed(1)} g',
            Icon(
              MaterialCommunityIcons.food_steak,
              size: 30,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future favoriteItem(String barcode) async {
    Map<String, dynamic> item = {};
    late List<String> con = [];
    late List<String> alerg = [];
    int count = 0;
    int count2 = 0;
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);

    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
        if (barcodeData.product!.allergensTagsEn!.isNotEmpty) {
          for (int i = 0;
              i < barcodeData.product!.allergensTagsEn!.length;
              i++) {
            alerg.add(barcodeData.product!.allergensTagsEn![i].substring(3));
          }
        }
        if (barcodeData.product!.allergensTagsEn!.contains('en:milk') ||
            barcodeData.product!.allergensTagsEn!.contains('en:lactic')) {
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
        item['grade'] = barcodeData.product?.nutritionGrades ?? 'No Grade';
        item['name'] = barcodeData.product?.productName ?? 'Product';
        item['picture'] = barcodeData
                .product?.selectedImages?.front?.small?.en ??
            'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg';
        item['ID'] = widget.type;
        item['barcode'] = barcode;
        item['Allergens'] = alerg;
        item['conditions'] = con;
        return item;
      } else {
        return const AboutDialog();
      }
    }
  }

  rowInfo(String title, String amount, Icon pic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: SizedBox.square(
              dimension: 60,
              child: pic,
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey))),
              child: SizedBox(
                height: 60,
                width: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey))),
                child: SizedBox(
                  height: 60,
                  width: 102,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          amount,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print('success: ${widget.success}');
    if (widget.success == false) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('An error occurred while loading the product details.')),
        );
        //Call the callback function to pop the ProductPage
        widget.onFail();
      });
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        title: _fetchAppBarTitleData(),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.indigo[400],
            )),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  widget.isFavorite = !widget.isFavorite;
                });
                Map item = await favoriteItem(widget.barcode);
                widget.isFavorite
                    ? FirebaseCommands().favoriteBarcode(
                        item['barcode'],
                        item['name'],
                        item['grade'],
                        item['ID'],
                        item['picture'],
                        item['Allergens'],
                        item['conditions'])
                    : FirebaseCommands().removeFavorite(widget.barcode);

                widget.isFavorite
                    ? snackMessage(false, widget.barcode)
                    : const Text('');
              },
              icon: widget.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.indigo[400],
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.indigo[400],
                    )),
          IconButton(
              onPressed: () async {
                FirebaseCommands()
                    .destroyRecommendations(widget.barcode, widget.type);
                FirebaseCommands().destroyBarcode(widget.barcode, widget.type);
                FirebaseCommands().removeFavorite(widget.barcode);
                snackMessage(true, widget.barcode);
                Navigator.pop(context);
              },
              icon: Icon(
                Ionicons.trash_outline,
                color: Colors.indigo[400],
              ))
        ],
      ),
      //new Builder(builder: (BuildContext context) {}),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getCollectionReference(widget.type ? 'scanned' : 'search'),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.exists) {
            //print('Snapshot data: ${snapshot.data!.data()}');

            return FutureBuilder(
              future: _processedDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _fetchProductImageData(),
                            const SizedBox(
                              height: 10,
                            ),
                            _fetchProductInfoData(),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        _fetchProductGradeInfoData(),
                        const SizedBox(
                          height: 20,
                        ),
                        _fetchProductNutritionInfoData(),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _fetchRecommendedProducts(
                              widget.type ? 'scanned' : 'search',
                              widget.barcode),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            // Checks if there are any recommended products
                            bool hasRecommendedProducts =
                                snapshot.data!.docs.isNotEmpty;

                            return Column(
                              children: [
                                // Only displays the Recommendations title if there are recommended products
                                if (hasRecommendedProducts)
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Recommendations",
                                            style: GoogleFonts.bebasNeue(
                                                fontSize: 35),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (hasRecommendedProducts)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (hasRecommendedProducts)
                                  SizedBox(
                                    height: 210,
                                    child: ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot doc =
                                            snapshot.data!.docs[index];
                                        String imageUrl = doc.get(
                                            'picture'); 
                                        String title = doc.get(
                                            'name'); 
                                        String barcode = doc.get(
                                            'barcode'); 

                                        return InkWell(
                                          onTap: () async {
                                            await FirebaseCommands().addBarcode(
                                                barcode, widget.type);

                                            bool isFavorite =
                                                await FirebaseCommands()
                                                    .isProductFavorite(
                                                        barcode); 

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductPage(
                                                            barcode, //barcode
                                                            true, //success
                                                            widget.type, //type
                                                            isFavorite, //isFavorite
                                                            onFail: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop())));
                                          },
                                          child: Container(
                                            height: 225,
                                            width: 210,
                                            child: Card(
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 160,
                                                    width: 200,
                                                    color: Colors.transparent,
                                                    child: imageUrl.isNotEmpty
                                                        ? Image.network(
                                                            imageUrl,
                                                            fit: BoxFit.contain)
                                                        : const Center(
                                                            child: Text(
                                                                'No picture')),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          title,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  Widget buildPicShimmer() => Container(
          child: SizedBox.square(
        dimension: 120,
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            width: 80,
            color: Colors.grey,
          ),
        ),
      ));
  Widget buildTextShimmer() => Container(
        child: ShimmerLoader.rectangular(width: 150, height: 16),
      );

  Widget buildNutShimmer() => Center(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
          ],
        ),
      );
}
