import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kart2/models/barcode_data_model.dart';
import 'package:http/http.dart' as http;

class FirebaseCommands {
  //add barcode to firebase
  Future addBarcode(String barcode) async {
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags,brands,categories,categories_tags,compared_to_category,food_groups,food_groups_tags,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);

    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
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
              barcodeData.product?.brands ?? barcodeData.product?.productName!,
          "nutrition": {
            'score': barcodeData.product?.nutriscoreScore ?? 0,
            'grade': barcodeData.product?.nutritionGrades ?? 'No Grade',
            'calories': barcodeData.product?.nutriments?.energy ?? 0,
            'total fat': barcodeData.product?.nutriments?.fat ?? 0,
            'saturated fat': barcodeData.product?.nutriments?.saturatedFat ?? 0,
            'sodium': barcodeData.product?.nutriments?.sodium ?? 0,
            'total carbohydrate':
                barcodeData.product?.nutriments?.carbohydrates ?? 0,
            'total sugars': barcodeData.product?.nutriments?.sugars ?? 0,
            'protein': barcodeData.product?.nutriments?.proteins ?? 0,
            'fiber': barcodeData.product?.nutriscoreData?.fiber ?? 0,
          },
          "Allergens":
              barcodeData.product?.allergensTags ?? 'none', //set allergens
          "conditions": {'none'},
          'name': barcodeData.product?.productName! ?? 'Product',
          'picture': barcodeData.product?.selectedImages?.front?.small?.en ??
              'https://t3.ftcdn.net/jpg/02/68/55/60/360_F_268556012_c1WBaKFN5rjRxR2eyV33znK4qnYeKZjm.jpg'

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
        'Peanuts (Nuts)': list[7],
        'Soybeans': list[8],
        'Mustard': list[9],
        'Eggs': list[10],
      },
      'Conditions': {
        'Vegan': list2[0],
        'Vegetarian': list2[1],
        'Lactose Intolerant': list2[2],
      }
    });
  }

  Future updateBarcode(String barcode) async {
    return FirebaseFirestore.instance
        .collection('users') //go to users
        .doc(FirebaseAuth.instance.currentUser!.email
            .toString()) // go to current user
        .collection('scanned') // go to scanned
        .doc(barcode)
        .collection('recommended')
        .doc('0001')
        .set({'barcode': '000001', 'name': 'orange'});
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
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=_keywords,allergens,allergens_tags,brands,categories,categories_tags,compared_to_category,food_groups,food_groups_tags,image_front_thumb_url,ingredients,nutrient_levels,nutrient_levels_tags,nutriments,nutriscore_data,nutriscore_grade,nutriscore_score,nutrition_grades,product_name,selected_images,traces,.json';
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
          'name': barcodeData.product?.productName! ?? 'Product',
          "nutrition": {
            'score': barcodeData.product?.nutriscoreScore ?? 0,
            'grade': barcodeData.product?.nutritionGrades ?? 'No Grade',
            'calories': barcodeData.product?.nutriments?.energy ?? 0,
            'total fat': barcodeData.product?.nutriments?.fat ?? 0,
            'saturated fat': barcodeData.product?.nutriments?.saturatedFat ?? 0,
            'sodium': barcodeData.product?.nutriments?.sodium ?? 0,
            'total carbohydrate':
                barcodeData.product?.nutriments?.carbohydrates ?? 0,
            'total sugars': barcodeData.product?.nutriments?.sugars ?? 0,
            'protein': barcodeData.product?.nutriments?.proteins ?? 0,
            'fiber': barcodeData.product?.nutriscoreData?.fiber ?? 0,
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
