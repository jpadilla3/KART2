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
            Image.network(
                'https://cdn.dribbble.com/users/222613/screenshots/5137558/media/d1bb90a00802d06f0771307da50d70c5.png'),
            Text(
              "Input any medical conditions or allergies",
              style: GoogleFonts.oswald(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Text(
              "We'll provide recommendations based",
              style: GoogleFonts.oswald(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            Text(
              "on these results",
              style: GoogleFonts.oswald(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
