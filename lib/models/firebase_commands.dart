import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kart2/models/barcode_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:kart2/models/search_data_model.dart';

class FirebaseCommands {
  //add barcode to firebase
  Future addBarcode(String barcode) async {
    List<String> alerg = [];
    List<String> con = [];
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
            alerg.add(barcodeData.product!.allergensTagsEn![i]);
          }
        }
        if (barcodeData.product!.allergensTagsEn!.contains('Milk') ||
            barcodeData.product!.allergensTagsEn!.contains('Lactic')) {
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

        FirebaseFirestore.instance
            .collection('users') //go to users
            .doc(FirebaseAuth.instance.currentUser!.email
                .toString()) // go to current user
            .collection('scanned') // go to scanned
            .doc(barcode) // create barcode
            .set({
          'time': FieldValue.serverTimestamp(),
          "ID": true,
          'barcode': barcode,
          'brand':
              barcodeData.product?.brands ?? barcodeData.product?.productName,
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
          },
          "Allergens": alerg, //set allergens
          "conditions": con,
          'name': barcodeData.product?.productName ?? 'Product',
          'picture': barcodeData.product?.selectedImages?.front?.small?.en ??
              'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',

          //set conditions (vegan, vegetarian)
        });
      }
    } else {
      return AboutDialog();
    }
  }

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

  Future addRecomendations(barcode, product) async {
    List<String> alerg = [];
    List<String> con = [];
    int count = 0;
    int count2 = 0;

    final String url =
        'https://us.openfoodfacts.org/api/v2/product/${product.code}?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);

    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
        if (barcodeData.product!.allergensTagsEn!.isNotEmpty) {
          for (int i = 0;
              i < barcodeData.product!.allergensTagsEn!.length;
              i++) {
            alerg.add(barcodeData.product!.allergensTagsEn![i]);
          }
        }
        if (barcodeData.product!.allergensTagsEn!.contains('Milk') ||
            barcodeData.product!.allergensTagsEn!.contains('Lactic')) {
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
        FirebaseFirestore.instance
            .collection('users') //go to users
            .doc(FirebaseAuth.instance.currentUser!.email
                .toString()) // go to current user
            .collection('scanned') // go to scanned
            .doc(barcode)
            .collection('recommended')
            .doc(product.code)
            .set({
          'time': FieldValue.serverTimestamp(),
          "ID": true,
          'barcode': product.code,
          'brand': product.brands ?? product.productName,
          "nutrition": {
            'score': product.nutriscoreScore ?? 0,
            'grade': product.nutritionGrades ?? 'No Grade',
            'calories': product.nutriments?.energy ?? 0,
            'total fat': product.nutriments?.fat ?? 0,
            'saturated fat': product.nutriments?.saturatedFat ?? 0,
            'sodium': product.nutriments?.sodium ?? 0,
            'total carbohydrate': product.nutriments?.carbohydrates ?? 0,
            'total sugars': product.nutriments?.sugars ?? 0,
            'protein': product.nutriments?.proteins ?? 0,
            'fiber': product.nutriscoreData?.fiber ?? 0,
          },
          "Allergens": alerg, //set allergens
          "conditions": con,
          'name': product?.productName ?? 'Product',
          'picture': product?.selectedImages?.front?.small?.en ??
              'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg',
        });
      }
    } else {
      return const AboutDialog();
    }
  }

  Future anotherCategory3(barcode, response) async {
    final data = barcodeDataFromJson(response.body);
    final categoryList = data.product?.categoriesTagsEn;
    final categoryString = categoryList?.isNotEmpty == true
        ? categoryList![categoryList.length - 4]
        : null;
    if (categoryString != null) {
      print(categoryList);
      print(categoryString);
      log(Uri.encodeQueryComponent(categoryString));
      final enCategory = Uri.encodeQueryComponent(categoryString);
      final similarProductsResponse = await http.get(Uri.parse(
          'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$enCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

      if (similarProductsResponse.statusCode == 200) {
        final similarProductsData =
            searchDataFromJson(similarProductsResponse.body);
        final products = similarProductsData.products;

        if (products?.isEmpty ?? true) {
          throw Exception('No similar products to recommend');
        } else {
          int count = 0;

          for (final product in products!) {
            if (count == 15) {
              break;
            }
            print(product.code);
            print(product.nutriscoreGrade);
            print(product.productName);
            addRecomendations(barcode, product);
            count++;
          }
        }
      } else {
        throw Exception('Failed to load similar products with error');
      }
    } else {
      throw Exception('Category not found for barcode ${data.code}');
    }
  }

  Future anotherCategory2(barcode, response) async {
    final data = barcodeDataFromJson(response.body);
    final categoryList = data.product?.categoriesTagsEn;
    final categoryString = categoryList?.isNotEmpty == true
        ? categoryList![categoryList.length - 3]
        : null;
    if (categoryString != null) {
      print(categoryList);
      print(categoryString);
      log(Uri.encodeQueryComponent(categoryString));
      final enCategory = Uri.encodeQueryComponent(categoryString);
      final similarProductsResponse = await http.get(Uri.parse(
          'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$enCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

      if (similarProductsResponse.statusCode == 200) {
        final similarProductsData =
            searchDataFromJson(similarProductsResponse.body);
        final products = similarProductsData.products;

        if (products?.isEmpty ?? true) {
          anotherCategory3(barcode, response);
        } else {
          int count = 0;

          for (final product in products!) {
            if (count == 15) {
              break;
            }
            print(product.code);
            print(product.nutriscoreGrade);
            print(product.productName);
            addRecomendations(barcode, product);
            count++;
          }
        }
      } else {
        throw Exception('Failed to load similar products with error');
      }
    } else {
      throw Exception('Category not found for barcode ${data.code}');
    }
  }

  Future anotherCategory(barcode, response) async {
    final data = barcodeDataFromJson(response.body);
    final categoryList = data.product?.categoriesTagsEn;
    final categoryString = categoryList?.isNotEmpty == true
        ? categoryList![categoryList.length - 2]
        : null;
    if (categoryString != null) {
      print(categoryList);
      print(categoryString);
      log(Uri.encodeQueryComponent(categoryString));
      final enCategory = Uri.encodeQueryComponent(categoryString);
      final similarProductsResponse = await http.get(Uri.parse(
          'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$enCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

      if (similarProductsResponse.statusCode == 200) {
        final similarProductsData =
            searchDataFromJson(similarProductsResponse.body);
        final products = similarProductsData.products;

        if (products?.isEmpty ?? true) {
          anotherCategory2(barcode, response);
        } else {
          int count = 0;

          for (final product in products!) {
            if (count == 15) {
              break;
            }
            print(product.code);
            print(product.nutriscoreGrade);
            print(product.productName);
            addRecomendations(barcode, product);
            count++;
          }
        }
      } else {
        throw Exception('Failed to load similar products with error');
      }
    } else {
      throw Exception('Category not found for barcode ${data.code}');
    }
  }

  Future getSimilarProducts(String barcode) async {
    final response = await http.get(Uri.parse(
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

    if (response.statusCode == 200) {
      final data = barcodeDataFromJson(response.body);
      final categoryList = data.product?.categoriesTagsEn;
      final categoryString =
          categoryList?.isNotEmpty == true ? categoryList!.last : null;
      if (categoryString != null) {
        print(categoryList);
        print(categoryString);
        log(Uri.encodeQueryComponent(categoryString));
        final encodedCategory = Uri.encodeQueryComponent(categoryString);
        final similarProductsResponse = await http.get(Uri.parse(
            'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$encodedCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

        if (similarProductsResponse.statusCode == 200) {
          final similarProductsData =
              searchDataFromJson(similarProductsResponse.body);
          final products = similarProductsData.products;

          if (products?.isEmpty ?? true) {
            anotherCategory(barcode, response);
          } else {
            int count = 0;

            for (final product in products!) {
              if (count == 15) {
                break;
              }
              print(product.code);
              print(product.nutriscoreGrade);
              print(product.productName);
              addRecomendations(barcode, product);
              count++;
            }
          }
        } else {
          throw Exception('Failed to load similar products with error');
        }
      } else {
        throw Exception('Category not found for barcode ${data.code}');
      }
    } else {
      throw Exception(
          'Failed to load product details with error ${response.statusCode}');
    }
  }

  Future getSimilarProducts2(String barcode) async {
    final response = await http.get(Uri.parse(
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

    if (response.statusCode == 200) {
      final data = barcodeDataFromJson(response.body);
      final categoryList = data.product?.categoriesTagsEn;

      if (categoryList != null && categoryList.isNotEmpty) {
        for (int i = categoryList.length - 1; i >= 0; i--) {
          int count = 0;
          final categoryString = categoryList[i];

          final encodedCategory = Uri.encodeQueryComponent(categoryString);
          final similarProductsResponse = await http.get(Uri.parse(
              'https://us.openfoodfacts.org/api/v2/search?categories_tags_en=$encodedCategory&nutrition_grades_tags=a&fields=_keywords,allergens,allergens_tags_en,brands,categories,categories_tags_en,code,compared_to_category,food_groups,food_groups_tags_en,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags_en,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json'));

          if (similarProductsResponse.statusCode == 200) {
            final similarProductsData =
                searchDataFromJson(similarProductsResponse.body);
            final products = similarProductsData.products;

            if (products?.isNotEmpty ?? true) {
              for (final product in products!) {
                print(categoryString);
                print(encodedCategory);
                print(product.code);
                print(product.nutriscoreGrade);
                print(product.productName);
                addRecomendations(barcode, product);
                count++;
                print(count);
              }
              if (count == 5) {
                break;
              }
            }
          }
        }
      } else {
        throw Exception('Categories not found for barcode $barcode');
      }
    } else {
      throw Exception(
          'Failed to load product details with error ${response.statusCode}');
    }
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
        }); //input searched barcodes
      }
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
        .collection('users') //go to general collection
        .doc(FirebaseAuth.instance.currentUser!.email
            .toString()) //go to current user
        .collection('favorites') //go to favorites
        .doc(barcode) //create barcode
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

  //destroy barcode from firebase
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
}
