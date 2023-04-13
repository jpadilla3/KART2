import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:kart2/main%20pages/shimmerlist.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/main%20pages/search_page.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';
import 'package:shimmer/shimmer.dart';

class productPage extends StatefulWidget {
  String barcode;
  bool type;
  productPage(this.barcode, this.type);

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {
  void snackMessage(bool action, String barcode) {
    //true for delete
    //false for favorite
    if (action == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You have successfully deleted $barcode"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added $barcode to favorites"),
      ));
    }
  }

  rowInfo(String title, String amount, Icon pic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: SizedBox.square(
              dimension: 60,
              child: pic,
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey))),
              child: SizedBox(
                height: 60,
                width: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey))),
                child: SizedBox(
                  height: 60,
                  width: 102,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          amount,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _scanned = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned');

    final CollectionReference _search = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('search');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: FutureBuilder(
          future: widget.type
              ? _scanned.doc(widget.barcode).get()
              : _search.doc(widget.barcode).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                '${data['brand']}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            } else if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else {
              return buildTextShimmer();
            }
          },
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.indigo[400],
            )),
      ),
      //new Builder(builder: (BuildContext context) {}),
      body: SingleChildScrollView(
          child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox.square(
                    dimension: 180,
                    child: FutureBuilder<DocumentSnapshot>(
                        future: widget.type
                            ? _scanned.doc(widget.barcode).get()
                            : _search.doc(widget.barcode).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Image.network('${data['picture']}');
                          } else {
                            return buildPicShimmer();
                          }
                        }))
              ],
            ),
            Column(
              children: [
                Container(
                  height: 150,
                  width: 180,
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: widget.type
                          ? _scanned.doc(widget.barcode).get()
                          : _search.doc(widget.barcode).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                data['name'],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FutureBuilder(
                                  future: GradeCal().gradeCalculate(
                                      data['Allergens'],
                                      data['nutrition']['grade']),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text(
                                          '${snapshot.error} occurred',
                                        );
                                      } else {
                                        final data1 = snapshot.data as String;
                                        return SizedBox(
                                          height: 70,
                                          width: 150,
                                          child: scoreColors().scorePic(data1),
                                        );
                                      }
                                    } else {
                                      return const Text("loading...");
                                    }
                                  }))
                            ],
                          );
                        } else {
                          return buildTextShimmer();
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            FutureBuilder(
                future: widget.type
                    ? _scanned.doc(widget.barcode).get()
                    : _search.doc(widget.barcode).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return FutureBuilder(
                        future: GradeCal().gradeCalculateInfo(
                            data['Allergens'], data['nutrition']['grade']),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text(
                                '${snapshot.error} occurred',
                              );
                            } else {
                              final data1 = snapshot.data as String;
                              return Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                    scoreColors().scoreInfo(data1),
                                  ]);
                            }
                          } else {
                            return buildTextShimmer();
                          }
                        }));
                  } else {
                    return buildTextShimmer();
                  }
                })
          ],
        ),
        Container(
          color: Colors.white,
          child: SizedBox(
              width: 380,
              child: FutureBuilder<DocumentSnapshot>(
                future: widget.type
                    ? _scanned.doc(widget.barcode).get()
                    : _search.doc(widget.barcode).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        rowInfo(
                          "Calories",
                          '${data['nutrition']['calories']} kcals',
                          Icon(
                            Ionicons.flame_outline,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                        ),
                        ExpansionTile(
                          title: const Text("Total Fat"),
                          leading: const Icon(
                            Icons.cookie_outlined,
                            size: 30,
                          ),
                          trailing: SizedBox(
                            height: 60,
                            width: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${data['nutrition']['total fat']} g',
                                ),
                                const Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                          childrenPadding: const EdgeInsets.only(left: 60),
                          children: [
                            ListTile(
                              title: const Text('Saturated Fat'),
                              leading: const Icon(
                                Ionicons.water_outline,
                                color: Colors.black,
                              ),
                              trailing: Text(
                                  '${data['nutrition']['saturated fat']} g'),
                            ),
                          ],
                        ),
                        rowInfo(
                          "Sodium",
                          '${data['nutrition']['sodium']} g',
                          Icon(
                            MaterialCommunityIcons.shaker_outline,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                        ),
                        ExpansionTile(
                          title: const Text("Total Carbohydrate"),
                          leading: const Icon(
                            Ionicons.water_outline,
                            size: 30,
                          ),
                          trailing: SizedBox(
                            height: 60,
                            width: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    '${data['nutrition']['total carbohydrate']} g'),
                                const Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                          childrenPadding: const EdgeInsets.only(left: 60),
                          children: [
                            ListTile(
                              title: const Text('Dietary Fiber'),
                              leading: const Icon(
                                MaterialIcons.accessibility_new,
                                color: Colors.black,
                              ),
                              trailing: Text('${data['nutrition']['fiber']} g'),
                            ),
                            ListTile(
                              title: const Text('Total Sugars'),
                              leading: const Icon(
                                Ionicons.cube_outline,
                                color: Colors.black,
                              ),
                              trailing: Text(
                                  '${data['nutrition']['total sugars']} g'),
                            ),
                          ],
                        ),
                        rowInfo(
                          "Protein",
                          '${data['nutrition']['protein']} g',
                          Icon(
                            MaterialCommunityIcons.food_steak,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData && !snapshot.data!.exists) {
                    return const Text("Document does not exist");
                  } else {
                    return buildNutShimmer();
                  }
                },
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Recommendations",
                  style: GoogleFonts.bebasNeue(fontSize: 35),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 210,
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) => Card(
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            width: 200,
                            color: Colors.indigo[400],
                            child: const Center(
                              child: Text('picture'),
                            ),
                          ),
                          const Center(
                            child: Text('title'),
                          )
                        ],
                      ),
                    ))),
        const SizedBox(
          height: 40,
        ),
        InkResponse(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          highlightColor: Colors.indigo,
          highlightShape: BoxShape.rectangle,
          onTap: () {
            //FirebaseCommands().favoriteBarcode(widget.barcode, );
            snackMessage(false, widget.barcode);
          },
          child: Container(
            height: 60,
            width: 350,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                border: Border.all(color: Colors.indigo, width: 2.0)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Favorite',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.favorite_border_outlined,
                      color: Colors.black)
                ],
              ),
            ),
          ),
        ),
        InkResponse(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(10)),
          highlightColor: Colors.indigo,
          highlightShape: BoxShape.rectangle,
          onTap: () {
            FirebaseCommands().destroyBarcode(widget.barcode, true);
            FirebaseCommands().removeFavorite(widget.barcode);
            snackMessage(true, widget.barcode);
          },
          child: Container(
            height: 60,
            width: 350,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                border: Border.all(color: Colors.indigo, width: 2.0)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Delete',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Ionicons.trash_outline, color: Colors.black)
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 70,
        )
      ])),
    );
  }

  Widget buildPicShimmer() => Container(
          child: SizedBox.square(
        dimension: 120,
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            width: 80,
            color: Colors.grey,
          ),
        ),
      ));
  Widget buildTextShimmer() => Container(
        child: ShimmerLoader.rectangular(width: 150, height: 16),
      );

  Widget buildNutShimmer() => Center(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoader.rectangular(width: 350, height: 18),
              ],
            ),
          ],
        ),
      );
}
