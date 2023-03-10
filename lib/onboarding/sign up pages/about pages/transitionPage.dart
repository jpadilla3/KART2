import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen1.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen2.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen3.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class aboutPages extends StatefulWidget {
  const aboutPages({super.key});

  @override
  State<aboutPages> createState() => _aboutPagesState();
}

class _aboutPagesState extends State<aboutPages> {
  //keep track of pages
  PageController _controller = PageController();

  bool onLastPage = false;
  bool onFirstPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              onLastPage = (value == 3);
              onFirstPage = (value == 0);
            });
          },
          controller: _controller,
          children: const [
            introScreen1(),
            introScreen2(),
            introScreen3(),
            introScreen4()
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
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                        child: Text(
                          "skip",
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                        ),
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
                  count: 4,
                ),

                //continue button
                onLastPage
                    ? GestureDetector(
                        child: Text(
                          'Continue',
                          style: GoogleFonts.bebasNeue(fontSize: 25),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => navBar()));
                        })
                    : GestureDetector(
                        child: Text(
                          "Next",
                          style: GoogleFonts.bebasNeue(fontSize: 25),
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
