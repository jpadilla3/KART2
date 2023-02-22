import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class recommendationsPage extends StatelessWidget {
  const recommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(
            'Recommendations',
            style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
          ),
        )
      ],
    ));
  }
}
