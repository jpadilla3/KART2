import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';

class GetBarcode extends StatelessWidget {
  const GetBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(builder: ((context, snapshot) {
      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
      return Text('${data['barcode']}');
    }));
  }
}
