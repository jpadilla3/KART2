import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCommands {
  //add barcode to firebase
  Future addBarcode(String barcode) async {
    if (int.parse(barcode) > 0) {
      return FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc(barcode)
          .set({'time:': FieldValue.serverTimestamp(), "barcode": barcode});
    }
  }

  Future searchBarcode(String barcode) async {
    return FirebaseFirestore.instance
        .collection('search')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .set({'barcode': barcode}); //will need to turn this to list or map
  }

  //read barcode from firebase

  //update barcode from firebase
  //might not need

  //destroy barcode from firebase
  Future<void> destroyBarcode(String barcode) async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc(barcode)
        .delete();
  }
}
