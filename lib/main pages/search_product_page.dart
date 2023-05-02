import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/models/grade_cal.dart';
import 'package:kart2/models/scoreColor.dart';

class SearchProduct extends StatefulWidget {
  final Map<String, dynamic> data;
  const SearchProduct(this.data, {super.key});

  @override
  State<SearchProduct> createState() => SearchProductState();
}

class SearchProductState extends State<SearchProduct> {
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
                width: 125,
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
                  width: 252,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
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

  bool fav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          widget.data['brand'],
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: false,
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox.square(
                        dimension: 180,
                        child: Image.network('${widget.data['pic']}'))
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 180,
                      child: Text(
                        widget.data['name'],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ScoreColors().scorePic(widget.data['grade']),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                FutureBuilder(
                    future: GradeCal().gradeCalculateInfo2(
                        widget.data['allergens'],
                        widget.data['conditions']['vegan'],
                        widget.data['conditions']['vegetarian']),
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
                        return const Text('');
                      }
                    }))
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            //calories
            rowInfo(
              'Calories',
              '${widget.data['nutrients']['calories'].toStringAsFixed(1)} kcals',
              Icon(
                Ionicons.flame_outline,
                size: 30,
                color: Colors.grey[600],
              ),
            ),
            //fat
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
                      '${widget.data['nutrients']['total fat'].toStringAsFixed(1)} g',
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
                      '${widget.data['nutrients']['saturated fat'].toStringAsFixed(1)} g'),
                ),
              ],
            ),
            //sodium
            rowInfo(
              "Sodium",
              '${widget.data['nutrients']['sodium'].toStringAsFixed(1)} g',
              Icon(
                MaterialCommunityIcons.shaker_outline,
                size: 30,
                color: Colors.grey[600],
              ),
            ),
            //carbs
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
                        '${widget.data['nutrients']['total carb'].toStringAsFixed(1)} g'),
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
                      '${widget.data['nutrients']['fiber'].toStringAsFixed(1)} g'),
                ),
                ListTile(
                  title: const Text('Total Sugars'),
                  leading: const Icon(
                    Ionicons.cube_outline,
                    color: Colors.black,
                  ),
                  trailing: Text(
                      '${widget.data['nutrients']['sugar'].toStringAsFixed(1)} g'),
                ),
              ],
            ),
            //protein
            rowInfo(
              "Protein",
              '${widget.data['nutrients']['protein'].toStringAsFixed(1)} g',
              Icon(
                MaterialCommunityIcons.food_steak,
                size: 30,
                color: Colors.grey[600],
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
                height: 225,
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
