import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class introScreen6 extends StatelessWidget {
  const introScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 50),
              child: Image.asset('assets/images/KART.gif'),
            ),
            Text(
              "You're All Set!",
              style: GoogleFonts.oswald(fontSize: 40),
            ),
            Text(
              "Previous pages will be on information page",
              style: GoogleFonts.oswald(fontSize: 22),
            ),
            Text(
              "on top right corner button on main page",
              style: GoogleFonts.oswald(fontSize: 22),
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
