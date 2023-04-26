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
      'Peanuts',
      'Nuts',
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
    bool veg = true;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 12; i++) {
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
      if (count == 12 && count2 == 3) {
        aler = false;
        condi = true;
        lac = false;
        veg = true;
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
            productCondition.contains('vegan'))) {
          condi = false;
        } else {
          condi = true;
        }
        if ((condition.contains('Vegetarian') &&
            productCondition.contains('vegetarian'))) {
          veg = false;
        } else {
          veg = true;
        }
        if (condition.contains('Lactose Intolerant') &&
            productCondition.contains('lactose intolerant')) {
          lac = true;
        } else {
          lac = false;
        }

        print(aler);
      }
      return [condi, veg, lac, aler];
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
      'Peanuts',
      'Nuts',
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
      for (int i = 0; i < 12; i++) {
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
      String vegan = '';
      String vegetarian = '';
      String lac = '';

      if (count == 12 && count2 == 3) {
        allergic = 'false';
        vegan = 'false';
        vegetarian = 'false';
        lac = 'false';
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
          vegetarian = 'Vegetarian';
        }
        if (condition.contains("Vegan") && productCondition.contains('vegan')) {
          vegan = 'Vegan';
        }
        if (condition.contains('Lactose Intolerant') &&
            productCondition.contains('lactose intolerant')) {
          lac = 'Lactose Intolerant';
        }
      }
      return [vegan, vegetarian, lac, allergic];
    }
  }
}
