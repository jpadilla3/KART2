import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class introScreen2 extends StatelessWidget {
  const introScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/intropage2.png'),
            Text(
              "Input your Food Preferences",
              style: GoogleFonts.oswald(fontSize: 35),
              textAlign: TextAlign.center,
            ),
            Text(
              "We'll provide recommendations based",
              style: GoogleFonts.oswald(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            Text(
              "on these results*",
              style: GoogleFonts.oswald(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Some product's data may be incomplete",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "Always check the information on the product's packaging",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
