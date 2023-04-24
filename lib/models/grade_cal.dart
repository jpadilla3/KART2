import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kart2/onboarding/sign%20up%20pages/Conditions/Allergies.dart';

class GradeCal {
  gradeCalculate(
      List<dynamic> ProductAllergen, List<dynamic> productCondition) async {
    List<String> al = [
      'Gluten',
      'Lupin',
      'Celery',
      'Fish',
      'Crustaceans',
      'Sesame-Seeds',
      'Molluscs',
      'Peanuts (Nuts)',
      'Soybeans',
      'Mustard',
      'Eggs'
    ];
    List<String> con = ['Vegan', 'Vegetarian', 'Lactose Intolerant'];

    List<String> allergy = [];
    List<String> condition = [];

    var col = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await col
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get();

    int count = 0;
    int count2 = 0;
    bool aler = false;
    bool condi = true;
    bool lac = false;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 11; i++) {
        if (data["Allergies"][al[i]] == true) {
          allergy.add(al[i]);
        } else {
          count++;
        }
      }
      for (int j = 0; j < 3; j++) {
        if (data["Conditions"][con[j]] == true) {
          condition.add(con[j]);
        } else {
          count2++;
        }
      }
      if (count == 11 && count2 == 3) {
        aler = false;
        condi = true;
        lac = false;
      } else {
        for (int i = 0; i < allergy.length; i++) {
          if (ProductAllergen.contains(allergy[i].toLowerCase())) {
            aler = true;
            break;
          } else {
            aler = false;
          }
        }

        if ((condition.contains('Vegan') &&
                productCondition.contains('vegan')) ||
            (condition.contains('Vegetarian') &&
                productCondition.contains('vegetarian'))) {
          condi = false;
        } else {
          condi = true;
        }
        if (condition.contains('Lactose Intolerant') &&
            productCondition.contains('lactose intolerant')) {
          lac = true;
        } else {
          lac = false;
        }

        print(lac);
      }
      return [aler, condi, lac];
    }
  }

  gradeCalculateInfo(
      List<dynamic> ProductAllergen, List<dynamic> productCondition) async {
    List<String> al = [
      'Gluten',
      'Lupin',
      'Celery',
      'Fish',
      'Crustaceans',
      'Sesame-Seeds',
      'Molluscs',
      'Peanuts (Nuts)',
      'Soybeans',
      'Mustard',
      'Eggs'
    ];
    List<String> con = ['Vegan', 'Vegetarian', 'Lactose Intolerant'];

    List<String> allergy = [];
    List<String> condition = [];

    var col = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await col
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get();
    int count = 0;
    int count2 = 0;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 11; i++) {
        if (data["Allergies"][al[i]] == true) {
          allergy.add(al[i]);
        } else {
          count++;
        }
      }
      for (int j = 0; j < 3; j++) {
        if (data['Conditions'][con[j]] == true) {
          condition.add(con[j]);
        } else {
          count2++;
        }
      }
      String allergic = '';
      String condit = '';
      String lac = '';

      if (count == 11 && count2 == 3) {
        allergic = 'false';
        condit = 'false';
      } else {
        for (int i = 0; i < allergy.length; i++) {
          if (ProductAllergen.contains(allergy[i].toLowerCase())) {
            allergic = allergy[i];
            break;
          } else {
            allergic = 'false';
          }
        }

        if (condition.contains('Vegetarian') &&
            productCondition.contains('vegetarian')) {
          condit = 'Vegetarian';
        }
        if (condition.contains("Vegan") && productCondition.contains('vegan')) {
          condit = 'Vegan';
        }
        if (condition.contains('Lactose Intolerant') &&
            productCondition.contains('lactose intolerant')) {
          lac = 'Lactose Intolerant';
        }
      }
      return [allergic, condit, lac];
    }
  }
}
