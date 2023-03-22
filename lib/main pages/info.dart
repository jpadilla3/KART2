import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://us.openfoodfacts.org/nutriscore');
final Uri _url2 = Uri.parse('https://us.openfoodfacts.org/');

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void _handleIndexChange(int i) {
    setState(() {});
  }

  @override
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
              Text('Our sources'),
              ElevatedButton(
                onPressed: _launchUrl,
                child: Text('NutriScore'),
              ),
              ElevatedButton(
                onPressed: _launchUrl2,
                child: Text('Open Food Facts'),
              ),
            ],
          )),
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
    throw Exception('Could not launch $_url');
  }
}
