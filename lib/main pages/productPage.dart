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
  final String barcode;
  final bool type;
  bool fav;
  ProductPage(this.barcode, this.type, this.fav, {super.key});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  bool _loading = true;
  Map<String, dynamic>? appBarTitleData;
  Map<String, dynamic>? productInfoData;
  Map<String, dynamic>? productImageData;
  List? productGradeInfoData;
  Map<String, dynamic>? productNutritionInfoData;

  // Future<void> fetchData() async {
  //   final collectionRef =
  //       await getCollectionReference(widget.type ? 'scanned' : 'search');
  //   final documentSnapshot = await collectionRef.doc(widget.barcode).get();

  //   if (documentSnapshot.exists) {
  //     final data = documentSnapshot.data() as Map<String, dynamic>;
  //     final gradeData = await GradeCal()
  //         .gradeCalculateInfo(data['Allergens'], data['conditions']);
  //     if (mounted) {
  //       setState(() {
  //         appBarTitleData = data;
  //         productInfoData = data;
  //         productImageData = data;
  //         productGradeInfoData = gradeData;
  //         productNutritionInfoData = data;
  //         _loading = false;
  //       });
  //     }
  //     print('Data fetched successfully'); // Add this print statement
  //   } else {
  //     print('Data not found'); // Add this print statement
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  // Returns Stream<DocumentSnapshot>
  Stream<DocumentSnapshot> getCollectionReference(
      String collectionName) async* {
    final userDocId = FirebaseAuth.instance.currentUser!.email.toString();
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection(collectionName);
    yield* collectionRef.doc(widget.barcode).snapshots();
  }

  // Processes the fetched data
  void processData(Map<String, dynamic> data) {
    final gradeData =
        GradeCal().gradeCalculateInfo(data['Allergens'], data['conditions']);
    setState(() {
      appBarTitleData = data;
      productInfoData = data;
      productImageData = data;
      productGradeInfoData = gradeData;
      productNutritionInfoData = data;
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
      return const CircularProgressIndicator(); // Return a loading indicator when data is not available
    }
  }

  Widget _fetchProductInfoData() {
    if (productInfoData != null) {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            productInfoData?['name'] ?? 'Unknown Name',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: false,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 70,
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
      return Image.network('${productImageData?['picture']}');
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
    List<String> con = [];
    List<String> alerg = [];
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
    return Scaffold(
      appBar: AppBar(
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
                  widget.fav = !widget.fav;
                });
                Map item = await favoriteItem(widget.barcode);
                widget.fav
                    ? FirebaseCommands().favoriteBarcode(
                        item['barcode'],
                        item['name'],
                        item['grade'],
                        item['ID'],
                        item['picture'],
                        item['Allergens'],
                        item['conditions'])
                    : FirebaseCommands().removeFavorite(widget.barcode);

                widget.fav
                    ? snackMessage(false, widget.barcode)
                    : const Text('');
              },
              icon: widget.fav
                  ? Icon(
                      Icons.favorite,
                      color: Colors.indigo[400],
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.indigo[400],
                    )),
          IconButton(
              onPressed: () {
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
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.exists) {
            processData(snapshot.data!.data() as Map<String, dynamic>);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _fetchProductImageData(),
                  const SizedBox(
                    height: 20,
                  ),
                  _fetchProductInfoData(),
                  const SizedBox(
                    height: 20,
                  ),
                  _fetchProductGradeInfoData(),
                  const SizedBox(
                    height: 20,
                  ),
                  _fetchProductNutritionInfoData(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
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
