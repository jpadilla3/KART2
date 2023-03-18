import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/models/barcode_data_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _scanBarcode = '';
  late Future<BarcodeData> futureBarcodeData;

  @override
  void initState() {
    super.initState();
    futureBarcodeData = fetchBarcodeData();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await BarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
      //add barcode to firebase
      //passes current user email and barcode
      FirebaseCommands().addBarcode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<BarcodeData> fetchBarcodeData() async {
    final String url =
        'https://us.openfoodfacts.org/api/v2/product/$_scanBarcode?fields=allergens,brands,categories,ingredients,nutrient_levels,nutriments,nutriscore_data,product_name,nutriscore_score,nutrition_grades,product_name,traces.json';
    final response = await http.get(Uri.parse(url));
    final barcodeData = barcodeDataFromJson(response.body);
    if (response.statusCode == 200) {
      return barcodeData;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.center,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await scanBarcodeNormal();
                      } catch (err) {
                        print('Caught error: $err');
                      }
                      try {
                        await fetchBarcodeData();
                      } catch (err) {
                        print('Caught error: $err');
                      }
                    },
                    child: const Text('Scan Barcode')),
                FutureBuilder<BarcodeData>(
                    future: fetchBarcodeData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Product Name: ${snapshot.data?.product?.productName}'),
                            Text('Brand: ${snapshot.data?.product?.brands}'),
                            Text(
                                'Categories: ${snapshot.data?.product?.categories}'),
                            Text(
                                'Nutrition Grade: ${snapshot.data?.product?.nutritionGrades}'),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error:${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ]));
    }));
  }
}
