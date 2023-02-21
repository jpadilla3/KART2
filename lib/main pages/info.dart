import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        body: CustomScrollView(slivers: [
      SliverAppBar.large(
        backgroundColor: Colors.grey,
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
      
     
        
    ]));
  }
}
