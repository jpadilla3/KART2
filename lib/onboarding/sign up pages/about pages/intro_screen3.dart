import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/intropage3.gif'),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Scan your favorite',
              style: GoogleFonts.oswald(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              'food items',
              style: GoogleFonts.oswald(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              'We\'ll provide a rating on each product scanned',
              style: GoogleFonts.oswald(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 125,
            )
          ],
        ),
      ),
    );
  }
}
