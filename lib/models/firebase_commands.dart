import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCommands {
  //count documents
  Future countdoc() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  }

  //add barcode to firebase
  Future addBarcode(String barcode) async {
    //gets size of scanned collection
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .get();
    //store all the docs in a list
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    //removes oldest barcode after 25 scans
    if (_myDocCount.length > 25) {
      destroyBarcode(barcode); //change to earliest item scanned
    } else {
      if (int.parse(barcode) > 0) {
        return FirebaseFirestore.instance
            .collection('users') //go to users
            .doc(FirebaseAuth.instance.currentUser!.email
                .toString()) // go to current user
            .collection('scanned') // go to scanned
            .doc(barcode) // create barcode
            .set({
          'time': FieldValue.serverTimestamp(),
          'barcode': barcode
        }); // create barcode info
      }
    }

    if (int.parse(barcode) > 0) {
      return FirebaseFirestore.instance
          .collection('users') //go to users
          .doc(FirebaseAuth.instance.currentUser!.email
              .toString()) // go to current user
          .collection('scanned') // go to scanned
          .doc(barcode) // create barcode
          .set({
        'time': FieldValue.serverTimestamp(),
        'barcode': barcode
      }); // create barcode info
    }
  }

  Future searchBarcode(String barcode) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('search')
        .doc(barcode)
        .set({}); //input searched barcodes
  }

  Future favoriteBarcode(String barcode) async {
    return FirebaseFirestore.instance
        .collection('users') //go to general collection
        .doc(FirebaseAuth.instance.currentUser!.email
            .toString()) //go to current user
        .collection('favorites') //go to favorites
        .doc(barcode) //create barcode
        .set({
      'time': FieldValue.serverTimestamp(),
      'barcode': barcode
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
