import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kart2/onboarding/sign%20up%20pages/Conditions/Allergies.dart';

class GradeCal {
  gradeCalculate(
      List<dynamic> productAllergen, List<dynamic> productCondition) async {
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
          if (productAllergen.contains(allergy[i].toLowerCase())) {
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

  // preferencesConflicts calculates if the allergies and conditions of the product conflict with the current user
  preferencesConflicts(
      List<dynamic> productAllergens, List<dynamic> productConditions) async {
    List<String> allergs = [
      'Celery',
      'Crustaceans',
      'Eggs',
      'Fish',
      'Gluten',
      'Lupin',
      'Molluscs',
      'Mustard',
      'Nuts',
      'Peanuts',
      'Sesame-Seeds',
      'Soybeans',
    ];
    List<String> cons = ['Lactose Intolerant', 'Vegan', 'Vegetarian'];

    List<String> userAllergens = [];
    List<String> userConditions = [];

    var col = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await col
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get();

    int count1 = 0;
    int count2 = 0;
    bool allergyConflict = false;
    bool conditionConflict = false;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 12; i++) {
        if (data["Allergies"][allergs[i]] == true) {
          userAllergens.add(allergs[i]);
        } else {
          count1++;
        }
      }
      for (int j = 0; j < 3; j++) {
        if (data["Conditions"][cons[j]] == true) {
          userConditions.add(cons[j]);
        } else {
          count2++;
        }
      }
      if (count1 == 12 && count2 == 3) {
        allergyConflict = false;
        conditionConflict = false;
      } else {
        // Checks for allergy conflicts
        for (int i = 0; i < userAllergens.length; i++) {
          if (productAllergens.contains(userAllergens[i])) {
            allergyConflict = true;
          }
        }

        // Checks for condition conflicts
        conditionConflict = false;
        if ((userConditions.contains('Vegan') &&
            !productConditions.contains('Vegan'))) {
          conditionConflict = true;
        }
        if ((userConditions.contains('Vegetarian') &&
            !productConditions.contains('Vegetarian'))) {
          conditionConflict = true;
        }
        if (userConditions.contains('Lactose Intolerant') &&
            productConditions.contains('Lactose Intolerant')) {
          conditionConflict = true;
        }
      }
      return [allergyConflict, conditionConflict];
    } else {
      throw Exception(
          'User ${FirebaseAuth.instance.currentUser?.email.toString()} document not found.');
    }
  }

  gradeCalculate2(List<dynamic> productAllergen, String veganStatus,
      String vegetarianStatus) async {
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
          if (productAllergen.contains(allergy[i].toLowerCase())) {
            aler = true;
            break;
          } else {
            aler = false;
          }
        }

        if ((condition.contains('Vegan') &&
            veganStatus == 'VeganStatus.VEGAN')) {
          condi = false;
        } else {
          condi = true;
        }

        if ((condition.contains('Vegetarian') &&
            vegetarianStatus == 'VegetarianStatus.VEGETARIAN')) {
          veg = false;
        } else {
          veg = true;
        }
        if (condition.contains('Lactose Intolerant') &&
            productAllergen.contains('milk')) {
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
      List<dynamic> productAllergen, List<dynamic> productCondition) async {
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
          if (productAllergen.contains(allergy[i].toLowerCase())) {
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
