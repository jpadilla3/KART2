import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GradeCal {
  gradeCalculate(List<dynamic> ProductAllergen, String Grade) async {
    List<String> al = [
      'Milk',
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

    List<String> allergy = [];

    var col = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await col
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get();

    int count = 0;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 12; i++) {
        if (data["Allergies"][al[i]] == true) {
          allergy.add(al[i]);
        } else {
          count++;
        }
      }
      if (count == 12) {
        return Grade;
      } else {
        for (int i = 0; i < allergy.length; i++) {
          if (ProductAllergen.contains(allergy[i].toLowerCase())) {
            return 'e';
          } else {
            return Grade;
          }
        }
      }
    }
  }

  gradeCalculateInfo(List<dynamic> ProductAllergen, String Grade) async {
    List<String> al = [
      'Milk',
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

    List<String> allergy = [];

    var col = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await col
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get();
    int count = 0;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      for (int i = 0; i < 12; i++) {
        if (data["Allergies"][al[i]] == true) {
          allergy.add(al[i]);
        } else {
          count++;
        }
      }
      if (count == 12) {
        return 'false';
      } else {
        for (int i = 0; i < allergy.length; i++) {
          if (ProductAllergen.contains(allergy[i].toLowerCase())) {
            return allergy[i];
          } else {
            return 'false';
          }
        }
      }
    }
  }
}
