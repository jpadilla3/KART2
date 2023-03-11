import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseCommands {
  //add barcode to firebase
  Future addBarcode(String email, String barcode) async {
    return FirebaseFirestore.instance
        .collection(email)
        .doc(barcode)
        .set({'time:': FieldValue.serverTimestamp()});
  }

  //read barcode from firebase

  //update barcode from firebase
  //might not need

  //destroy barcode from firebase
  Future destroyBarcode(String email, String barcode) async {
    FirebaseFirestore.instance.collection(email).doc(barcode).delete();
  }
}
