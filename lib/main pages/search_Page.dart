import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kart2/main%20pages/nav_bar.dart';

import 'package:kart2/models/barcode_data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/models/firebase_commands.dart' as fire;
import 'package:kart2/models/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _scanBarcode = '';
  late Future<BarcodeData> futureBarcodeData;

  Future getSuggestion(String word) async {
    ProductSearchQueryConfiguration config = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: <Parameter>[
          SearchTerms(terms: [word]),
          const SortBy(
            option: SortOption.NUTRISCORE,
          ),
        ],
        version: ProductQueryVersion.v3);

    SearchResult result = await OpenFoodAPIClient.searchProducts(
        User(userId: 'jpadilla3', password: 'abc123!'), config);

    for (int i = 0; i < 5; i++) {
      print(
          "${result.products?[i].productName} : ${result.products?[i].barcode}");
    }
  }

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
      fire.FirebaseCommands().addBarcode(barcodeScanRes);
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

  //fetchBarcodeData function gets the data with certian fields from barcode and parses it.

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
                        onPressed: () async {
                          await scanBarcodeNormal();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const navBar()));
                        },
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
              child: Image.asset("assets/images/Search.png"),
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
  List<String> search = [];
  List<String> search1 = [];
  List<String> bar = [];
  Future getSearch(String word) async {
    ProductSearchQueryConfiguration config = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: <Parameter>[
          SearchTerms(terms: [word]),
          const SortBy(
            option: SortOption.POPULARITY,
          ),
          TagFilter.fromType(
              tagFilterType: TagFilterType.COUNTRIES, tagName: 'united-states'),
        ],
        version: ProductQueryVersion.v3);

    SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: 'jpadilla3', password: 'abc123!'), config);

    for (int i = 0; i < 15; i++) {
      print(
          "${result.products?[i].productName} : ${result.products?[i].countriesTags}");

      search.add('${result.products?[i].productName}');
      search1.add('${result.products?[i].nutriscore}');
      bar.add('${result.products?[i].barcode}');
    }

    print(search.length);
  }

  List<String> prevSearch = [];

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
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            if (prevSearch.contains(query)) {
              int pos = prevSearch.indexOf(query);
              final String first = prevSearch.removeAt(pos);
              prevSearch.add(first);
            } else {
              prevSearch.add(query);
            }

            showResults(context);
            search.clear();
            //getSuggestion(query);
          },
        )
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: prevSearch.length,
        itemBuilder: (context, index) {
          var revSearch = List.from(prevSearch.reversed);
          final suggestion = revSearch[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              if (prevSearch.contains(query)) {
                int pos = prevSearch.indexOf(query);
                final String first = prevSearch.removeAt(pos);
                prevSearch.add(first);
              } else {
                prevSearch.add(query);
              }
              showResults(context);
              search.clear();
            },
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(
        child: FutureBuilder(
            future: getSearch(query),
            builder: (context, snaphsot) {
              if (snaphsot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: search.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(search[index]),
                        subtitle:
                            Text('Grade: ${search1[index].toUpperCase()}'),
                        onTap: () {
                          fire.FirebaseCommands().searchBarcode(bar[index]);
                        },
                      );
                    });
              } else {
                return const CircularProgressIndicator();
              }
            }),
      );
}
