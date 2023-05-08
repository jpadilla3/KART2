import 'dart:developer';
import 'grade_cal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kart2/models/barcode_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:kart2/models/search_data_model.dart';

class FirebaseCommands {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //add barcode to firebase
  Future addBarcode(String productBarcode, bool type) async {
    print('addBarcodeProductBarcode: $productBarcode');
    print('addBarcodeType: $type');

    List<String> alerg = [];
    List<String> con = [];
    int count = 0;
    int count2 = 0;
    String collectionName = type ? "scanned" : "search";
    print('addBarcodeCollectionName: $collectionName');

    final response = await http.get(Uri.parse(
        'https://us.openfoodfacts.org/api/v2/product/$productBarcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

    if (response.statusCode == 200) {
      final productBarcodeData = barcodeDataFromJson(response.body);
      final categoryList = productBarcodeData.product?.categoriesTagsEn;
      print('addBarcodecategoryList: $categoryList');
      // If product has no categories, it will not be added to firebase
      if (categoryList!.isNotEmpty) {
        if (productBarcodeData.product!.allergensTagsEn!.isNotEmpty) {
          for (int i = 0;
              i < productBarcodeData.product!.allergensTagsEn!.length;
              i++) {
            alerg.add(
                productBarcodeData.product!.allergensTagsEn![i].toLowerCase());
          }
        }
        if (productBarcodeData.product!.allergensTagsEn!.contains('Milk') ||
            productBarcodeData.product!.allergensTagsEn!.contains('Lactic')) {
          con.add('lactose intolerant');
        }

        for (final ingredient in productBarcodeData.product!.ingredients!) {
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

        FirebaseFirestore.instance
            .collection('users') //go to users
            .doc(FirebaseAuth.instance.currentUser!.email
                .toString()) // go to current user
            .collection(collectionName) // go to scanned or search
            .doc(productBarcode) // create barcode
            .set({
          'time': FieldValue.serverTimestamp(),
          "ID": type,
          'barcode': productBarcode,
          'brand': productBarcodeData.product?.brands ??
              productBarcodeData.product?.productName,
          'categories': productBarcodeData.product?.categoriesTagsEn,
          "nutrition": {
            'score':
                productBarcodeData.product?.nutriscoreScore ?? 0.toString(),
            'grade': productBarcodeData.product?.nutritionGrades ?? 'No Grade',
            'calories':
                productBarcodeData.product?.nutriments?.energyPerServing ??
                    0.toString(),
            'total fat':
                productBarcodeData.product?.nutriments?.fatPerServing ??
                    0.toString(),
            'saturated fat': productBarcodeData
                    .product?.nutriments?.saturatedFatPerServing ??
                0.toString(),
            'trans fat':
                productBarcodeData.product?.nutriments?.transFatPerServing ??
                    0.toString(),
            'sodium':
                productBarcodeData.product?.nutriments?.sodiumPerServing ??
                    0.toString(),
            'total carbohydrate': productBarcodeData
                    .product?.nutriments?.carbohydratesPerServing ??
                0.toString(),
            'total sugars':
                productBarcodeData.product?.nutriments?.sugarsPerServing ??
                    0.toString(),
            'protein':
                productBarcodeData.product?.nutriments?.proteinsPerServing ??
                    0.toString(),
            'fiber': productBarcodeData.product?.nutriments?.fiberPerServing ??
                0.toString(),
          },
          "Allergens": alerg, //set allergens
          "conditions": con, //set conditions
          'name': productBarcodeData.product?.productName ?? 'Product',
          'picture': productBarcodeData
                  .product?.selectedImages?.front?.small?.en ??
              productBarcodeData.product?.imageFrontThumbUrl ??
              'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
        });
        //Gets similar products for the barcode
        getSimilarProducts(productBarcode, categoryList, type, collectionName);

        return true;
      } else {
        //CHANGE SO IT GOES BACK TO EITHER RECOMMENDATIONS PAGE OR SEARCH PAGE DEPENDING WHERE IT CAME FROM
        print('Categories not found for barcode $productBarcode');
        return false;
      }
    } else {
      //CHANGE SO IT GOES BACK TO EITHER RECOMMENDATIONS PAGE OR SEARCH PAGE DEPENDING WHERE IT CAME FROM
      print(
          'Failed to load product details for barcode $productBarcode due to a server error with status code ${response.statusCode}');
      return false;
    }
  }

  Future getSimilarProducts(String productBarcode, List categoryList, bool type,
      String collectionName) async {
    print('getSimilarProductsType: $type');
    // print('getSimilarProductsBarcode: $barcode');
    // print('getSimilarProductsbarcodeData: $barcodeData');
    print('getSimilarProductsCategoryList: $categoryList');
    print('getSimilarProductsCollectionName: $collectionName');
    int recommendationsAdded = 0;

    // Calculates the starting index (half the length of categoryList)
    int startIndex = (categoryList.length > 1) ? categoryList.length ~/ 2 : 0;

    // List of nutrition grades
    List<String> nutritionGrades = ['a', 'b'];

    // Loops from the end of the list and iterates to the startIndex
    for (int i = categoryList.length - 1; i >= startIndex; i--) {
      //If the number of recommendations added reaches 50, breaks out of the loop
      if (recommendationsAdded >= 50) {
        break;
      }

      final categoryString = categoryList[i];
      final encodedCategory = Uri.encodeQueryComponent(categoryString);

      //Loops through nutritionGrades
      for (String grade in nutritionGrades) {
        try {
          final similarProductsResponse = await http
              .get(Uri.parse(
                  'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$encodedCategory&nutrition_grades_tags=$grade&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'))
              .timeout(const Duration(seconds: 3));
          if (similarProductsResponse.statusCode == 200) {
            final similarProductsData =
                searchDataFromJson(similarProductsResponse.body);
            final products = similarProductsData.products;
            bool hasProducts = products != null && products != [];

            if (hasProducts) {
              // Processes multiple products concurrently using Future.wait
              List<Future<bool>> recommendationFutures = [];
              for (final product in products) {
                print('recommendationsAdded: $recommendationsAdded');
                //If the number of recommendations added reaches 50, breaks out of the loop
                if (recommendationsAdded >= 50) {
                  break;
                }
                print('categoryString: $categoryString');
                print('encodedCategory: $encodedCategory');
                print('product.code: ${product.code}');
                print('product.nutriscoreGrade: ${product.nutriscoreGrade}');
                print('product.productName: ${product.productName}');

                recommendationFutures.add(addRecomendations(
                    productBarcode, product, type, collectionName));
              }
              // Waits for all recommendations to complete
              List<bool> addedResults =
                  await Future.wait(recommendationFutures);

              // Counts successful recommendations
              recommendationsAdded +=
                  addedResults.where((result) => result).length;
              print('recommendationsAdded: $recommendationsAdded');
            } else {
              throw Exception(
                  'Products list is empty with category: $encodedCategory');
            }
          } else {
            throw Exception(
                'Failed to load products with error ${similarProductsResponse.statusCode}');
          }
        } catch (e) {
          print(
              'Error while fetching similar products with category: $encodedCategory: $e');
          continue;
        }
      }
    }
  }

  Future<bool> addRecomendations(
      String productBarcode, product, bool type, String collectionName) async {
    print('addRecommendationsType: $type');
    print('addRecomendationsCollectionName: $collectionName');

    List<String> alerg = [];
    List<String> con = [];
    int count1 = 0;
    int count2 = 0;

    final String url =
        'https://us.openfoodfacts.org/api/v2/product/${product.code}?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final barcodeData = barcodeDataFromJson(response.body);
      final categoryList = barcodeData.product?.allergensTagsEn;

      // If product has no categories, it will not be added to firebase
      if (categoryList!.isNotEmpty) {
        if (barcodeData.product!.allergensTagsEn!.isNotEmpty) {
          for (int i = 0;
              i < barcodeData.product!.allergensTagsEn!.length;
              i++) {
            alerg.add(barcodeData.product!.allergensTagsEn![i].toLowerCase());
          }
          if (barcodeData.product!.allergensTagsEn!.contains('Milk') ||
              barcodeData.product!.allergensTagsEn!.contains('Lactic')) {
            con.add('lactose intolerant');
          }
        }

        for (final ingredient in barcodeData.product!.ingredients!) {
          if (ingredient.vegan != 'yes') {
            count1++;
          }
          if (ingredient.vegetarian != 'yes') {
            count2++;
          }
        }
        if (count1 == 0) {
          con.add('vegan');
        }
        if (count2 == 0) {
          con.add('vegetarian');
        }
        // preferencesConflicts calculates if the allergies and conditions of the product conflict with the current user
        final result = await GradeCal().preferencesConflicts(alerg, con);
        final allergyConflict = result[0];
        final conditionConflict = result[1];

        // print("Product Allergies: $alerg");
        // print("Product Conditions: $con");
        // print("Allergies Conflict?: $allergyConflict");
        // print("Conditions Conflict?: $conditionConflict");

        // If there are no allergy or condition conflicts, product will be added to firebase
        if (allergyConflict == false && conditionConflict == false) {
          // Adds product to firebase
          FirebaseFirestore.instance
              .collection('users') //goes to users
              .doc(FirebaseAuth.instance.currentUser!.email
                  .toString()) // goes to current user
              .collection(collectionName) // goes to scanned or search
              .doc(productBarcode)
              .collection('recommended')
              .doc(product.code)
              .set({
            'time': FieldValue.serverTimestamp(),
            "ID": type,
            'barcode': product.code,
            'brand':
                barcodeData.product?.brands ?? barcodeData.product?.productName,
            'categories': barcodeData.product?.categoriesTagsEn,
            "nutrition": {
              'score': barcodeData.product?.nutriscoreScore ?? 0.toString(),
              'grade': barcodeData.product?.nutritionGrades ?? 'No Grade',
              'calories': barcodeData.product?.nutriments?.energyPerServing ??
                  0.toString(),
              'total fat': barcodeData.product?.nutriments?.fatPerServing ??
                  0.toString(),
              'saturated fat':
                  barcodeData.product?.nutriments?.saturatedFatPerServing ??
                      0.toString(),
              'trans fat':
                  barcodeData.product?.nutriments?.transFatPerServing ??
                      0.toString(),
              'sodium': barcodeData.product?.nutriments?.sodiumPerServing ??
                  0.toString(),
              'total carbohydrate':
                  barcodeData.product?.nutriments?.carbohydratesPerServing ??
                      0.toString(),
              'total sugars':
                  barcodeData.product?.nutriments?.sugarsPerServing ??
                      0.toString(),
              'protein': barcodeData.product?.nutriments?.proteinsPerServing ??
                  0.toString(),
              'fiber': barcodeData.product?.nutriments?.fiberPerServing ??
                  0.toString(),
            },
            "Allergens": alerg, //sets allergens
            "conditions": con, //sets conditions
            'name': product?.productName ?? 'Product',
            'picture': product?.selectedImages?.front?.small?.en ??
                product?.imageFrontThumbUrl ??
                'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
          });
          // Returns true if the recommendation was added
          return true;
        } else {
          print(
              'Allergens/Conditions conflict found with product ${product.code}. Not added to firestore.');
          //return false;
        }
      } else {
        print(
            'Categories not found for barcode ${product.code}. Not added to firestore.');
        //return false;
      }
    } else {
      print(
          'Failed to load product details for barcode ${product.code} due to a server error with status code ${response.statusCode}. Not added to firestore.');
      //return false;
    }
    // Returns false if the recommendation was not added
    return false;
  }

  // Future getSimilarProducts2(barcode, barcodeData, categoryList) async {
  //   print('getSimilarProducts2Barcode: $barcode');
  //   print('getSimilarProducts2barcodeData: $barcodeData');
  //   print('getSimilarProducts2CategoryList: $categoryList');
  //   //int count = 0;

  //   for (int i = categoryList.length - 1; i >= 0; i--) {
  //     final categoryString = categoryList[i];

  //     final encodedCategory = Uri.encodeQueryComponent(categoryString);
  //     print('encodedCategory $encodedCategory');

  //     final similarProductsResponse = await http.get(Uri.parse(
  //         'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$encodedCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

  //     if (similarProductsResponse.statusCode == 200) {
  //       final similarProductsData =
  //           searchDataFromJson(similarProductsResponse.body);
  //       final products = similarProductsData.products;
  //       bool hasProducts = products != null && products != [];

  //       if (hasProducts) {
  //         for (final product in products) {
  //           print(categoryString);
  //           print(encodedCategory);
  //           print(product.code);
  //           print(product.nutriscoreGrade);
  //           print(product.productName);
  //           addRecomendations(barcode, product);
  //           //count++;
  //           //print(count);
  //           // if (count == 50) {
  //           //   break;
  //           // }
  //         }
  //       } else {
  //         throw Exception(
  //             'Failed to load products with category: $encodedCategory');
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to load products with error ${similarProductsResponse.statusCode}');
  //     }
  //   }
  // }

  Future addUser() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .set({'username': FirebaseAuth.instance.currentUser!.email.toString()});
  }

  Future updateUser2() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({
      'Allergies': {
        'Gluten': false,
        'Lupin': false,
        'Celery': false,
        'Fish': false,
        'Crustaceans': false,
        'Sesame-Seeds': false,
        'Molluscs': false,
        'Peanuts (Nuts)': false,
        'Soybeans': false,
        'Mustard': false,
        'Eggs': false,
      },
      'Conditions': {
        'Vegan': false,
        'Vegetarian': false,
        'Lactose Intolerant': false,
      }
    });
  }

