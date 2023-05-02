import "package:flutter/material.dart";
import "package:flutter_font_icons/flutter_font_icons.dart";
import "package:google_fonts/google_fonts.dart";
import "package:ionicons/ionicons.dart" as ion;
import "package:kart2/main%20pages/shimmerlist.dart";
import "package:kart2/models/grade_cal.dart";

import "../models/scoreColor.dart";

class ScanPage extends StatefulWidget {
  Map item;
  ScanPage(this.item);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
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

  Widget buildTextShimmer() => Container(
        child: const ShimmerLoader.rectangular(width: 150, height: 16),
      );

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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          widget.item['brand'],
          style: const TextStyle(fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox.square(
                      dimension: 180,
                      child: Image.network(widget.item['picture']),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 150,
                      width: 180,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.item['name'],
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
                          SizedBox(
                              height: 70,
                              width: 150,
                              child:
                                  ScoreColors().scorePic(widget.item['grade']))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),

            //insert warnings
            Row(
              children: [
                FutureBuilder(
                    future: GradeCal().gradeCalculateInfo(
                        widget.item['allergy'], widget.item['condition']),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error} occurred',
                          );
                        } else {
                          final data1 = snapshot.data as List<String>;
                          return Column(
                            children: [
                              Row(
                                  //vegan
                                  children: [
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    ScoreColors().scoreInfo2(data1[0]),
                                  ]),
                              Row(
                                  //vegetarian
                                  children: [
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    ScoreColors().scoreInfo2(data1[1]),
                                  ]),
                              Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    ScoreColors().scoreInfo3(data1[2]),
                                  ]),
                              Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ScoreColors().scoreInfo(data1[3]),
                                  ]),
                            ],
                          );
                        }
                      } else {
                        return buildTextShimmer();
                      }
                    }))
              ],
            ),

            Container(
              color: Colors.white,
              child: SizedBox(
                width: 380,
                child: Column(
                  children: [
                    rowInfo(
                      "Calories",
                      '${double.parse(widget.item['calories']).toStringAsFixed(0)} kcals',
                      Icon(
                        ion.Ionicons.flame_outline,
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
                              '${double.parse(widget.item['total fat']).toStringAsFixed(1)} g',
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
                            ion.Ionicons.water_outline,
                            color: Colors.black,
                          ),
                          trailing: Text(
                              '${double.parse(widget.item['saturated fat']).toStringAsFixed(1)} g'),
                        ),
                      ],
                    ),
                    rowInfo(
                      "Sodium",
                      '${double.parse(widget.item['sodium']).toStringAsFixed(1)} g',
                      Icon(
                        MaterialCommunityIcons.shaker_outline,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                    ExpansionTile(
                      title: const Text("Total Carbohydrate"),
                      leading: const Icon(
                        ion.Ionicons.water_outline,
                        size: 30,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                '${double.parse(widget.item['total carbohydrate']).toStringAsFixed(1)} g'),
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
                          trailing: Text(
                              '${double.parse(widget.item['fiber']).toStringAsFixed(1)} g'),
                        ),
                        ListTile(
                          title: const Text('Total Sugars'),
                          leading: const Icon(
                            ion.Ionicons.cube_outline,
                            color: Colors.black,
                          ),
                          trailing: Text(
                              '${double.parse(widget.item['total sugars']).toStringAsFixed(1)} g'),
                        ),
                      ],
                    ),
                    rowInfo(
                      "Protein",
                      '${double.parse(widget.item['protein']).toStringAsFixed(1)} g',
                      Icon(
                        MaterialCommunityIcons.food_steak,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
