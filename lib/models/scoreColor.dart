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
      return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Nutri-score-A.svg/1920px-Nutri-score-A.svg.png');
    }
    if (grade == 'b') {
      return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Nutri-score-B.svg/1024px-Nutri-score-B.svg.png');
    }
    if (grade == 'c') {
      return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Nutri-score-C.svg/2560px-Nutri-score-C.svg.png');
    }
    if (grade == 'd') {
      return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Nutri-score-D.svg/2560px-Nutri-score-D.svg.png');
    }

    if (grade == 'e') {
      return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Nutri-score-E.svg/1920px-Nutri-score-E.svg.png');
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
}
