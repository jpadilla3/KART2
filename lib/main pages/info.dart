import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://us.openfoodfacts.org/');
final Uri _url2 = Uri.parse('https://world.openfoodfacts.org/nutriscore');

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  String data = '';
  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/Text/About.txt');
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
              color: Colors.indigo[400],
            ),
            title: Text(
              'Information',
              style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "  About Us: ",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "  Our Sources: ",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  color: Colors.white,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () {
                      _launchUrl();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(
                            "assets/images/OpenFoodFacts.png",
                            fit: BoxFit.fitWidth,
                            height: 70,
                            width: 70,
                          ),
                          title: const Text('Open Food Facts'),
                          subtitle: const Text(
                            'Open Food Facts is a non-profit project developed by thousands of volunteers from around the world. You can start contributing by adding a product from your kitchen with our app for iPhone or Android.',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(20),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () {
                      _launchUrl2();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image.network(
                            "https://www.baynsolutions.com/wp-content/uploads/bb-plugin/cache/nutri-score-2-1060x707-panorama.png",
                            height: 70,
                            width: 70,
                          ),
                          title: const Text('Nutriscore'),
                          subtitle: const Text(
                            'Nutri-Score is a new front-of-pack nutrition label that makes it easy to quickly understand the nutritional quality of food products. It is based on scientific evidence and is designed to help consumers make healthier choices.',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw Exception('Could not launch $_url2');
  }
}
