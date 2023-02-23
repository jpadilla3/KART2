import 'package:flutter/material.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen1.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen2.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/intro_screen3.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              onLastPage = (value == 2);
            });
          },
          controller: _controller,
          children: const [introScreen1(), introScreen2(), introScreen3()],
        ),
        Container(
            alignment: Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text("Skip"),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),

                //continue button
                onLastPage
                    ? GestureDetector(
                        child: const Text('Continue'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => navBar()));
                        })
                    : GestureDetector(
                        child: const Text("Next"),
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