  Future updateUser(Map userData, userData2) async {
    var list = userData.values.toList();
    var list2 = userData2.values.toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({
      'Allergies': {
        'Gluten': list[0],
        'Lupin': list[1],
        'Celery': list[2],
        'Fish': list[3],
        'Crustaceans': list[4],
        'Sesame-Seeds': list[5],
        'Molluscs': list[6],
        'Peanuts': list[7],
        'Nuts': list[8],
        'Soybeans': list[9],
        'Mustard': list[10],
        'Eggs': list[11],
      },
      'Conditions': {
        'Vegan': list2[0],
        'Vegetarian': list2[1],
        'Lactose Intolerant': list2[2],
      }
    });
  }

  Future searchBarcode(String barcode, Map data) async {
    bool vegan = false;
    bool vegetarian = true;
    List<String> con = [];

    if (data['conditions']['vegetarian']
            .contains('VegetarianStatus.VEGETARIAN_STATUS_UNKNOWN') ||
        data['conditions']['vegetarian']
            .contains('VegetarianStatus.NON_VEGETARIAN') ||
        data['conditions']['vegetarian']
            .contains('VegetarianStatus.MAYBE_VEGETARIAN')) {
      vegetarian = false;
    } else {
      vegetarian = true;
    }

    if (data['conditions']['vegan']
            .contains('VeganStatus.VEGAN_STATUS_UNKNOWN') ||
        data['conditions']['vegan'].contains('VeganStatus.NON_VEGAN')) {
      vegan = false;
    } else {
      vegan = true;
      vegetarian = true;
    }
    if (vegan == true) {
      con.add('vegan');
    }
    if (vegetarian == true) {
      con.add('vegetarian');
    }
    if (data['allergens'].contains('milk') ||
        data['allergens'].contains('lactic') ||
        data['ingredients'].contains('lactic') ||
        data['ingredients'].contains('cheese')) {
      con.add('lactose intolerant');
    }

    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);

    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .collection('search')
            .doc(barcode)
            .set({
          'time': FieldValue.serverTimestamp(),
          "ID": false,
          "brand": data['brand'],
          'barcode': barcode,
          'name': barcodeData.product?.productName ?? 'Product',
          "nutrition": {
            'score': barcodeData.product?.nutriscoreScore ?? 0.toString(),
            'grade': barcodeData.product?.nutritionGrades ?? 'No Grade',
            'calories': barcodeData.product?.nutriments?.energy ?? 0.toString(),
            'total fat': barcodeData.product?.nutriments?.fat ?? 0.toString(),
            'saturated fat':
                barcodeData.product?.nutriments?.saturatedFat ?? 0.toString(),
            'sodium': barcodeData.product?.nutriments?.sodium ?? 0.toString(),
            'total carbohydrate':
                barcodeData.product?.nutriments?.carbohydrates ?? 0.toString(),
            'total sugars':
                barcodeData.product?.nutriments?.sugars ?? 0.toString(),
            'protein':
                barcodeData.product?.nutriments?.proteins ?? 0.toString(),
            'fiber': barcodeData.product?.nutriments?.fiber ?? 0.toString(),
            'ingredients': data['ingredients']
          },
          'picture': data['pic'] ??
              'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
          'Allergens': data['allergens'] ?? "Not Avaliable",
          'conditions': con,
        }); //inputs searched barcodes
      }
    }
  }

  Future<bool> isProductFavorite(String barcode) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    try {
      final favoriteDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(barcode)
          .get();

      return favoriteDoc.exists;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future favBar(Map item) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('favorites')
        .doc(item['barcode'])
        .set({
      'time': FieldValue.serverTimestamp(),
      'barcode': item['barcode'],
      'name': item['name'],
      'grade': item['grade'],
      'ID': false,
      'picture': item['pic'],
      "Allergens": item['allergens'],
      "conditions": item['conditions']
    });
  }

  Future favoriteBarcode(String barcode, String name, String grade, bool ID,
      String pic, List<dynamic> allergy, List<dynamic> condition) async {
    return FirebaseFirestore.instance
        .collection('users') //gos to users
        .doc(FirebaseAuth.instance.currentUser!.email
            .toString()) //goes to current user
        .collection('favorites') //goes to favorites
        .doc(barcode) //creates barcode
        .set({
      'time': FieldValue.serverTimestamp(),
      'barcode': barcode,
      'name': name,
      'grade': grade,
      'ID': ID,
      'picture': pic,
      "Allergens": allergy,
      "conditions": condition
    }); //create info about barcode
  }

  Future<void> removeFavorite(String barcode) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('favorites')
        .doc(barcode)
        .delete();
  }

  //destroys barcode from firebase
  Future<void> destroyBarcode(String barcode, bool choice) async {
    choice
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .collection('scanned')
            .doc(barcode)
            .delete()
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .collection('search')
            .doc(barcode)
            .delete();
  }

  //deletes recommendations from firebase
  Future<void> destroyRecommendations(String barcode, bool type) async {
    //Determines the parent collection name based on the input boolean 'type'
    final choice = type ? 'scanned' : 'search';
    //Gets the current user's email
    String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    //Gets the reference to the 'recommended' subcollection
    CollectionReference collection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection(choice)
        .doc(barcode)
        .collection('recommended');

    //Retrieves and deletes documents in the collection
    QuerySnapshot querySnapshot = await collection.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await collection.doc(doc.id).delete();
    }
  }
}
