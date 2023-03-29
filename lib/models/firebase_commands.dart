import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kart2/models/barcode_data_model.dart';
import 'package:http/http.dart' as http;

import '../main pages/productPage.dart';

class FirebaseCommands {
  //add barcode to firebase
  Future addBarcode(String barcode) async {
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$barcode?fields=allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);
    if (response.statusCode == 200) {
      if (int.parse(barcode) > 0) {
        return FirebaseFirestore.instance
            .collection('users') //go to users
            .doc(FirebaseAuth.instance.currentUser!.email
                .toString()) // go to current user
            .collection('scanned') // go to scanned
            .doc(barcode) // create barcode
            .set({
          'time': FieldValue.serverTimestamp(),
          'barcode': barcode,
          'name': barcodeData.product!.productName,
          'score': barcodeData.product?.nutriscoreScore ?? 0,
          'grade': barcodeData.product?.nutritionGrades ?? 'No Grade',
          'calories': barcodeData.product?.nutriments?.energy ?? 0,
          'total fat': barcodeData.product?.nutriments?.fat! ?? 0,
          'saturated fat': barcodeData.product?.nutriments?.saturatedFat! ?? 0,
          'sodium': barcodeData.product?.nutriments?.sodium! ?? 0,
          'total carbohydrate':
              barcodeData.product?.nutriments?.carbohydrates! ?? 0,
          'total sugars': barcodeData.product?.nutriments?.sugars! ?? 0,
          'protein': barcodeData.product?.nutriments?.proteins! ?? 0,
          'fiber': barcodeData.product?.nutriscoreData?.fiber! ?? 0,
        }); // create barcode info
      }
    } else {
      throw Exception('Failed to fetch data');
    }
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

  Future searchBarcode(String barcode) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('search')
        .doc(barcode)
        .set({}); //input searched barcodes
  }

  Future favoriteBarcode(String barcode, String name, String grade) async {
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
      'grade': grade
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
  Future<void> destroyBarcode(String barcode) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .doc(barcode)
        .delete();
  }
}
