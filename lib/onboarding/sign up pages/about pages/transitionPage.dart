import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen1.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen2.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen3.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen4.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen5.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen6.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:kart2/onboarding/sign up pages/Conditions/Allergies.dart';
import 'package:kart2/models/firebase_commands.dart';

class AboutPages extends StatefulWidget {
  const AboutPages({super.key});

  @override
  State<AboutPages> createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  //keep track of pages
  PageController _controller = PageController();

  bool onLastPage = false;
  bool onFirstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              onLastPage = (value == 5);
              onFirstPage = (value == 0);
            });
          },
          controller: _controller,
          children: const [
            introScreen1(),
            introScreen2(),
            introScreen3(),
            introScreen4(),
            introScreen5(),
            introScreen6(),
          ],
        ),
        Container(
            alignment: Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onFirstPage
                    ?
                    //skip
                    GestureDetector(
                        child: Text(
                          "skip",
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                        ),
                        onTap: () {
                          _controller.jumpToPage(5);
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "back",
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                        ),
                      ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 6,
                ),

                //continue button
                onLastPage
                    ? GestureDetector(
                        child: Text(
                          'Continue',
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                          key: const Key('continue'),
                        ),
                        onTap: () {
                          FirebaseCommands().updateUser2();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Conditions()));
                        })
                    : GestureDetector(
                        child: Text(
                          "Next",
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                          key: const Key('next'),
                        ),
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                      )
              ],
            ))
      ],
    ));
  }
}
