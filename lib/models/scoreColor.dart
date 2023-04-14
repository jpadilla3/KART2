import 'package:flutter/material.dart';

class scoreColors {
  scoreColor(String grade) {
    if (grade == 'a') {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.green),
      );
    }
    if (grade == 'b') {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.lightGreen),
      );
    }
    if (grade == 'c') {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.yellow),
      );
    }
    if (grade == 'd') {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.orange),
      );
    }

    if (grade == 'e') {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.red),
      );
    } else {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey[600]),
      );
    }
  }

  scorePic(String grade) {
    if (grade == 'a') {
      return Image.asset('assets/images/NutriScoreA.png');
    }
    if (grade == 'b') {
      return Image.asset('assets/images/NutriScoreB.png');
    }
    if (grade == 'c') {
      return Image.asset('assets/images/NutriScoreC.png');
    }
    if (grade == 'd') {
      return Image.asset('assets/images/NutriScoreD.png');
    }
    if (grade == 'e') {
      return Image.asset('assets/images/NutriScoreE.png');
    } else {
      return Container(
        width: 60,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey[500], borderRadius: BorderRadius.circular(10)),
        child: const Text(
          'Score Unavaliable',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  scoreInfo(String allergen) {
    if (allergen == 'false') {
      return Text('');
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red[100]),
          alignment: Alignment.center,
          height: 50,
          width: 300,
          child: Text(
            'This Product Contains $allergen',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      );
    }
  }
}
