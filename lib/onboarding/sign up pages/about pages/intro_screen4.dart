import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class introScreen4 extends StatelessWidget {
  const introScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 35),
              child: Image.asset('assets/images/Searching.gif'),
            ),
            Text(
              'Search for your favorite',
              style: GoogleFonts.oswald(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              'food products',
              style: GoogleFonts.oswald(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
