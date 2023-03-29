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
    } else {
      return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.red),
      );
    }
  }
}
