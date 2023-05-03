import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class iconLegend extends StatefulWidget {
  const iconLegend({Key? key}) : super(key: key);

  @override
  State<iconLegend> createState() => _iconLegendState();
}

class _iconLegendState extends State<iconLegend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.indigo[400],
            ),
            title: Text(
              'Icons Legend',
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
            ),
          ),
          SliverToBoxAdapter(
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.indigo,
                              size: 55,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scan Products',
                            style: GoogleFonts.oswald(fontSize: 20),
                          ),
                          Text(
                            "When pressed, you may scan your product's ",
                            style: GoogleFonts.oswald(fontSize: 15),
                          ),
                          Text(
                            'barcode to view its nutritional information',
                            style: GoogleFonts.oswald(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Image.asset(
                              'assets/images/NutriScore.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nutritional Grade Scale',
                            style: GoogleFonts.oswald(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'A = Highest Nutrition - E = Lowest Nutrition',
                            style: GoogleFonts.oswald(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.red,
                            size: 55,
                          ),
                        ),
                      ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Allergen Warning',
                            style: GoogleFonts.oswald(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Appears when product may contain an allergen ',
                            style: GoogleFonts.oswald(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'you have',
                            style: GoogleFonts.oswald(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.eco_outlined,
                            color: Colors.green,
                            size: 55,
                          ),
                        ),
                      ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vegetarian Friendly',
                            style: GoogleFonts.oswald(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Appears when product is vegetarian friendly',
                            style: GoogleFonts.oswald(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: Icon(
                            Icons.energy_savings_leaf,
                            color: Colors.green,
                            size: 55,
                          ),
                        ),
                      ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vegan Products',
                            style: GoogleFonts.oswald(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Appears when the product is vegan ',
                            style: GoogleFonts.oswald(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 26),
                            child: Image.asset(
                              'assets/images/milk.png',
                              height: 55,
                              width: 55,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lactose Intolerant',
                            style: GoogleFonts.oswald(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Appears when product contains lactose',
                            style: GoogleFonts.oswald(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
