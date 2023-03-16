import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class productPage extends StatefulWidget {
  const productPage({super.key});

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 60,
        ),
        //back button
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 35),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.indigo[400],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            //picture
            Container(
              color: Colors.indigo[400],
              child: const SizedBox.square(
                dimension: 150.0,
                child: Center(
                  child: Text(
                    "picture",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            //item name
            Container(
              color: Colors.red,
              child: const SizedBox(
                height: 150,
                width: 230,
                child: Center(
                  child: Text(
                    'Item name',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            //score
            Container(
              height: 60,
              width: 380,
              color: Colors.limeAccent,
              child: const Center(
                  child: Text(
                "Score: ",
                textAlign: TextAlign.center,
              )),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          child: SizedBox(
              width: 380,
              child: Column(
                children: [
                  rowInfo(
                    "Calories",
                    "230cal",
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
                      width: 41,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            "8g",
                          ),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 60),
                    children: const [
                      ListTile(
                        title: Text('Saturated Fat'),
                        leading: Icon(
                          Ionicons.water_outline,
                          color: Colors.black,
                        ),
                        trailing: Text("1g"),
                      ),
                      ListTile(
                        title: Text('Trans Fat'),
                        leading: Icon(
                          Ionicons.cube_outline,
                          color: Colors.black,
                        ),
                        trailing: Text("0g"),
                      ),
                    ],
                  ),
                  rowInfo(
                    "Cholesterol",
                    "160mg",
                    Icon(
                      Ionicons.cube_outline,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                  ),
                  rowInfo(
                    "Sodium",
                    "3g",
                    Icon(
                      Ionicons.fish_outline,
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
                      width: 41,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text("3g"),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 60),
                    children: const [
                      ListTile(
                        title: Text('Dietary Fiber'),
                        leading: Icon(
                          Ionicons.accessibility,
                          color: Colors.black,
                        ),
                        trailing: Text("4g"),
                      ),
                      ListTile(
                        title: Text('Total Sugars'),
                        leading: Icon(
                          Ionicons.cube_outline,
                          color: Colors.black,
                        ),
                        trailing: Text("12g"),
                      ),
                    ],
                  ),
                  rowInfo(
                    "Protein",
                    "3g",
                    Icon(
                      Ionicons.fish_outline,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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
        InkResponse(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          highlightColor: Colors.indigo,
          highlightShape: BoxShape.rectangle,
          onTap: () {},
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
          onTap: () {},
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
        SizedBox(
          height: 30,
        )
      ])),
    );
  }
}
