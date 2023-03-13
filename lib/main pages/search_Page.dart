import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/models/flutter_barcode_scanner.dart';

import 'favorites.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  @override
  void initState() {
    super.initState();
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

      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showSearch(
                            context: context, delegate: MySearchDelegate());
                      },
                      child: Container(
                        height: 50,
                        width: 290,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.indigo),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Search',
                                style: GoogleFonts.bebasNeue(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(children: [
                  Container(
                    height: 50,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: IconButton(
                        onPressed: () => scanBarcodeNormal(),
                        icon: const Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                        )),
                  ),
                ])
              ],
            ),
            const SizedBox(
              height: 200,
            ),
            Container(
              height: 200,
              width: 200,
              child: Image.network(
                  "https://static.vecteezy.com/system/resources/previews/004/331/580/original/healthy-food-search-linear-icon-thin-line-illustration-magnifying-glass-with-apple-diet-contour-symbol-isolated-outline-drawing-vector.jpg"),
            ),
            Text(
              "Enter a Search",
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () => close(context, null));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center();
}
